---
title: Staging Digital.Grinnell (DG) on DigitalOcean (DO)
publishDate: 2020-02-11
lastmod: 2020-03-02T16:13:08-06:00
draft: false
tags:
  - ISLE
  - Digital.Grinnell
  - DigitalOcean
  - development
  - staging
  - https://staging.summittservices.com
---

ISLE v1.3.0 has been running on my staging server, `DGDockerX`, for months now and it seems to be performing as-expected with one exception... when I try to import a batch of objects using IMI, the _Islandora Multi-Importer_, I get the following error:

```
The website encountered an unexpected error. Please try again later.
```

Examinations of [Recent log messages](https://isle-stage.grinnell.edu/admin/reports/dblog) seem to point to _DNS_ issues that I'm unable to overcome because I have no control over our _DNS_ records, campus networking, or firewalls. So this post is intended to chronicle steps I'm taking to stand-up an instance of [dg-isle](https://github.com/Digital-Grinnell/dg-isle) and [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora) on a "clean" _DigitalOcean_ droplet, namely _summitt-services-droplet-01_, that I have been leasing for the past couple of years.

## Directories

I'll begin by opening a terminal on my workstation/host and subsequently a terminal into the aforementioned droplet where I'll login as user `centos` with a `UID` of `1000`.  Once I'm in there I'll also clone the two aformentioned _GitHub_ repositories to the _DO_ host, like so:

| summitt-services-droplet-01 Host Commands, as user `centos` |
| --- |
| cd /home/centos/opt <br/> git clone --recursive https://github.com/Digital-Grinnell/dg-isle.git <br/> git clone --recursive https://github.com/Digital-Grinnell/dg-islandora.git |

Next, I'll attempt to `rsync` the contents of my `DG-FEDORA` directory from `DGDockerX` (IP address: `132.161.132.101`), my original staging server, to the aforementioned _DigitalOcean_ droplet/host (public IP address: `165.227.83.186`).

| summitt-services-droplet-01 Host Commands, as user `centos` |
| --- |
| mkdir /home/centos/data <br/> sudo mkdir -p /mnt/data/DG-FEDORA <br/> sudo chown -R centos:centos /mnt/data <br/> rsync -aruvi islandora@132.161.132.101:/mnt/data/DG-FEDORA/. /mnt/data/DG-FEDORA/ --progress |

Note that the above `rsync` command **DID NOT WORK**, so I tried reversing the process by opening a VPN connection to _Grinnell College_, opening a terminal on _DGDockerX_, and "pushing" the files to _summitt-services-droplet-01_, but this also FAILED, presumably due to network/communications issues. So, ultimately I used a series of `rsync` commands to "pull" the files to my local workstation, then "push" them out to _summitt-services-droplet-01_.

So, in the end, the contents of `dgdockerx.grinnell.edu:/mnt/data/DG-FEDORA` were copied to `summitt-services-droplet-01:/mnt/data/DG-FEDORA` where the directory looks like this:

```
drwxrwxr-x.  10 centos centos  275 Feb 11 13:37 .
drwxrwxrwx.   3 root   root     23 Feb 10 10:19 ..
drwxrwxrwx. 236 centos centos 4.0K Dec 17 14:53 datastreamStore
-rwxrwxrwx.   1 centos centos  211 Dec 23 11:15 DG-FEDORA-0.md
-rwxrwxrwx.   1 centos centos 1.1K Oct  5 09:36 docker-compose.DG-FEDORA.yml
drwxrwxrwx.   2 centos centos  172 Dec 12 18:21 Extras
drwxr-xr-x.   3 centos centos   85 Nov 11 14:10 from-DGDocker1
drwx------.   2 centos centos   28 Dec  1 14:44 .fseventsd
-rwxrwxrwx.   1 centos centos  11K Oct  4 12:28 local.env
drwxrwxrwx. 184 centos centos 4.0K Dec 13 12:51 objectStore
-rwxrwxrwx.   1 centos centos 5.1K Dec 23 11:09 README.md
drwxrwx---.   2 centos centos    6 Dec 17 14:47 site-public
drwxrwxrwx.   7 centos centos  131 Oct  9 23:17 Storage
drwxrwxrwx.   2 centos centos   53 Mar 12  2019 System Volume Information
```

Note that the above directory and all its contents are owned by `centos:centos`.

## Modifying the Environment (.env)

Next, I opened a terminal on _summitt-services-droplet-01_, did `cd ~/opt/dg-isle; git checkout staging` and used `sudo nano` to edit files as necessary. The edits have all been saved and pushed back to the `staging` branch of https://GitHub/Digital-Grinnell/dg-isle.

The new `.env` file includes a second "staging" configuration block, the first is commented out, and second block refers to `docker-compose.staging2.yml`, a new file duplicated from `docker-compose.staging.yml`, but with modifications made explicitly for the `summitt-services-droplet-01` server.

## Launch the Staging.SummittServices.com Stack

Having edited all necessary files, I will launch the `staging` stack using:

| summitt-services-droplet-01 Host Commands, as user `centos` |
| --- |
| cd ~/opt/dg-isle <br/> git checkout staging </br> docker-compose up -d <br/> docker logs -f isle-apache-dg |

The startup will take a couple of minutes, and it does not "signal" when it's done, so that's the reason for the last command above.  The `-f` option will keep the output spooling to your terminal so that you don't have to keep repeating the command over and over again.  You will know the startup is complete when you see something like the following at the bottom of the log output:

```
...
Done setting proper permissions on files and directories
XDEBUG OFF
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.16.7. Set the 'ServerName' directive globally to suppress this message
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.16.7. Set the 'ServerName' directive globally to suppress this message
[Tue Feb 11 18:32:35.664921 2020] [mpm_prefork:notice] [pid 12683] AH00163: Apache/2.4.41 (Ubuntu) configured -- resuming normal operations
[Tue Feb 11 18:32:35.665016 2020] [core:notice] [pid 12683] AH00094: Command line: '/usr/sbin/apache2 -D FOREGROUND'
```

Press `ctrl-c` to interrupt the `docker logs...` command and get your terminal back.

A visit to https://staging.summittservices.com yields an SQL error so it looks like we haven't quite created a viable staging instance of _Digital.Grinnell_, yet.  The next logical step is to backup the database from https://isle-stage.grinnell.edu, and import it here.

## Backup the Site Database

Let's begin by visiting the [original staging site's home page](https://isle-stage.grinnell.edu) (VPN connection may be required) and using the `Quick Backup` block at the bottom of the right-hand sidebar.  Normally I would select a `Backup Destination: Manual Backups Directory` option to save the database backup on the server, but in this case it will be advantageous to have the backup in-hand, locally.  So, I choose `Backup Destination: Download` instead, and the result is in my local `~/Downloads` directory, specifically:

`/Users/mark/Downloads/DigitalGrinnell-2020-02-11T12-46-36.mysql.gz`

## Upload and Import the Database

I uploaded the database to _summitt-services-droplet-01_ like so:

| Local Workstation Commands |
| --- |
| cd ~/Downloads <br/> rsync -aruvi DigitalGrinnell-2020-02-11T12-46-36.mysql.gz centos@165.227.83.186:/home/centos/ --progress |

Then, in a terminal on _summitt-services-droplet-01_ as user `centos`...

| summitt-services-droplet-01 Host Commands, as user `centos` |
| --- |
| cd ~ <br/> gunzip DigitalGrinnell-2020-02-11T12-46-36.mysql.gz <br/> sudo mv -f DigitalGrinnell-2020-02-11T12-46-36.mysql /mnt/data/DG-FEDORA/DG.sql |

## Import the Database Backup Locally

Since the site is not working I cannot use `drush` nor `Backup and Migrate` to do this, so I opened a terminal in the _MySQL_ container, namely `isle-mysql-dg` and did this:

| MySQL Container Commands |
| --- |
| mysql -u root -p digital_grinnell <br/> # Supply root MySQL password # <br/> CREATE DATABASE IF NOT EXISTS digital_grinnell; <br/> USE digital_grinnell; <br/> source /temp/DG.sql |

## White Screen of Death

Sorry, I had to jump to another project for the past couple of weeks, and now that I'm back (March 2, 2020) the situation is not good.  :frowning:  When I visit https://staging.summittservices.com now I get a dreaded **WSOD**.  So I peek at the _Apache_ container logs using `docker logs isle-apache-ld` and find this:

```
[Mon Mar 02 20:35:50.641509 2020] [php7:error] [pid 12676] [client 192.168.176.4:44300] PHP Fatal error:  require_once(): Failed opening required '/var/www/html/sites/all/modules/islandora/islandora_multi_importer/vendor/autoload.php' (include_path='.:/usr/share/php') in /var/www/html/sites/all/modules/islandora/islandora_multi_importer/islandora_multi_importer.module on line 19

```

Bottom line, there are critical issues with IMI, the _Islandora Multi-Importer_, just as there were in staging.  Hmmm, what to do now?

## Fixing IMI

I open a terminal into the _Apache_ container and attempt to repair/re-install _IMI_ like so:

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/all/modules/islandora/islandora_multi-importer <br/> git remote -v </br> git status </br> composer install |

The commands and output from all of this are reflected [in this gist](https://gist.github.com/SummittDweller/92673db4c1ef3274822f47666057e7de).

Now, a visit to [https://staging.summittservices.com](https://staging.summittservices.com) yields a very welcome "Site under maintenance" page.  That's progress!  Let's take the site out of "maintenance mode" using that same _Apache_ container terminal session, like so:

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/default<br/> drush vset maintenance_mode 0 |

That worked, but also returned a handful of warnings summarized by these two:

```
Warning: file_put_contents(private:///.htaccess): failed to open stream: "DrupalPrivateStreamWrapper::stream_open" call failed in file_create_htaccess() (line 496 of /var/www/html/includes/file.inc).
User warning: The following module is missing from the file system: islandora_binary_object. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
```

Looks like we have a missing module and at least one file/directory permissions issue.

## Addressing "Private" Directory Permissions

To address the permissions issue I logged in to the site as "System Admin" and visited [https://staging.summittservices.com/admin/config/media/file-system](https://staging.summittservices.com/admin/config/media/file-system) where I see that our "private" file system path is: `/var/www/private`.

Back to my _Apache_ container terminal to have a look at that...  Aha, `/var/www/private` does indeed exist, but it has ownership and protections inside the container of: `drwxr-xr-x.  2 root      root        6 Feb 10 16:18 private/`.  Let's set the owner and group here to match other directories, specifically: `islandora:www-data`.

| Apache Container Commands |
| --- |
| cd /var/www <br/> chown -R islandora:www-data private <br/> cd /var/www/html/sites/default<br/> drush vset maintenance_mode 0 |

Woot!  The permissions warnings are gone.

## Addressing the Missing `islandora_binary_object` Warning

So, remember back in the [Installing the Missing Islandora and Custom Modules](/posts/058-rebuilding-isle-ld/installing-the-missing-islandora-and-custom-modules) section of [post 058](/posts/058-rebuilding-isle-ld/), we commented out the installation of `islandora_binary_object` like so:

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

Well, it's evidently time to put that back!  So, I'm taking a new snapshot of the server then I'll try to solve this mystery.  A little research tells me that the `islandora_binary_object` command above is pointing to the wrong project for _Islandora_ v7 (it points to an _Islandora_ v8 module), so we require some additional configuration on the host, like so:

| Host / summitt-services-droplet-01 Commands |
| --- |
| sudo su <br/> cd /opt/dg-islandora <br/> git submodule add https://github.com/Islandora-Labs/islandora_binary_object sites/all/modules/islandora/islandora_binary_object <br/> chown -R islandora:www-data * |



<!--


## Will the Same Fixes Work on Staging?

Only one way to find out.  First, I'm going to snapshot the `DGDockerX` staging server.  Done.  Then...

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/all/modules/islandora/islandora_multi-importer </br> composer install |

And the output this time says:

```
root@60ccb7d0ae42:/var/www/html/sites/all/modules/islandora/islandora_multi_importer# composer install
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Nothing to install or update
Package phpoffice/phpexcel is abandoned, you should avoid using it. Use phpoffice/phpspreadsheet instead.
Package silex/silex is abandoned, you should avoid using it. Use symfony/flex instead.
Generating autoload file
```

So, to fix this I tried, and got back this:

```
root@60ccb7d0ae42:/var/www/html/sites/all/modules/islandora/islandora_multi_importer# composer install
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Nothing to install or update
Package phpoffice/phpexcel is abandoned, you should avoid using it. Use phpoffice/phpspreadsheet instead.
Package silex/silex is abandoned, you should avoid using it. Use symfony/flex instead.
Generating autoload files
root@60ccb7d0ae42:/var/www/html/sites/all/modules/islandora/islandora_multi_importer#
root@60ccb7d0ae42:/var/www/html/sites/all/modules/islandora/islandora_multi_importer#
root@60ccb7d0ae42:/var/www/html/sites/all/modules/islandora/islandora_multi_importer#
root@60ccb7d0ae42:/var/www/html/sites/all/modules/islandora/islandora_multi_importer# composer remove phpoffice/phpexcel silex/silex
Loading composer repositories with package information
The "https://repo.packagist.org/packages.json" file could not be downloaded: php_network_getaddresses: getaddrinfo failed: Temporary failure in name resolution
failed to open stream: php_network_getaddresses: getaddrinfo failed: Temporary failure in name resolution
https://repo.packagist.org could not be fully loaded, package information was loaded from the local cache and may be out of date
Updating dependencies (including require-dev)

  [Composer\Downloader\TransportException]
  The "http://repo.packagist.org/p/cache/taggable-cache%247eb77da84984bd6522fb9e3e91f4f82107555cba862c9f161cd3ff697dcc6f7c.json" file could not be downloaded: php_network_getaddresses: getaddrinfo failed: Temporary failure in name resolution
  failed to open stream: php_network_getaddresses: getaddrinfo failed: Temporary failure in name resolution

remove [--dev] [--no-progress] [--no-update] [--no-scripts] [--update-no-dev] [--update-with-dependencies] [--no-update-with-dependencies] [--ignore-platform-reqs] [-o|--optimize-autoloader] [-a|--classmap-authoritative] [--apcu-autoloader] [--] <packages> (<packages>)...
```

Next stop... a staging copy of _Digital.Grinnell_ on _DigitalOcean_?  Yup, headed there now. :frowning:  But the address will be https://staging.summittservices.com, when it's ready.

<!--
## Many Settings Are Missing

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

So, remember back in the [Installing the Missing Islandora and Custom Modules](/posts/058-rebuilding-isle-ld/installing-the-missing-islandora-and-custom-modules) section of [post 058](/posts/058-rebuilding-isle-ld/), we commented out the installation of `islandora_binary_object` and `islandora_pdfjs_reader` like so:

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

-->

That's not a wrap.  More about this soon...
