---
title: Pushing ISLE to Staging
publishDate: 2019-12-13
lastmod: 2019-12-18T13:23:34-05:00
draft: false
tags:
  - ISLE
  - isle-stage.grinnell.edu
  - DGDockerX
  - staging
  - development
  - git config core.fileMode
  - systemctl disable firewalld
---

This post chronicles the steps I took to push my local `dg.localdomain` project, an ISLE v1.3.0 build, to staging on node `DGDockerX` as `https://isle-stage.grinnell.edu` using my [dg-isle](https://github.com/Digital-Grinnell/dg-isle) and [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora) repositories.

## Directories
I'll begin by opening a terminal on the staging host, `DGDockerX` as user `islandora`.  Then I very carefully (note the use of the `--recursive` flags!) clone the aforementioned projects to `DGDockerX` like so:

| Host / DGDockerX Commands |
| --- |
| cd /opt <br/> git clone --recursive https://github.com/Digital-Grinnell/dg-isle.git <br/> git clone --recursive https://github.com/Digital-Grinnell/dg-islandora.git <br/> cd dg-isle <br/> git checkout staging |

## One Useful Git Config Change
One thing I learned during this process is that all of the `dg-isle` config files that I’ve modified and/or mapped into the containers show up as “modified” when I do a `git status` on the host.  The only apparent “modification” is that these are all owned on the host by `mcfatem:mcfatem`, but prior to spin-up these were owned by `islandora:islandora`.  The files/directories are:

  - `config/apache/settings_php/settings.staging.php`,
  - `config/fedora/gsearch/foxmlToSolr.xslt`,
  - `config/fedora/gsearch/islandora_transforms/`, and
  - `config/solr/schema.xml`

This is apparently a known condition that does no harm, but it can be easily ignored by specifying:

| Host / DGDockerX Commands |
| --- |
| cd /opt/dg-isle <br/> git config core.fileMode false |

Thank you, [Noah Smith](https://app.slack.com/team/U2ZC9KMCK) for sharing that bit of wisdom!

## Disable the Local Firewall!
While working through this process I encountered one major setback... after successfully configuring most of the stack I encountered something that forced me to reboot the server.  When I did that the local firewall was restarted and I subsequently could not reach my staging site.  Eeeeeek!  The fix required that I run `systemctl disable firewalld` and `systemctl stop firewalld` so that the local firewall, and IPTables, would cease to run and not attempt to restart after every reboot.

## Starting the Stack
Having cloned the projects to the host as indicated above, we visit our host terminal and...

| Host / DGDockerX Commands |
| --- |
| cd /opt/dg-isle <br/> docker-compose up -d <br/> docker logs -f isle-apache-dg |

The startup will take a couple of minutes, and it does not "signal" when it's done, so that's the reason for the last command above.  The `-f` flag in that command will cause the log output to update continuously on screen, so you do not have to repeat it. You'll know that the startup is complete when you see the following at the bottom of the log output:

```
...
Done setting proper permissions on files and directories
XDEBUG OFF
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.0.7. Set the 'ServerName' directive globally to suppress this message
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.0.7. Set the 'ServerName' directive globally to suppress this message
[Mon Dec 16 18:28:44.428224 2019] [mpm_prefork:notice] [pid 67455] AH00163: Apache/2.4.41 (Ubuntu) configured -- resuming normal operations
[Mon Dec 16 18:28:44.428317 2019] [core:notice] [pid 67455] AH00094: Command line: '/usr/sbin/apache2 -D FOREGROUND'
```

Once the process is complete just enter `control-c` in the terminal window to get your prompt back.

## Re-Indexing FEDORA and Solr
Before going farther, it will probably be necessary to re-index FEDORA and Solr.  You can do so following the guidance provided in [DG-FEDORA: A Portable FEDORA Repository](https://static.grinnell.edu/blogs/McFateM/posts/046-dg-fedora-a-portable-object-repository/) with two changes:

  1. Our "portable" _FEDORA_ repository isn't on a USB stick, it is mounted at `/mnt/data/DG-FEDORA` rather than `/Volumes/DG-FEDORA`, and
  2. Our containers are named `isle-<service>-dg`, not `isle-<service>-ld`.

## Warnings About the "Private" Filesystem
Now when I visit the site and clear the cache I see lots of warnings like this:

```
Warning: file_put_contents(private:///.htaccess): failed to open stream: &quot;DrupalPrivateStreamWrapper::stream_open&quot; call failed in file_put_contents() (line 496 of /var/www/html/includes/file.inc). =>
```
I open a `bash` shell in the _Apache_ container and see that the `/var/www/private` directory is properly owned by `islandora:www-data`, but it isn't writable by `www-data`, so let's change that and see if the warnings go away...

| Apache Container Commands |
| --- |
| cd /var/www <br/> chmod 775 private |

A browser visit to [the site's status report](https://isle-stage.grinnell.edu/admin/reports/status) shows no warnings and no issues with the private filesystem now.  The report does show that some database updates are required, so I'll use the link provided in the report to run those now.  Done.

## Some Settings Are Missing
I found some settings were missing the first time I started the stack like this.  A little research and debugging led me to believe that not all of the required configuration commands had been executed properly.  In particular, I found that my large image (TIFF image) viewer wasn't displaying anything at all, presumably because the database I imported from production was setup to use Adore-Djatoka, not IIIF Cantaloupe. The remedy was to take a snapshot of the server, then run the required `migration_site_vsets.sh` script inside the _Apache_ container.  Unfortunately that didn't work for me at first and I got lots of messages indicating that `Command variable-set needs a higher bootstrap level to run...`. That error basically means that the `drush` commands inside the script need to be run from the appropriate directory so that `drush` can find the site and its database.  So, to run it properly inside the _Apache_ container...

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/default <br/> /utility-scripts/isle_drupal_build_tools/migration_site_vsets.sh |

Note the `cd` command and path before the script is run, and there's no "dot" in front of `/utility-scripts...`.  This time everything worked except for a `phpmailerException` at the end of the run, but that's of no consequence, and to be expected since this is a staging server and has no mail facilities of its own.

A quick visit to [the staging site](https://isle-stage.grinnell.edu]) shows that large images (for example see https://isle-stage.grinnell.edu/islandora/object/grinnell:25511) are working properly.  It sure would be nice to have an automated test to verify that for me, automatically... but we'll address that issue a little later in this post.  :smile:

## Missing CModels and No PDF Viewer
While visiting the site moments ago I noticed two more issues:

  - At https://isle-stage.grinnell.edu/admin/islandora/solution_pack_config/solution_packs the Binary cModel is missing, and
  - A visit to https://isle-stage.grinnell.edu/islandora/object/grinnell:25500 shows a JPEG image of a single page, but since this object is a multi-page PDF, we are obviously missing our PDF viewer.

So, remember back in the [Installing the Missing Islandora and Custom Modules](https://static.grinnell.edu/blogs/McFateM/posts/058-rebuilding-isle-ld/installing-the-missing-islandora-and-custom-modules) section of [post 058](https://static.grinnell.edu/blogs/McFateM/posts/058-rebuilding-isle-ld/), we commented out the installation of `islandora_binary_object` and `islandora_pdfjs_reader` like so:

```
cd /var/www/html/sites/all/modules/islandora
git submodule add https://github.com/DigitalGrinnell/dg7.git
git submodule add https://github.com/DigitalGrinnell/idu.git
# git submodule add git://github.com/discoverygarden/islandora_binary_object.git
git submodule add https://github.com/discoverygarden/islandora_collection_search
git submodule add https://github.com/DigitalGrinnell/islandora_mods_display.git
git submodule add https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git
# git submodule add git://github.com/nhart/islandora_pdfjs_reader.git
git submodule add https://github.com/Islandora-Labs/islandora_solr_collection_view.git
chown -R islandora:www-data *
cd /var/www/html/sites/default
drush cc all
```

Well, it's evidently time to put them back! So, I'm taking a new snapshot before attempting to do so.

## Islandora PDFjs
A quick search on the web for `Islandora PDFjs` reveals that the old `github.com/nhart/islandora_pdfjs_reader.git` repository we previously used in _Digital.Grinnell_ has been replaced in _Islandora_ version 7 by `https://github.com/Islandora/islandora_pdfjs`.  An examination of our `dg-islandora` project (on the host at `/opt/dg-islandora`) shows that the `islandora_pdfjs` module is already installed at `/opt/dg-islandora/sites/all/modules/islandora/islandora_pdfjs` with the required libraries already at `/opt/dg-islandora/sites/all/libraries/pdfjs`, but its installation is incomplete and it's evidently not enabled.  So, lets follow the installation and configuration instructions found in https://github.com/Islandora/islandora_pdfjs/blob/7.x/README.md, like so:

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/default <br/> drush en islandora_pdfjs -y <br/> drush cc all |

Then visit https://isle-stage.grinnell.edu/admin/islandora/solution_pack_config/pdf in your browser and select the `pdf.js Reader` as the viewer, and save the configuration.

Now visit https://isle-stage.grinnell.edu/islandora/object/grinnell:25500 to confirm if the viewer is working.  **It works!**  Time to make another database backup, and snapshot the host again.  

## Binary Objects
The https://github.com/discoverygarden/islandora_binary_object repository that _Digital.Grinnell_ formerly used is now home to an _Islandora_ version 8 module.  That won't do.  Fortuntely, there is a version 7 copy of the old binary content model residing at https://github.com/Islandora-Labs/islandora_binary_object.

There's no mention of `islandora_binary_object` in the host's `/opt/dg-islandora/.gitmodules` file, so lets add this submodule with the following commands executed from the host:

| Host / DGDockerX Commands |
| --- |
| sudo su <br/> cd /opt/dg-islandora <br/> git submodule add https://github.com/Islandora-Labs/islandora_binary_object sites/all/modules/islandora/islandora_binary_object <br/> chown -R mcfatem:33 sites/all/modules/islandora/. chown -R mcfatem:33 sites/all/modules/islandora/. |



## Database Backup
This is probably a good time to backup and save the site's _Drupal_ database.  Since I'm logged in to the site as "System Admin" I have access to the `Quick Backup` block in the lower-right corner of the site's home page.  I'll change the `Backup Destination` to "Manual Backup Directory" and click `Backup now` with all other settings left as-is.

What I got in return were three messages stating:

  - Site was taken offline.
  - Site was taken online.
  - Default Database backed up successfully to DigitalGrinnell-2019-12-18T16-04-59 (3.3 MB) in destination Manual Backups Directory in 2 sec. (download, restore, delete)

The `docker-compose.staging.yml` file shows me that our "public" filesystem is mapped from the _Apache_ container back to the host at `/mnt/data/DG-FEDORA/site-public/`, so the backup should be on the host (DGDockerX) in `/mnt/data/DG-FEDORA/site-public/backup_migrate/manual`.  Sure enough, the file indicated above is there along with a similarly named `.info` file containing a manifest of the operation.



Not quite a wrap.  Be back soon...
