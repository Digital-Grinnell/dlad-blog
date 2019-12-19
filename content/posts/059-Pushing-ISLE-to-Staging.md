---
title: Pushing ISLE to Staging
publishDate: 2019-12-13
lastmod: 2019-12-13T14:23:34-05:00
draft: false
tags:
  - ISLE
  - isle-stage.grinnell.edu
  - DGDockerX
  - staging
  - development
  - git config core.fileMode
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

## Starting the Stack
Having cloned the projects to the host as indicated above, we visit our host terminal and...

| Host / DGDockerX Commands |
| --- |
| cd /opt/dg-isle <br/> docker-compose up -d <br/> docker logs -f isle-apache-dg |

The startup will take a couple of minutes, and it does not "signal" when it's done, so that's the reason for the last command above.  The `-f` option will keep the output spooling to your terminal so that you don't have to keep repeating the command over and over again.  You will know the startup is complete when you see the following at the bottom of the log output:

```
...
Done setting proper permissions on files and directories
XDEBUG OFF
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.0.7. Set the 'ServerName' directive globally to suppress this message
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.0.7. Set the 'ServerName' directive globally to suppress this message
[Mon Dec 16 18:28:44.428224 2019] [mpm_prefork:notice] [pid 67455] AH00163: Apache/2.4.41 (Ubuntu) configured -- resuming normal operations
[Mon Dec 16 18:28:44.428317 2019] [core:notice] [pid 67455] AH00094: Command line: '/usr/sbin/apache2 -D FOREGROUND'
```

Press `ctrl-c` to interrupt the `docker logs...` command and get your terminal back.

## Some Settings Are Missing
I found some settings were missing the first time I started the stack like this.  A little research and debugging led me to believe that not all of the required configuration commands had been executed properly.  In particular, I found that my large image (TIFF image) viewer wasn't displaying anything at all, presumably because the database I imported from production was setup to use Adore-Djatoka, not IIIF Cantaloupe. The remedy was to take a snapshot of the server, then run the required `migration_site_vsets.sh` script inside the _Apache_ container.  Unfortunately that didn't work for me at first and I got lots of messages indicating that `Command variable-set needs a higher bootstrap level to run...`. That error basically means that the `drush` commands inside the script need to be run from the appropriate directory so that `drush` can find the site and its database.  So, to run it properly inside the _Apache_ container...

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/default <br/> /utility-scripts/isle_drupal_build_tools/migration_site_vsets.sh |

Note the `cd` command and path before the script is run, and there's no "dot" in front of `/utility-scripts...`.  This time everything worked except for a `phpmailerException` at the end of the run, but that's of no consequence, and to be expected since this is a staging server and has no mail facilities of its own.

A quick visit to [the staging site](https://isle-stage.grinnell.edu]) shows that large images (for example see https://isle-stage.grinnell.edu/islandora/object/grinnell:25511) are working properly.  It sure would be nice to have an automated test to verify that for me, automatically... but we'll address that issue a little later in this post.  :smile:

## Backup the Site Database
For now, let's just make a backup of the site database for safe-keeping. We can do this by visiting the [site's home page](https://isle-stage.grinnell.edu) and using the `Quick Backup` block at the bottom of the right-hand sidebar and selecting `Backup Destination: Manual Backups Directory`.  This operation makes a backup of the site database and stores it in a pre-determined place... in our case the `docker-compose.staging.yml` configuration file tells us that it's stored somewhere in `/mnt/data/DG-FEDORA/site-public`.  More specifically, this backup is `/mnt/data/DG-FEDORA/site-public/backup_migrate/manual/DigitalGrinnell-2019-12-17T15-03-10.mysql.gz` on the host, `DGDockerX`.

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

Well, it's evidently time to put them back! So, I'm taking a new snapshot of the server then I'll try to solve this mystery.  A little research tells me that the `islandora_binary_object` command above is pointing to the wrong project for Islandora v7 (it points to an Islandora v8 module). Also, the `islandora_pdfjs_reader` module has apparently been replaced by `islandora_pdfjs`, and it just requires some additional configuration.  So, the entire command stream on the host should be:

| Host / DGDockerX Commands |
| --- |
| sudo su <br/> cd /opt/dg-islandora <br/> git submodule add https://github.com/Islandora-Labs/islandora_binary_object sites/all/modules/islandora/islandora_binary_object <br/> chown -R islandora:www-data * |

A look at the `Installation` and `Configuration` guidance provided in the [islandora_pdfjs module's README.md file](https://github.com/Islandora/islandora_pdfjs) suggests that I need to do a little more work in the _Apache_ container so I did as it said, then selected the new PDF viewer at

  Then taking a look at our example PDF object, https://isle-stage.grinnell.edu/islandora/object/grinnell:25500, shows that it works!

## Binary Objects

The https://github.com/discoverygarden/islandora_binary_object repository that _Digital.Grinnell_ formerly used is now home to an _Islandora_ version 8 module. :sad: That won't do. Fortuntely, there is a version 7 copy of the old binary content model residing at https://github.com/Islandora-Labs/islandora_binary_object.

There's no mention of `islandora_binary_object` in the host's `/opt/dg-islandora/.gitmodules` file, so lets add this submodule with the following commands executed from the host:

| Host / DGDockerX Commands |
| --- |
| sudo su <br/> cd /opt/dg-islandora <br/> git submodule add https://github.com/Islandora-Labs/islandora_binary_object sites/all/modules/islandora/islandora_binary_object <br/> chown -R mcfatem:33 sites/all/modules/islandora/. |

Next step then is to enable the new module, and I did this by visiting [the site's module administration page](https://isle-stage.grinnell.edu/admin/modules). But when I toggled the `Islandora Binary Object Storage` on and submitted the form I got this:

```
DatabaseSchemaObjectExistsException: Table islandora_binary_object_thumbnail_associations already exists. in DatabaseSchema->createTable() (line 663 of /var/www/html/includes/database/schema.inc).
DatabaseSchemaObjectExistsException: Table islandora_binary_object_thumbnail_mappings already exists. in DatabaseSchema->createTable() (line 663 of /var/www/html/includes/database/schema.inc).
```

Apparently the offending tables, presumably database leftovers from the production site, need to be removed before the new module can be installed.  So, in the _Apache_ container I'll run this:

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/default <br/> drush sql-query "drop table islandora_binary_object_thumbnail_associations" <br/> drush sql-query "drop table islandora_binary_object_thumbnail_mappings" <br/> drush dis islandora_binary_object -y <br/> drush en islandora_binary_object -y <br/> drush cc all |

That seems to have done the trick.  I'll test it in the morning to confirm, right after another database backup.

## Backup the Site Database, Again
Once again, we will visit the [site's home page](https://isle-stage.grinnell.edu) and use the `Quick Backup` block at the bottom of the right-hand sidebar and selecting `Backup Destination: Manual Backups Directory`.  This time our backup is `/mnt/data/DG-FEDORA/site-public/backup_migrate/manual/DigitalGrinnell-2019-12-18T21-14-02.mysql.gz` on the host, `DGDockerX`.


Not quite a wrap.  Be back soon...
