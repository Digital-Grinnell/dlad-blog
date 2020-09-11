---
title: "Local ISLE Installation: Migrate Existing Islandora Site - One-Time Customizations"
publishDate: 2020-09-07
lastmod: 2020-09-11T10:18:45-05:00
draft: false
tags:
  - ISLE
  - migrate
  - local
  - development
---

This post is an addendum to earlier [post 087](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again/). It is intended to chronicle my _customization_ efforts, necessary steps that follow the aforementioned document's `Step 11`, to migrate to a `local development` instance of _Digital.Grinnell_ on my work-issued iMac, `MA8660`, currently identified as `MAD25W812UJ1G9`.  Please refer to Steps 0 - 11 in [post 087](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again/) for background info.

{{% boxmd %}}
Note that it **should NOT be necessary to repeat steps taken in this document**. Pertinent changes made herein were saved into a new `completed-install-local-migrate` branch of my [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora/) project repository, effectively capturing all progress made within.
{{% /boxmd %}}

## Goal
The goal of this project is once again to spin up a local Islandora stack using [the ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE/) following the guidance of the project's [install-local-migrate](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md) document.  My process will be slightly different than documented since I've already created a pair of private [dg-isle](https://github.com/Digital-Grinnell/dg-isle/) and [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora/) repositories.

{{% annotation %}}
Note that there are no formal "annotations" in this document because everything here is an addendum/annotation to the original [install-local-migrate](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md) document.
{{% /annotation %}}

## Outcomes of Step 11
As part of [Step 11](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again#step-11-test-the-site) I visited [https://dg.localdomain](https://dg.localdomain) on my iMac desktop and found that the site came up looking and behaving just as it should, but with two warnings. The complete list of warnings was:

```
    User warning: The following module is missing from the file system: antibot. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_mods_via_twig. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
```

## Dealing with Warnings

Resolving these warnings would basically involve adding the missing modules to my _dg-islandora_ repository. Remember, in our `docker-compose.local.yml` file we map the following:

```
volumes:
  # Customization: Bind mounting Drupal Code instead of using default Docker volumes for local development with an IDE.
  - ../dg-islandora:/var/www/html:cached
```

So the task before me was to add these things to _dg-islandora_, and save the changes into the _dg-islandora_ repo for use later on. Looking at my production instance of ISLE on _DGDocker1_, I found that the only missing "contrib" module was `antibot` which currently resides in `/opt/ISLE/persistent/html/sites/all/modules/contrib/antibot`.  The other missing module was part of the "islandora" branch of the module tree, residing in subdirectories of `/opt/ISLE/persistent/html/sites/all/modules/islandora/islandora_mods_via_twig`.

### antibot

The [antibot](https://www.drupal.org/project/antibot) module currently resides in `/opt/ISLE/persistent/html/sites/all/modules/contrib/antibot` on _DGDocker1_. I was curious what would happen if I opened a terminal into my local _Apache_ container and used `drush pm-download...` to try installing this module. My command sequence on my desktop workstation was this:

| Workstation Commands |
| --- |
| docker exec -w /var/www/html/sites/default isle-apache-ld drush pm-download antibot <br/> docker exec -w /var/www/html/sites/default isle-apache-ld drush cc all |

The results were very promising as the first command returned this:

```
Project antibot (7.x-1.2) downloaded to                                [success]
/var/www/html/sites/all/modules/contrib/antibot.
```

The 2nd `drush...` command subsequently returned only one warning  **since the `antibot` warning was gone**!  A peek inside my `dg-islandora` instance on the workstation was also promising. There I found this:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-islandora/sites/all/modules/contrib ‹ruby-2.3.0› ‹master*›
╰─$ ll
total 0
drwxr-x---@ 21 markmcfate  staff   672B Sep  1 15:31 admin_menu
drwxr-x---@  9 markmcfate  staff   288B Sep  1 15:31 admin_theme
drwxr-x---@ 12 markmcfate  staff   384B Sep  1 15:31 announcements
drwxr-xr-x  11 markmcfate  staff   352B Jun 10  2018 antibot
drwxr-x---@ 12 markmcfate  staff   384B Sep  1 15:31 backup_migrate
...
```

So it appears that `antibot` was properly downloaded to the correct owner/group, and all that's missing is a proper set of its permissions, although I suspect it will function properly just as it is. A peek inside the new `antibot` directory showed this:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-islandora/sites/all/modules/contrib/antibot ‹ruby-2.3.0› ‹master*›
╰─$ ll
total 96
-rw-r--r--  1 markmcfate  staff    18K Nov 16  2016 LICENSE.txt
-rw-r--r--  1 markmcfate  staff    91B Jun  6  2018 README.txt
-rw-r--r--  1 markmcfate  staff   1.2K Jun  6  2018 antibot.admin.inc
-rw-r--r--  1 markmcfate  staff   286B Jun 10  2018 antibot.info
-rw-r--r--  1 markmcfate  staff   224B Jun  6  2018 antibot.install
-rw-r--r--  1 markmcfate  staff   5.2K Jun  6  2018 antibot.module
-rw-r--r--  1 markmcfate  staff   765B Jun  6  2018 antibot.pages.inc
drwxr-xr-x  3 markmcfate  staff    96B Jun  6  2018 js
drwxr-xr-x  3 markmcfate  staff    96B Jun  6  2018 templates
```

A check of the equivalent directories and files on _DGDocker1_ revealed much the same as you can see in the abridged output below.

```
[islandora@dgdocker1 contrib]$ ll
total 268
drwxr-x---.  2 islandora 33 4096 Nov 19  2014 addanother
drwxr-x---.  3 islandora 33 4096 Dec  6  2010 admin_theme
drwxr-x---.  5 islandora 33 4096 Apr 14  2018 advanced_help
drwxr-x---.  2 islandora 33 4096 Jan 20  2015 announcements
drwxr-xr-x.  4 islandora 33 4096 Jun 10  2018 antibot
drwxr-x---.  4 islandora 33 4096 Dec 15  2018 backup_migrate
...
[islandora@dgdocker1 contrib]$ cd antibot
[islandora@dgdocker1 antibot]$ ll
total 48
-rw-r--r--. 1 islandora 33  1196 Jun  7  2018 antibot.admin.inc
-rw-r--r--. 1 islandora 33   286 Jun 10  2018 antibot.info
-rw-r--r--. 1 islandora 33   224 Jun  7  2018 antibot.install
-rw-r--r--. 1 islandora 33  5370 Jun  7  2018 antibot.module
-rw-r--r--. 1 islandora 33   765 Jun  7  2018 antibot.pages.inc
drwxr-xr-x. 2 islandora 33    23 Jun  7  2018 js
-rw-r--r--. 1 islandora 33 18092 Nov 16  2016 LICENSE.txt
-rw-r--r--. 1 islandora 33    91 Jun  7  2018 README.txt
drwxr-xr-x. 2 islandora 33    34 Jun  7  2018 templates
```

I subsequently logged in to both my production and local instances of ISLE and visited the corresponding `antibot` configuration pages at [https://digital.grinnell.edu/admin/config/system/antibot](https://digital.grinnell.edu/admin/config/system/antibot) and [https://dg.localdomain/islandora/object/islandora%3Aroot#overlay=admin/config/system/antibot](https://dg.localdomain/islandora/object/islandora%3Aroot#overlay=admin/config/system/antibot). The nearly identical pages indicate that my `antibot` configruation, presumably part of my imported production _Drupal_ database, is intact and exactly as it should be.  This was good news indeed!

### islandora_mods_via_twig

On _DGDocker1_ I found a `.git` subdirectory in the `/opt/ISLE/persistent/html/sites/all/modules/islandora/islandora_mods_via_twig` directory indicating that this module should be provisioned using `git`. The module has a `git remote -v` response of `origin https://github.com/DigitalGrinnell/islandora_mods_via_twig.git` so I believe it would be prudent to add it as another git submodule. I did that like so:

| Workstation Commands |
| --- |
| `cd ~/GitHub/dg-islandora` <br/> `git submodule add https://github.com/DigitalGrinnell/islandora_mods_via_twig.git sites/all/modules/islandora/islandora_mods_via_twig` <br/> `docker exec -w /var/www/html/sites/default isle-apache-ld drush cc all` |

A quick visit to [https://dg.localdomain](https://dg.localdomain) on my local workstation shows the site is working and with **no visible errors or warnings**!  Woot!

### Two Probable Issues

So, it works...maybe. However, I am concerned with a couple of things so I decided to take a peek inside my new local ISLE instance to check. I did indeed find a couple of problems.

#### Permissions and Ownership of "antibot" and "islandora_mods_via_twig"

Inside the _Apache_ container I checked the permissions of my `/var/www/html/sites/all/modules/islandora` directory and found this, abridged for clarity:

```
drwxr-x--- 10 islandora www-data  320 Sep  9 22:21 islandora_mods_display/
drwxr-xr-x  8 www-data  www-data  256 Sep 10 03:08 islandora_mods_via_twig/
drwxr-x--- 20 islandora www-data  640 Sep 10 02:10 islandora_multi_importer/
```

Likewise, inside `/var/www/html/sites/all/modules/contrib` I found this, also abridged for clarity:

```
drwxr-x--- 12 islandora www-data  384 Sep  9 22:20 announcements/
drwxr-xr-x 11 www-data  www-data  352 Jun 11  2018 antibot/
drwxr-x--- 12 islandora www-data  384 Sep  9 22:20 backup_migrate/
```

And inside both of those subdirectories I found structures with owner/group and permissions like this:

```
root@5686019d1a3a:/var/www/html/sites/all/modules/islandora/islandora_mods_via_twig# ll
total 88
drwxr-xr-x  8 root      root       256 Sep 10 03:08 ./
drwxr-x--- 63 islandora www-data  2016 Sep 10 03:08 ../
-rw-r--r--  1 root      root        88 Sep 10 03:08 .git
-rwxr-xr-x  1 root      root     16683 Sep 10 03:08 islandora_mods_via_twig.drush.inc*
-rw-r--r--  1 root      root       265 Sep 10 03:08 islandora_mods_via_twig.info
-rw-r--r--  1 www-data  www-data    67 Sep 10 03:08 islandora_mods_via_twig.module
-rw-r--r--  1 root      root     35064 Sep 10 03:08 LICENSE.txt
-rw-r--r--  1 root      root     17925 Sep 10 03:08 README.md
```

Not good from an owner/group perspective, but looking OK in terms of permissions? So, the necessary changes I need to make here are ones that were previously performed as part of the `migration_site_vsets.sh` script back in [Step 10: Run Islandora Drupal Site Scripts](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again#step-10-run-islandora-drupal-site-scripts). Specifically, inside the _Apache_ container I need to rerun this command from that script:

| _isle-apache-ld_ Container Commands |
| --- |
| `/bin/bash /utility-scripts/isle_drupal_build_tools/drupal/fix-permissions.sh --drupal_path=/var/www/html --drupal_user=islandora --httpd_group=www-data` |

A quick check of the aforementioned directories and files inside the _Apache_ container shows that owner/group and permissions are now as-they-should-be. Yay!

#### Where Have All the Files Gone?

Ok, so I'm showing my age with that subtitle, I know. But it's a valid question, perhaps best summed up in this _Slack_ post of mine:

{{% original %}}
At https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md#drupal-site-files-and-code I made a copy of my production `/var/www/html/sites/default/files` directory anticipating that "You'll move this directory in later steps."   I must have missed something, because I can't find anyplace in the document where I moved those files into my new local instance of ISLE.
{{% /original %}}

The resolution of this issue is now covered in the annotation at the end of [Step 9: Import the Production MySQL Drupal Database](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again#step-9-import-the-production-mysql-drupal-database).

## Next Steps

After completion of everything mentioned in this document, I returned to [Step 12: Ingest Sample Objects](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again#step-12-ingest-sample-objects) but ended my work there differently than suggested. The differences are all covered in one final annotation there.

The `install-local-migrate.md` document subsequently suggests moving on to [Staging ISLE Installation: Migrate Existing Islandora Site](https://static.grinnell.edu/blogs/McFateM/posts/install/install-staging-migrate.md) and I believe I will do just that, probably with production of another annotated document to chronicle my specific experience.

But before I go... I elected to take two more steps here. The first is...

  - Updating my `dg-islandora` repository with all of the changes made thus far.
    - Note that I did indeed update `dg-islandora`, but not the `master` branch. In my workstation's `~/GitHub/dg-islandora` directory I did this in order to save all changes made thus far into a new `completed-install-local-migrate` branch for safe-keeping.

```
  ╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-islandora ‹ruby-2.3.0› ‹master*›
  ╰─$ git status
  On branch master
  Your branch is up to date with 'origin/master'.

  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)

  	modified:   .gitmodules
  	new file:   html/sites/all/modules/islandora/islandora_mods_via_twig
  	new file:   sites/all/modules/islandora/islandora_mods_via_twig

  Changes not staged for commit:
    (use "git add/rm <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
    (commit or discard the untracked or modified content in submodules)

  	modified:   .gitignore
  	modified:   .gitmodules
  	deleted:    html/sites/all/modules/islandora/islandora_mods_via_twig
  	modified:   install_solution_packs.sh
  	modified:   migration_site_vsets.sh
  	modified:   sites/all/modules/islandora/dg7 (modified content)
  	modified:   sites/all/modules/islandora/islandora_mods_display (modified content)
  	modified:   sites/all/modules/islandora/islandora_mods_via_twig (modified content)
  	modified:   sites/all/modules/islandora/islandora_multi_importer (modified content)
  	modified:   sites/all/modules/islandora/islandora_scholar/modules/citeproc/composer.lock
  	modified:   sites/all/modules/islandora/islandora_solution_pack_oralhistories (modified content)

  Untracked files:
    (use "git add <file>..." to include in what will be committed)

  	sites/all/modules/contrib/antibot/

  ╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-islandora ‹ruby-2.3.0› ‹master*›
  ╰─$ git checkout -b completed-install-local-migrate
    M	.gitignore
    M	.gitmodules
    M	install_solution_packs.sh
    M	migration_site_vsets.sh
    M	sites/all/modules/islandora/dg7
    M	sites/all/modules/islandora/islandora_mods_display
    A	sites/all/modules/islandora/islandora_mods_via_twig
    M	sites/all/modules/islandora/islandora_multi_importer
    M	sites/all/modules/islandora/islandora_scholar/modules/citeproc/composer.lock
    M	sites/all/modules/islandora/islandora_solution_pack_oralhistories
    Switched to a new branch 'completed-install-local-migrate'
```

I considered trying to update _Drupal_ and its contrib modules from the web interface at https://dg.localdomain/#overlay=admin/modules/update but doing so requires FTP acccess which my local instance does not have.  So, I considered using `drush up` instead, and it appears to be working properly. So, in my workstation I got this:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master*›
╰─$ docker exec -it isle-apache-ld bash
root@e34ab55f94aa:/# cd /var/www/html/sites/default/
root@e34ab55f94aa:/var/www/html/sites/default# drush up
Update information last refreshed: Thu, 2020-09-10 15:57
 Name                                           Installed Version  Proposed version  Message
 Drupal                                         7.67               7.72              SECURITY UPDATE available
 Views Bulk Operations (views_bulk_operations)  7.x-3.5            7.x-3.6           Update available
 Backup and Migrate (backup_migrate)            7.x-3.6            7.x-3.9           Update available
 Colorbox (colorbox)                            7.x-2.13           7.x-2.15          Update available
 Git Deploy (git_deploy)                        7.x-1.x-dev        7.x-1.3           Update available
 Maillog / Mail Developer (maillog)             7.x-1.0-alpha1     7.x-1.0-rc1       Update available
 Views (views)                                  7.x-3.23           7.x-3.24          Update available
 Webform (webform)                              7.x-4.20           7.x-4.23          SECURITY UPDATE available


NOTE: A security update for the Drupal core is available.
Drupal core will be updated after all of the non-core projects are updated.

Security and code updates will be made to the following projects: Views Bulk Operations (VBO) [views_bulk_operations-7.x-3.6], Backup and Migrate [backup_migrate-7.x-3.9], Colorbox [colorbox-7.x-2.15], Git Deploy [git_deploy-7.x-1.3], Maillog / Mail Developer [maillog-7.x-1.0-rc1], Views (for Drupal 7) [views-7.x-3.24], Webform [webform-7.x-4.23]

Note: A backup of your project will be stored to backups directory if it is not managed by a supported version control system.
Note: If you have made any modifications to any file that belongs to one of these projects, you will have to migrate those modifications after updating.
Do you really want to continue with the update process? (y/n): y
Project views_bulk_operations was updated successfully. Installed version is now 7.x-3.6.
Backups were saved into the directory                                                                              [ok]
/root/drush-backups/digital_grinnell/20200910205644/modules/views_bulk_operations.
Project backup_migrate was updated successfully. Installed version is now 7.x-3.9.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910205644/modules/backup_migrate.  [ok]
Project colorbox was updated successfully. Installed version is now 7.x-2.15.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910205644/modules/colorbox.        [ok]
Project git_deploy was updated successfully. Installed version is now 7.x-1.3.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910205644/modules/git_deploy.      [ok]
Project maillog was updated successfully. Installed version is now 7.x-1.0-rc1.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910205644/modules/maillog.         [ok]
Project views was updated successfully. Installed version is now 7.x-3.24.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910205644/modules/views.           [ok]
Project webform was updated successfully. Installed version is now 7.x-4.23.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910205644/modules/webform.         [ok]

Code updates will be made to drupal core.
WARNING:  Updating core will discard any modifications made to Drupal core files, most noteworthy among these are .htaccess and robots.txt.  If you have made any modifications to these files, please back them up before updating so that you can re-create your modifications in the updated version of the file.
Note: Updating core can potentially break your site. It is NOT recommended to update production sites without prior testing.

Do you really want to continue? (y/n): y
Project drupal was updated successfully. Installed version is now 7.72.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910205644/drupal.                  [ok]
require_once(/lib/glip.php): failed to open stream: No such file or directory git_deploy.module:46                 [warning]
PHP Fatal error:  require_once(): Failed opening required '/lib/glip.php' (include_path='.:/usr/share/php') in /var/www/html/sites/all/modules/contrib/git_deploy/git_deploy.module on line 46
Drush command terminated abnormally due to an unrecoverable error.                                                 [error]
Error: require_once(): Failed opening required '/lib/glip.php' (include_path='.:/usr/share/php') in
/var/www/html/sites/all/modules/contrib/git_deploy/git_deploy.module, line 46
The external command could not be executed due to an application error.
```

So, it looks like modules and core were updated successfully?  I'm just not sure what the impact of the warning and `PHP Fatal error` might be. :frowning:

A little investigation suggests that we are missing the [glip library](github.com/halstead/glip.git), so following the guidance in [the `git_deploy` module's `README.txt`](~/GitHub/dg-islandora/sites/all/modules/contrib/git_deploy/README.txt) I did this from my workstation:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-islandora/sites/all/libraries ‹ruby-2.3.0› ‹completed-install-local-migrate*›
╰─$ git clone git://github.com/halstead/glip.git
   cd glip
   git checkout 1.1
Cloning into 'glip'...
remote: Enumerating objects: 319, done.
remote: Total 319 (delta 0), reused 0 (delta 0), pack-reused 319
Receiving objects: 100% (319/319), 101.97 KiB | 593.00 KiB/s, done.
Resolving deltas: 100% (163/163), done.
Note: checking out '1.1'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 79f5472... Implement support for alternates object stores.
```

Then, taking another shot at `drush up` from my _Apache_ container:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master*›
╰─$ docker exec -it isle-apache-ld bash
root@e34ab55f94aa:/# cd /var/www/html/sites/default/
root@e34ab55f94aa:/var/www/html/sites/default# drush up
Error while trying to find the common path for enabled extensions of project dg-islandora. Extensions are:         [error]
announcements, islandora_altmetrics, islandora_badges, islandora_example_simple_text, islandora_image_annotation,
islandora_oadoi, islandora_scopus, islandora_sync, islandora_sync_field_collection, islandora_sync_relation,
islandora_webform_ingest, islandora_wos, webform_bonus, webform_digest.
Update information last refreshed: Thu, 2020-09-10 15:57
 Name                   Installed Version  Proposed version  Message
 Bootstrap (bootstrap)  7.x-3.21           7.x-3.26          SECURITY UPDATE available


Security updates will be made to the following projects: Bootstrap [bootstrap-7.x-3.26]

Note: A backup of your project will be stored to backups directory if it is not managed by a supported version control system.
Note: If you have made any modifications to any file that belongs to one of these projects, you will have to migrate those modifications after updating.
Do you really want to continue with the update process? (y/n): y
Project bootstrap was updated successfully. Installed version is now 7.x-3.26.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20200910213813/themes/bootstrap.        [ok]
 System             7083  Add 'jquery-html-prefilter-3.5.0-backport.js' to the 'jquery' library.
 System             7084  Rebuild JavaScript aggregates to include 'ajax.js' fix for Chrome 83.
 Backup_migrate     7308  Update profiles table filter field to accommodate larger serialized strings.
 Backup_migrate     7309  NodeSquirrel support has been removed.
 Backup_migrate     7310  Disable e-mail destinations.
 Backup_migrate     7311  Adjust the default performance settings.
 Git_deploy         7000  Save current location of glip library.
 Maillog            7100  Rename the 'idmaillog' field to just 'id'.
 Maillog            7101  Clear the menu cache so the new paths will be picked up.
 Maillog            7102  Clear the Views cache so the updated admin page will get the new paths.
 Islandora          7002  Implements hook_update_N().   Removing old variable around changes to ingestDatastream signature.
                          These changes are complete and deprecation warnings are removed.
 Islandora_oai      7103  Add support for QDC.
 Islandora_scholar  7103  Maintain existing RGB colorspace profile configuration.
 Islandora_scholar  7104  Disable Islandora Google Scholar if it is currently enabled, since logic now lives in Islandora
                          Scholar
 Citeproc           7101  Set citeproc version if you are updating.    That way the library used doesn't switch under your
                          feet, when updating to   the latest version.
 Islandora_entitie  7100  Add the default description field to the Scholar solr metadata profile.
 s
 Islandora_entitie  7200  Print and log a message about potential lost Position data.   @see
 s                        https:jira.duraspace.orgbrowseISLANDORA-2137
 Islandora_pdf      7001  Maintain existing RGB colorspace profile configuration.
 Islandora_pdf      7100  Set and maintain new dUseCIEColor switch variable.
 Islandora_video    7101  Implements hook_update_N().   Deletes the unused legacy variable islandora_video_retain_original.
 Islandora_webform  7001  Add webform_workflow state permissions schema to webform table.
 Islandora_webform  7002  Add draft_access field to webform table.
 Xml_form_builder   7105  Make title_field not required.   Repeating because hook_schema wasn't updated.
 Xml_form_builder   7106  Update fields to have not NULL.   Had a syntax error in our schema.
 Xml_form_builder   7107  Allow null in tranform field.   Previous update was causing issues when the transform was allowed
                          to be null.
 Xml_form_elements  7001  Rename the datepicker element as it collides with another element.
Do you wish to run all pending updates? (y/n): y
Performed update: backup_migrate_update_7308                                                                       [ok]
Performed update: backup_migrate_update_7309                                                                       [ok]
Performed update: maillog_update_7100                                                                              [ok]
Performed update: xml_form_builder_update_7105                                                                     [ok]
Performed update: system_update_7083                                                                               [ok]
Set colorspace configuration to RBG to maintain existing profile.                                                  [ok]
Performed update: islandora_pdf_update_7001                                                                        [ok]
No destinations were affected by this change.                                                                      [ok]
Performed update: backup_migrate_update_7310                                                                       [ok]
Performed update: xml_form_builder_update_7106                                                                     [ok]
Performed update: maillog_update_7101                                                                              [ok]
Performed update: islandora_webform_update_7001                                                                    [ok]
Set colorspace configuration to RBG to maintain existing profile.                                                  [ok]
Performed update: islandora_scholar_update_7103                                                                    [ok]
Performed update: islandora_entities_update_7100                                                                   [ok]
Performed update: xml_form_builder_update_7107                                                                     [ok]
Performed update: islandora_webform_update_7002                                                                    [ok]
Performed update: islandora_video_update_7101                                                                      [ok]
Performed update: islandora_pdf_update_7100                                                                        [ok]
Illegal offset type in isset or empty module.inc:280                                                               [warning]
The Islandora Google Scholar submodule has been removed, and its functionality has been moved into the main        [ok]
Islandora Scholar module.
Performed update: islandora_scholar_update_7104                                                                    [ok]
The original default form used two-word labels in the Position element, but removed spaces in the MADS XML.  This  [ok]
has been fixed as of 7.x-1.13. When editing existing objects with the new form, older values under Position will
not be read and will be discarded.  Please consult the <a
href="https://jira.duraspace.org/browse/ISLANDORA-2137">ticket</a> for further information.
Performed update: islandora_entities_update_7200                                                                   [ok]
Performed update: citeproc_update_7101                                                                             [ok]
Performed update: system_update_7084                                                                               [ok]
Performed update: islandora_oai_update_7103                                                                        [ok]
Performed update: islandora_update_7002                                                                            [ok]
Performed update: maillog_update_7102                                                                              [ok]
Performed update: git_deploy_update_7000                                                                           [ok]
Performed update: backup_migrate_update_7311                                                                       [ok]
Performed update: xml_form_elements_update_7001                                                                    [ok]
Parsing DG One Form to Rule Them All for datepicker elements.                                                      [ok]
NodeSquirrel stopped being usable as a backup destination on October 1st, 2019 and ceased operations entirely on   [status]
November 1st, 2019. Because of this, the NodeSquirrel functionality has been disabled. Please switch to an
alternate destination if necessary. Please note that the NodeSquirrel configuration itself has not been removed.
Skipped DG One Form to Rule Them All (201) as no occurrences were found.                                           [status]
'all' cache was cleared.                                                                                           [success]
Finished performing updates.                                                                                       [ok]
```

In spite of the one error, this is looking much better. However, a quick visit to the [local site](https://dg.localdomain) returns a page with LOTS of Javascript errors and so the image tiles that appear on our home page are no longer constrained to any reasonable size. :frowning: Most errors are of the form:

```
Blocked loading mixed active content "http://dg.localdomain/sites/default/files/css/css_lQaZfjVpwP_oGNqdtWCSpJT1EMqXdMiU84ekLLxQnc4.css"
```

This was not my first rodeo, so I immediately took a look at file permissions and ownership in the _Apache_ container's `/var/www/html` directory, and it's a mess. Time to run the `fix-permissions.sh` script again...

| _isle-apache-ld_ Container Commands |
| --- |
| `/bin/bash /utility-scripts/isle_drupal_build_tools/drupal/fix-permissions.sh --drupal_path=/var/www/html --drupal_user=islandora --httpd_group=www-data` |

And that helped a great deal, but didn't quite bring the site back exactly as it should have been.  Upon detailed examination of the aforementioned error, I recognized an old enemy, a "mixed mode" browser warning.  But I could not recall how I've fixed this in the past, so I turned to [the ICG's #isle-support Slack channel](https://icg-chat.slack.com/archives/CG6HZRWQM) where my hero, [Noah Smith](https://www.linkedin.com/in/noahwsmith/), from [Born-Digital](https://born-digital.com/) immediately came to my rescue, again!

## Next Steps NOT Yet Taken
It's worth noting here that other things I considered doing next, but did not, include:

  - Updating all of the _Drupal_ contrib and _Islandora_ modules -- this should have gotten done for the contrib modules and _Drupal_ core, but I'm not sure how to best approach this for all of the Islandora modules, so I chose not to do this yet. So, I'm planning to wait and complete this step from my `staging` instance of ISLE.
  - Install and configure [LASIR](https://github.com/Islandora-Collaboration-Group/LASIR) -- this will also be delayed until after my migration instance is up-to-date and in production.
  - Configure and engage "new" ISLE features like "Automated Testing" -- this will also be delayed until after my migration instance is up-to-date and in production.
<!--

## Cloning to Local
The first step is to clone my fork of _ISLE_, namely [dg-isle](https://github.com/Digital-Grinnell/dg-isle.git), to my workstation at `~/GitHub/dg-isle`, checkout the `master` branch there, if necessary, and begin like so...

| Workstation Commands |
| --- |
| cd ~/GitHub <br/> git clone https://github.com/Digital-Grinnell/dg-isle.git <br/> cd dg-isle |

# Local ISLE Installation: New Site

OK, I began by reading through the guidance provided in [Local ISLE Installation: New Site](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#local-isle-installation-new-site).  Having met all the requirements and satisfied all assumptions, I embarked on each installation step.  Each section below documents any special conditions I imposed as well as outcomes of each step.

## Step 1: Choose a Project Name

In [Step 1](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-1-choose-a-project-name) I chose a project name, as before, of `dg` to replace instances of `yourprojectnamehere`.

## Step 1.5: Edit "/etc/hosts" File

The outcome of [Step 1.5](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-15-edit-etchosts-file) left me with an `/etc/hosts` file that looks like this:

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##

## For Omeka-S v2
#127.0.0.1    localhost omeka.localdomain traefik.localdomain pma.localdomain solr.localdomain

## For ISLE ld
127.0.0.1  localhost dg.localdomain admin.dg.localdomain images.dg.localdomain portainer.dg.localdomain
```

Take note: In the above `/etc/hosts` file the last line that you see is also the last "uncommented" instance of `127.0.0.1 localhost...`.  This is critical!

## Step 2: Setup Git Project Repositories

Ok, I completed most of [Step 2](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-2-setup-git-project-repositories) long ago, so I've substituted a `git pull` command in place of `git clone`, and will now pick up with the sub-step that says `Run a git fetch`.  The results of the documented `git fetch icg-upstream` command are:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git fetch icg-upstream
remote: Enumerating objects: 543, done.
remote: Counting objects: 100% (543/543), done.
remote: Compressing objects: 100% (53/53), done.
remote: Total 931 (delta 339), reused 527 (delta 333), pack-reused 388
Receiving objects: 100% (931/931), 2.36 MiB | 5.78 MiB/s, done.
Resolving deltas: 100% (483/483), completed with 35 local objects.
From https://github.com/Islandora-Collaboration-Group/ISLE
 * [new branch]      ISLE-1.5.0           -> icg-upstream/ISLE-1.5.0
   4b8ac42..7cc8f6e  gh-pages             -> icg-upstream/gh-pages
 * [new branch]      marksandford-patch-2 -> icg-upstream/marksandford-patch-2
 * [new branch]      marksandford-patch-3 -> icg-upstream/marksandford-patch-3
   3344097..efd837e  master               -> icg-upstream/master
 * [new tag]         ISLE-1.5.0-release   -> ISLE-1.5.0-release
 * [new tag]         ISLE-1.5.1-release   -> ISLE-1.5.1-release
 * [new tag]         ISLE-1.4.2-release   -> ISLE-1.4.2-release
```

Next, the results of `git pull icg-upstream master`:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git pull icg-upstream master
From https://github.com/Islandora-Collaboration-Group/ISLE
 * branch            master     -> FETCH_HEAD
Auto-merging docs/install/install-local-migrate.md
CONFLICT (content): Merge conflict in docs/install/install-local-migrate.md
Auto-merging docker-compose.local.yml
Automatic merge failed; fix conflicts and then commit the result.
```

The one conflict in `install-local-migrate.md` were easy to resolve by accepting the new update from the `icg-upstream` remote.

Next, I commited the merge and pushed the result to my `dg-isle` master like so:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git status
On branch master
Your branch is up to date with 'origin/master'.

You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Changes to be committed:

	modified:   .circleci/config.yml
	modified:   .gitignore
	modified:   README.md
	renamed:    config/apache/php_ini/php_staging.ini -> config/apache/php_ini/php.staging.ini
	new file:   config/matomo-nginx/ngix.conf
	new file:   config/matomo/.gitignore
	new file:   config/matomo/.htaccess
	new file:   config/matomo/environment/dev.php
	new file:   config/matomo/environment/test.php
	new file:   config/matomo/environment/ui-test.php
	new file:   config/matomo/global.ini.php
	new file:   config/matomo/global.php
	modified:   docker-compose.demo.yml
	modified:   docker-compose.local.yml
	modified:   docker-compose.production.yml
	modified:   docker-compose.staging.yml
	modified:   docker-compose.test.yml
	modified:   docs/assets/isle-v140-git-cleanup-script.sh
	modified:   docs/contributor-docs/making-pr-guide.md
	modified:   docs/contributor-docs/style-guide.md
	modified:   docs/cookbook-recipes/example-aws-configuration.md
	modified:   docs/install/install-demo.md
	modified:   docs/install/install-environments.md
	modified:   docs/install/install-local-new.md
	modified:   docs/install/install-production-migrate.md
	modified:   docs/install/install-production-new.md
	modified:   docs/install/install-staging-migrate.md
	modified:   docs/install/install-staging-new.md
	modified:   docs/install/install-troubleshooting.md
	modified:   docs/optional-components/blazegraph.md
	modified:   docs/optional-components/components.md
	new file:   docs/optional-components/matomo.md
	modified:   docs/optional-components/tickstack.md
	modified:   docs/optional-components/varnish.md
	new file:   docs/release-notes/release-1-4-2.md
	new file:   docs/release-notes/release-1-5-0.md
	new file:   docs/release-notes/release-1-5-1.md
	modified:   mkdocs.yml
	renamed:    .env -> sample.env

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both modified:   docs/install/install-local-migrate.md

╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master*›
╰─$ git add .
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master*›
╰─$ git commit -m "Merged with icg-upstream v1.5.1"
[master 77db7f9] Merged with icg-upstream v1.5.1
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git push -u origin master
Counting objects: 239, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (91/91), done.
Writing objects: 100% (239/239), 331.16 KiB | 47.31 MiB/s, done.
Total 239 (delta 171), reused 208 (delta 143)
remote: Resolving deltas: 100% (171/171), completed with 39 local objects.
To https://github.com/Digital-Grinnell/dg-isle.git
   32a6219..77db7f9  master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

All is well, thus far.  Moving on.

## Step 3: Edit the ".env" File to Point to the Local Environment

I did as instructed in [Step 3](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-3-edit-the-env-file-to-point-to-the-local-environment), but since I had previously modified `sample.env` in my repo, the resulting `.env` file was this:

```
#### Activated ISLE environment
# To use an environment other than the default Demo, please change values below
# from the default Demo to one of the following: Local, Test, Staging or Production
# For more information, consult https://islandora-collaboration-group.github.io/ISLE/install/install-environments/

COMPOSE_PROJECT_NAME=dg_local
BASE_DOMAIN=dg.localdomain
CONTAINER_SHORT_ID=ld
COMPOSE_FILE=docker-compose.local.yml:docker-compose.DG-FEDORA.yml
# :docker-compose.DATABASE.yml
```

Note the presence of a modified `COMPOSE_FILE` definition in my copy, with the addition of `docker-compose.DG-FEDORA.yml` used to pull in some convenient, local customization.

## Step 4: Create New Users and Passwords by Editing "local.env" File

This is another step that I completed long ago, and I don't believe there are any changes or additions here so, for now, I'm going to assume that all of my pertinent files are ready-to-go. The files involved in this step are: `local.env` and `config/apache/settings_php/settings.local.php`.

## Step 5: Create New Self-Signed Certs for Your Project

This is another step that I completed long ago, so all I did in this instance was look for the required files and changes to those files.  Here again, everything appears to be ready-to-go.

## Step 6: Download the ISLE Images

I ran `docker-compose pull` as instructed and after a couple of minutes I had this afirmative result:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ docker-compose pull
Pulling isle-portainer ... done
Pulling traefik        ... done
Pulling mysql          ... done
Pulling solr           ... done
Pulling fedora         ... done
Pulling apache         ... done
Pulling image-services ... done
```

## Step 7: Launch Process

Time to give it a go with `docker-compose up -d`, as documented.  My results:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ time docker-compose up -d
Recreating 7ac3d399c7b2_isle-portainer-ld ... done
Recreating 1aa37570c35e_isle-mysql-ld     ... done
Recreating 522d325b0a76_isle-proxy-ld     ... done
Recreating isle-solr-ld                   ... done
Recreating isle-fedora-ld                 ... error

ERROR: for isle-fedora-ld  Cannot start service fedora: error while creating mount source path '/Volumes/DG-FEDORA/datastreamStore': mkdir /Volumes/DG-FEDORA: permission denied

ERROR: for fedora  Cannot start service fedora: error while creating mount source path '/Volumes/DG-FEDORA/datastreamStore': mkdir /Volumes/DG-FEDORA: permission denied
ERROR: Encountered errors while bringing up the project.
docker-compose up -d  0.86s user 0.14s system 6% cpu 16.387 total
```

### Oops, I Forgot to Mount the DG-FEDORA Portable Repository

Been there, done that, again. Remember that custom `COMPOSE_FILE` line mentioned above in [Step 3](#step-3-edit-the-env-file-to-point-to-the-local-environment), well it requires that one of my `DG-FEDORA Portable Repo` USB memory sticks has to be mounted and accessible on the host. So I stuck stick `DG-FEDORA-0` into an available USB port and repeated the above command.  This time the result was:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ time docker-compose up -d                                                                         1 ↵
Removing isle-fedora-ld
isle-mysql-ld is up-to-date
isle-portainer-ld is up-to-date
isle-proxy-ld is up-to-date
isle-solr-ld is up-to-date
Recreating f7ab9f47188b_isle-fedora-ld ... done
Recreating isle-apache-ld              ... done
Recreating isle-images-ld              ... done
docker-compose up -d  0.79s user 0.13s system 12% cpu 7.127 total
```

Much better!

## Step 8: Run Islandora Drupal Site Install Script

After running the prescribed command I used the `Command + shift + A` command in _iTerm2_ to select/highlight all of the output from the last command and I copied that into [this gist](https://gist.github.com/McFateM/271cbd668331f9c863a685da3d1ebe3f) rather than pasting it all here. It appears the install worked with perhaps one exception, there is an `rsync` error at line 207 in the aforementioned gist.  Lines 206-208 from the gist read:

```
Copying Islandora Installation...
rsync: rename "/var/www/html/sites/default/.settings.php.0lfAZl" -> "sites/default/settings.php": Device or resource busy (16)
rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1196) [sender=3.1.2]
```

I'm going to proceed to the next step and will try to determine if this issue was critical to the process, or if it can be ignored or easily overcome.

## Step 9: Test the Site

A web browser visit to [https://dg.localdomain/](https://dg.localdomain/) shows that the standard ISLE stack is working as a default-themed, pristine Islandora site with no front-page content and an empty FEDORA repository.  I was able to successfully login as `admin` with my super-secret password.

## Installing the DG Theme

[Step 10 in the documentation](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-10-ingest-sample-objects) calls for ingest of some sample objects, but this is where I depart from the script since I've done this a number of times before and already have a working FEDORA repository at-the-ready.

So my focus here turned to installing the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap) theme instead.  Initially I did this with a pair of `git clone...` commands, but later in this process I'm tasked with saving my _Islandora / Drupal_ code as-a-whole into a larger _Git_ repository that will include these themes.  Cloning a _Git_ repository inside another can lead to significant workflow problems, so lets use _Git_ `submodules` instead.

To do this we will need to engage Git to make changes inside our Apache container, so it's important to note that our Drupal webroot, namely `/var/www/html` inside the Apache container, maps to `~/GitHub/dg-isle/data/apache/html` on our workstation and in our `dg-isle` repository. From my workstation the commands to engage our theme as a submodule were:

| Workstation Commands |
| --- |
| cd ~/GitHub/dg-isle/data/apache/html/sites/all/themes <br/> git submodule add -b 7.x-3.x https://github.com/drupalprojects/bootstrap.git <br/> mkdir -p ~/GitHub/dg-isle/data/apache/html/sites/default/themes <br/> cd ~/GitHub/dg-isle/data/apache/html/sites/default/themes <br/> git submodule add https://github.com/DigitalGrinnell/digital\_grinnell\_bootstrap.git |

Then inside the Apache container...

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/all/themes <br/> chown -R islandora:www-data * <br/> cd /var/www/html/sites/default/themes <br/> chown -R islandora:www-data * <br/> drush -y pm-enable bootstrap digital\_grinnell\_bootstrap <br/> drush vset theme\_default digital\_grinnell\_bootstrap |


Success! The theme is in place and active on my [dg.localdomain](https://dg.localdomain/) site.  Just one more tweak here...

I visited [#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap](https://dg.localdomain/#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap) and made sure ONLY the following boxes are checked:

  - Logo
  - Shortcut Icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

A visit to [the site](https://dg.localdomain/) with a refresh showed that this worked!







# Content Below This Point Has Been Commented Out

<!-- Progress Marker

## Connecting to FEDORA

The `docker-compose.override.yml` file in the `local-dg-fedora` branch of my [dg-isle](https://github.com/Digital-Grinnell/dg-isle) project includes 3 lines that direct _FEDORA_ and _FGSearch_ to use the mounted and pre-configured `/Volumes/DG-FEDORA` USB stick for object storage. The commands and process required to use the USB stick are presented in [post 046, "DG-FEDORA: A Portable Object Repository"](https://static.grinnell.edu/blogs/McFateM/posts/046-dg-fedora-a-portable-object-repository/).


## Restarting the Stack

Moving to [Step 7](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-7-launch-process) in the install [documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/) produced [this gist](@TODO:add-missing-link-here).

| Workstation Commands |
| --- |
| cd ~/Projects/GitHub/dg-isle <br/> time docker-compose up -d |

## Running the Drupal Installer Script

Moving on to [Step 8 according to the documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-8-run-islandora-drupal-site-install-script)...

| Workstation Commands |
| --- |
| cd ~/Projects/GitHub/dg-isle <br/> time docker exec -it isle-apache-ld bash /utility-scripts/isle\_drupal\_build\_tools/isle\_islandora\_installer.sh |

It was at this point I discovered a new gem in `iTerm2`:  If you hit `Command + shift + A` the terminal will select/highlight all of the output from the last command.  Exactly what I was hoping for.  I've copied all that output and stuck it in [this gist](https://gist.github.com/Digital-Grinnell/dbdc3a2f46dc5c3bbf7176e1384202d5) rather than pasting it all here.

## Testing the Site

Moving on to [Step 9 in the documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-9-test-the-site)...

A web browser visit to [https://dg.localdomain/](https://dg.localdomain/) shows that the standard _ISLE_ stack is working~, and I was able to successfully login as `admin` with my super-secret password.

## Installing the DG Theme

[Step 10 in the documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-10-ingest-sample-objects) calls for ingest of some sample objects, but this is where I depart from the script since I've done this a number of times before.

So my focus here turned to installing the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap) theme instead.  Initially I did this with a pair of `git clone...` commands, but later in this process I'm tasked with saving my _Islandora / Drupal_ code as-a-whole into a larger _Git_ repository that will include these themes.  Cloning a _Git_ repository inside another can lead to significant workflow problems, so lets use _Git_ `submodules` instead.

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/themes <br/> git submodule add -b 7.x-3.x https://github.com/drupalprojects/bootstrap.git <br/> chown -R islandora:www-data * <br/> mkdir -p /var/www/html/sites/default/themes <br/> cd /var/www/html/sites/default/themes <br/> git submodule add https://github.com/DigitalGrinnell/digital\_grinnell\_bootstrap.git <br/> chown -R islandora:www-data * <br/> cd /var/www/html/sites/default <br/> drush -y pm-enable bootstrap digital\_grinnell\_bootstrap <br/> drush vset theme\_default digital\_grinnell\_bootstrap |

Success! The theme is in place and active on my [dg.localdomain](https://dg.localdomain/) site.  Just one more tweak here...

I visited [#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap](https://dg.localdomain/#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap) and made sure ONLY the following boxes are checked:

  - Logo
  - Shortcut Icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

A visit to [the site](https://dg.localdomain/) with a refresh showed that this worked!

## Install the Islandora Multi-Importer (IMI)

It's important that we take this step BEFORE any that follow, otherwise the module will not install properly for reasons unknown.  Note that I'm installing a _Digital.Grinnell_-specific fork of the module here, and the process is this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git submodule add https://github.com/DigitalGrinnell/islandora\_multi\_importer.git <br/> chown -R islandora:www-data * <br/> cd islandora\_multi\_importer <br/> composer install <br/> drush -y en islandora\_multi\_importer |

## Install the Missing *Backup and Migrate* Module

The *Backup and Migrate* module will be needed to quickly get our new _ISLE_ configured as we'd like.  Install it like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/contrib <br/> drush dl backup\_migrate <br/> drush -y en backup\_migrate |

## Backup and Restore the Database Using *Backup and Migrate*

From the [https://digital.grinnell.edu](https://digital.grinnell.edu) production site...

  - Login as `System Admin`
  - From the `Development` menu (on the right) select `Clear Cache`
  - On the home page (https://digital.grinnell.edu), scroll to the bottom of the right-hand column.
  - Use the `Quick Backup` dialog, with all the defaults, to create and download a fresh backup.

Alternatively, you could...

  - Navigate to [https://digital.grinnell.edu/admin/config/system/backup_migrate/export/advanced](https://digital.grinnell.edu/admin/config/system/backup_migrate/export/advanced)
  - In the `Load Settings` box select `Default Settings w/ Users`
  - Click `Backup now` to backup the site
  - Click `Save` to save the file to your workstation `Downloads` folder

In the [https://dg.localdomain](https://dg.localdomain) site...

  - Visit [#overlay=admin/config/system/backup_migrate/restore](https://dg.localdomain/#overlay=admin/config/system/backup_migrate/restore)
  - Click the `Restore` tab
  - Select the `Restore from an uploaded file` option
  - Click `Browse` in the `Upload a Backup File`
  - Navigate to your workstation `Downloads` folder and choose the backup file created moments ago
  - Click `Restore now`
  - Navigate your browser back to [https://dg.localdomain/](https://dg.localdomain/)
  - Take note of any warnings or errors that may be present.

## Restore Results...Lots of Warnings

OK, so when I did all of the above backup/restore process what I got back in the "Navigate your browser..." step was an unreadable host of warnings. Without panic I very calmly returned to my terminal and the shell open in the _Apache_ container and:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush cc all |

This returned a number of warnings about missing modules and such.  No matter, that was to be expected and the full list of warnings is captured in [this gist](https://gist.github.com/Digital-Grinnell/bc47f4528e702f1afeb58ceaab66b28c).

The remedy for most of these missing bits was to do the following while still in my open *Apache* terminal/shell:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush dl masquerade announcements email git\_deploy maillog r4032login smtp views\_bootstrap admin\_theme google\_analytics\_counter <br/> drush cc all |

Visiting the [site](https://dg.localdomain/) again shows that most of the *Drupal* missing modules are happy now, but there are still a number of *Islandora* bits missing, so I was left with the output as shown in [this gist](https://gist.github.com/Digital-Grinnell/353fc06917db78d904a084b94d9b9982).

Next steps and sections, still working "off-script", will install all of these missing parts.

## Installing the Missing Islandora and Custom Modules

If I recall correctly, all of the missing _Islandora_ and custom modules listed above can be found in the *Apache* container on *DGDocker1*, our production instance of _ISLE_, at `/var/www/html/sites/all/modules/islandora`.  So I started this process by opening a new shell in the aforementioned container on *DGDocker1* like so:

```
╭─mcfatem@dgdocker1 ~
╰─$ docker exec -it isle-apache-dg bash
root@90ae0691e764:/# cd /var/www/html/sites/all/modules/islandora
root@90ae0691e764:/var/www/html/sites/all/modules/islandora# l
dg7/                                    islandora_multi_importer/            islandora_solution_pack_compound/
idu/                                    islandora_oai/                       islandora_solution_pack_disk_image/
islandora/                              islandora_object_lock/               islandora_solution_pack_entities/
islandora_bagit/                        islandora_ocr/                       islandora_solution_pack_image/
islandora_batch/                        islandora_openseadragon/             islandora_solution_pack_large_image/
islandora_binary_object/                islandora_paged_content/             islandora_solution_pack_newspaper/
islandora_book_batch/                   islandora_pathauto/                  islandora_solution_pack_oralhistories/
islandora_bookmark/                     islandora_pdfjs/                     islandora_solution_pack_pdf/
islandora_checksum/                     islandora_pdfjs_reader/              islandora_solution_pack_video/
islandora_checksum_checker/             islandora_premis/                    islandora_solution_pack_web_archive/
islandora_collection_search/            islandora_scholar/                   islandora_sync/
islandora_context/                      islandora_simple_workflow/           islandora_videojs/
islandora_feeds/                        islandora_solr_collection_view/      islandora_webform/
islandora_fits/                         islandora_solr_facet_pages/          islandora_xacml_editor/
islandora_image_annotation/             islandora_solr_metadata/             islandora_xml_forms/
islandora_importer/                     islandora_solr_search/               islandora_xmlsitemap/
islandora_internet_archive_bookreader/  islandora_solr_views/                islandora_xquery/
islandora_jwplayer/                     islandora_solution_pack_audio/       objective_forms/
islandora_marcxml/                      islandora_solution_pack_book/        php_lib/
```

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> ls |

My recollection has been confirmed!  So the next step was to visit each missing module's folder to see what *git* `remote` each is tied to, like so:

```
root@90ae0691e764:/var/www/html/sites/all/modules/islandora# cd dg7; git remote -v
origin	https://github.com/DigitalGrinnell/dg7.git (fetch)
origin	https://github.com/DigitalGrinnell/dg7.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/dg7# cd ../idu; git remote -v
origin	https://github.com/DigitalGrinnell/idu.git (fetch)
origin	https://github.com/DigitalGrinnell/idu.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/idu# cd ../islandora_binary_object/; git remote -v
origin	git://github.com/discoverygarden/islandora_binary_object.git (fetch)
origin	git://github.com/discoverygarden/islandora_binary_object.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_binary_object# cd ../islandora_collection_search/; git remote -v
origin	https://github.com/discoverygarden/islandora_collection_search (fetch)
origin	https://github.com/discoverygarden/islandora_collection_search (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_collection_search# cd ../islandora_mods_display/; git remote -v
origin	https://github.com/DigitalGrinnell/islandora_mods_display.git (fetch)
origin	https://github.com/DigitalGrinnell/islandora_mods_display.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_mods_display# cd ../islandora_solution_pack_oralhistories/; git remote -v
origin	https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git (fetch)
origin	https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_solution_pack_oralhistories# cd ../islandora_pdfjs_reader/; git remote -v
origin	git://github.com/nhart/islandora_pdfjs_reader.git (fetch)
origin	git://github.com/nhart/islandora_pdfjs_reader.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_pdfjs_reader# cd ../islandora_solr_collection_view/; git remote -v
origin	https://github.com/Islandora-Labs/islandora_solr_collection_view.git (fetch)
origin	https://github.com/Islandora-Labs/islandora_solr_collection_view.git (push)

```
| Apache Container Commands (on **PRODUCTION** _ISLE_ only!)* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> cd dg7; git remote -v <br/> cd ../idu; git remote -v <br/> cd ../islandora\_binary\_object/; git remote -v <br/> cd ../islandora\_collection\_search/; git remote -v <br/> cd ../islandora\_mods\_display/; git remote -v <br/> cd ../islandora\_solution\_pack\_oralhistories/; git remote -v <br/> cd ../islandora\_pdfjs\_reader/; git remote -v <br/> cd ../islandora\_solr\_collection_view/; git remote -v |

Note that I did NOT bother with the `islandora_multi_importer` (IMI) directory since I know for a fact that IMI requires installation via *Composer*. I also didn't bother looking for `transcript_ui` because it is a known sub-module of `islandora_solution_pack_oralhistories`.

It looks like all of the others can just be added as _Git_ submodules like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git submodule add https://github.com/DigitalGrinnell/dg7.git <br/> git submodule add https://github.com/DigitalGrinnell/idu.git <br/> # git submodule add git://github.com/discoverygarden/islandora\_binary\_object.git <br/> git submodule add https://github.com/discoverygarden/islandora\_collection\_search <br/> git submodule add https://github.com/DigitalGrinnell/islandora\_mods\_display.git <br/> git submodule add https://github.com/Islandora-Labs/islandora\_solution\_pack\_oralhistories.git <br/> # git submodule add git://github.com/nhart/islandora\_pdfjs\_reader.git <br/> git submodule add https://github.com/Islandora-Labs/islandora\_solr\_collection_view.git <br/> chown -R islandora:www-data * <br/> cd /var/www/html/sites/default <br/> drush cc all |

The `chown` command line above was required to bring ALL of the new modules' ownership into line with everything else in [dg.localdomain](https://dg.localdomain/).  Also note that two of the lines, for `islandora_binary_object` and `islandora_pdfjs_reader`, are commented out because of known issues with installation of those modules.

## Temporarily Eliminate Warnings

So my site, [https://dg.localdomain/](https://dg.localdomain/), is still issuing a few annoying warnings about missing pieces.  It's a safe bet that we don't need these modules, at least not right now, so just do this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush -y dis islandora\_binary\_object islandora\_pdfjs\_reader <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora\_binary\_object' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora\_pdfjs\_reader' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora\_google\_scholar' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'phpexcel' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'ldap\_servers' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'ihc' AND type = 'module';" <br/> drush cc all <br/> drush cc all |

You saw that correctly, I did `drush cc all` twice, just for good measure.  Now, just a couple more issues to deal with...

## Need a `private` File System

At this point the system is still issuing some warnings, and the most annoying is:

```
Warning: file_put_contents(private:///.htaccess): failed to open stream: &quot;DrupalPrivateStreamWrapper::stream_open&quot; call failed in file_put_contents() (line 496 of /var/www/html/includes/file.inc).
```

A visit in my browser to [https://dg.localdomain/#overlay=admin/reports/status](https://dg.localdomain/#overlay=admin/reports/status) helps to pinpoint the problem... we don't yet have a `private` file system.  Let's create one like so:

| Apache Container Commands* |
| --- |
| cd /var/www <br/> mkdir private <br/> chown islandora:www-data private <br/> chmod 774 private <br/> cd /var/www/html/sites/default <br/> drush cc all |

Now that same status report, [https://dg.localdomain/#overlay=admin/reports/status](https://dg.localdomain/#overlay=admin/reports/status), shows that we are still operating in `maintenance mode`, and some of our newest modules may require database updates.  To remedy those two conditions:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush updatedb -y <br/> drush vset maintenance\_mode 0 <br/> drush cc all |

## Solr Schema is NOT Right

Ok, at this point I believe that I have a good _Drupal_ database, a working _Fedora_ repository, and a solid _Islandora/Drupal_ codebase; but the _Solr_ schema associated with this configuration is **NOT** up-to-speed with _Digital.Grinnell's_ so the `dg7` code and the `dg7_collection` view are expecting _Solr_ fields that do not yet exist here.  What to do?

1. Save the current database using _Backup and Migrate_.
2. Save the current codebase to the host using `mkdir -p ../dg-islandora; docker cp isle-apache-ld:/var/www/html/. ../dg-islandora` and putting all of it into a new [Digital-Grinnell/dg-islandora](https://github.com/Digital-Grinnell/dg-islandora) repository on _GitHub_ for safe-keeping.
3. Update the _FEDORA_ and _Solr_ schema and configuration using the guidance found in https://github.com/Digital-Grinnell/ISLE-DG-Essentials/blob/master/README.md
4. Try pulling up the [site](https://dg.localdomain/) again.

# Huzzah! It works!

## Final Step...Capture the Working Code in `dg-islandora`

To wrap this up I followed [Step 11 in the install-local-new.md](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-11-check-in-the-newly-created-islandora-drupal-site-code-into-is-git-repository) document to capture the state of my _Islandora/Drupal_ code.  In doing so I created my PRIVATE code repository, [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora).

-->

And that's a wrap.  Until next time...
