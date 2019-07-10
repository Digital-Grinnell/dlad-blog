---
title: Rebuilding ISLE-ld (for Local Development)
date: 2019-07-10T08:26:12-07:00
draft: false
---

This post is intended to chronicle my efforts to build a new ISLE v1.1.2 `local development` instance of Digital.Grinnell on my work-issued iMac, `MA8660`, and MacBook Air, `MA7053`.  

## Goal Statement
The goal of this project is to spin up a pristine, local Islandora stack using a fork of [the ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE) at https://github.com/DigitalGrinnell/ISLE, then introduce elements like the [Digital Grinnell theme](https://github.com/DigitalGrinnell/digital_grinnell_theme) and custom modules like [DG7](https://github.com/DigitalGrinnell/dg7).  Once these pieces are in-place and working, I'll begin adding other critical components as well as a robust set of data gleaned from https://digital.grinnell.edu.

## Using This Document
There are just a couple of notes regarding this document that I'd like to pass along to make it more useful.

  - **Gists** - You will find a few places in this post where I generated a [gist](https://help.github.com/en/articles/creating-gists) to take the place of lengthy command output.  Instead of a long stream of text you'll find a simple [link to a gist](https://gist.github.com/McFateM/98d09fdcc29f88ac88bf7b3cbfb8324d) like this.

  - **Workstation Commands** - There are lots of places in this document where I've captured a series of command lines along with output from those commands in block text.  Generally speaking, after each such block you will find a **Workstation Commands** table that can be used to conveniently copy and paste the necessary commands directly into your workstation. The tables look something like this:

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/DigitalGrinnell/ISLE <br/> cd ISLE <br/> git checkout -b ld |

  - **Apache Container Commands** - Similar to `Workstation Commands`, a tabulated list of commands may appear with a heading of **Apache Container Commands**. \*Commands in such tables can be copied and pasted into your command line terminal, but ONLY after you have opened a shell into the _Apache_ container. The asterisk (\*) at the end of the table heading is there to remind you of this! See the [next section](#opening-a-shell-in-the-apache-container) of this document for additional details. These tables looks something like this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/contrib <br/> drush dl backup_migrate <br/> drush -y en backup_migrate |

## Opening a Shell in the Apache Container
This is something I find myself doing quite often during ISLE configuration, so here's a reminder of how I generally do this...
```
╭─markmcfate@ma8660 ~/Projects/ISLE ‹ruby-2.3.0› ‹ld*›
╰─$ docker exec -it isle-apache-ld bash
root@9bec4edd3964:/# cd /var/www/html
root@9bec4edd3964:/var/www/html#
```
| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> docker exec -it isle-apache-ld bash |

## A Bit of History
I've already got two forks of the [Islandora Collaboration Group's ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE) and cannot practically create another.  So, the first step in my process is to bring one of the [forks](https://github.com/Islandora-Collaboration-Group/ISLE) in-sync with the upstream `master`.  I'm going to attempt doing this via my web browser using the guidance documented in [Syncing your fork to the original repository via the browser](https://github.com/KirstieJane/STEMMRoleModels/wiki/Syncing-your-fork-to-the-original-repository-via-the-browser).  Wish me luck.

## Syncing my Fork
Not much to tell you here.  I followed the guidance mentioned above and it worked nicely. Almost too painless to be true?  We shall see.  In any case, there's now an up-to-date fork of https://github.com/Islandora-Collaboration-Group/ISLE in https://github.com/DigitalGrinnell/ISLE.

## Cloning to Local
Next step, I believe is to clone the updated fork to `MA8660` (and/or `MA7053`), make a new `ld` branch there, and begin building.  The following command stream captures all of that...
```
╭─markmcfate@ma8660 ~/Projects ‹ruby-2.3.0›
╰─$ git clone https://github.com/DigitalGrinnell/ISLE
Cloning into 'ISLE'...
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (18/18), done.
remote: Compressing objects: 100% (15/15), done.
remote: Total 17933 (delta 3), reused 7 (delta 2), pack-reused 17915
Receiving objects: 100% (17933/17933), 242.26 MiB | 6.57 MiB/s, done.
Resolving deltas: 100% (5814/5814), done.
╭─markmcfate@ma8660 ~/Projects ‹ruby-2.3.0›
╰─$ cd ISLE
╭─markmcfate@ma8660 ~/Projects/ISLE ‹ruby-2.3.0› ‹master›
╰─$ git checkout -b ld
Switched to a new branch 'ld'
╭─markmcfate@ma8660 ~/Projects/ISLE ‹ruby-2.3.0› ‹ld›
```
| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/DigitalGrinnell/ISLE <br/> cd ISLE <br/> git checkout -b ld |

## Moved This Post
Moments ago I moved this blog post into the new local copy of my fork.  I've also copied my previous work, from March 2019, to this fork.  That text is in `old-ISLE-ld.md` so I'm working on documents now in...
```
╭─markmcfate@ma8660 ~/Projects/ISLE ‹ruby-2.3.0› ‹ld*›
╰─$ l *.md
-rw-r--r--  1 markmcfate  staff   3.3K Jul  3 16:13 021-rebuilding-isle-ld.md
-rw-r--r--  1 markmcfate  staff    71K Jul  3 16:19 old-ISLE-ld.md
```

## Installing per install-demo.md
This is first-and-foremost a `local development` copy of ISLE, so I'm following the process outlined in `install-demo.md` from the documentation collection at...
```
╭─markmcfate@ma8660 ~/Projects/ISLE/docs/install ‹ruby-2.3.0› ‹ld*›
╰─$ l
total 120
drwxr-xr-x   9 markmcfate  staff   288B Jul  3 15:12 .
drwxr-xr-x  15 markmcfate  staff   480B Jul  3 15:12 ..
-rw-r--r--   1 markmcfate  staff   3.3K Jul  3 15:12 host-hardware-requirements.md
-rw-r--r--   1 markmcfate  staff    12K Jul  3 15:12 host-software-dependencies.md
-rw-r--r--   1 markmcfate  staff   4.5K Jul  3 15:12 install-demo-edit-hosts-file.md
-rw-r--r--   1 markmcfate  staff   7.5K Jul  3 15:12 install-demo-resources.md
-rw-r--r--   1 markmcfate  staff   3.2K Jul  3 15:12 install-demo-troubleshooting.md
-rw-r--r--   1 markmcfate  staff   5.1K Jul  3 15:12 install-demo.md
-rw-r--r--   1 markmcfate  staff    11K Jul  3 15:12 install-server.md
```

## Cleaning Up
I typically use the following command stream to clean up any Docker cruft before I begin anew.  Note: Uncomment the third line ONLY if you want to delete images and download new ones.  If you do, be patient, it could take several minutes depending on connection speed.

| Workstation Commands |
| --- |
| docker stop $(docker ps -q) <br/> docker rm -v $(docker ps -qa) <br/># docker image rm $(docker image ls -q) <br/> docker system prune --force |

## Launching the Stack
Moving to [Step 2](https://github.com/DigitalGrinnell/ISLE/blob/ld/docs/install/install-demo.md#step-2-launch-process) in the install [documentation](https://github.com/DigitalGrinnell/ISLE/blob/master/docs/install/install-demo.md) (with all the "pull" details removed) produced [this gist](https://gist.github.com/McFateM/1f45be46a5105f2fb2a9031034612722).

| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> time docker-compose up -d |

## Running the Drupal Installer Script
Moving on to [Step 3 according to the documentation](https://github.com/DigitalGrinnell/ISLE/blob/ld/docs/install/install-demo.md#step-3-run-install-script) is...
```
╭─markmcfate@ma8660 ~/Projects/ISLE ‹ruby-2.3.0› ‹ld*›
╰─$ time docker exec -it isle-apache-ld bash /utility-scripts/isle_drupal_build_tools/isle_islandora_installer.sh
  ...several lines removed for clarity...
Done.
'all' cache was cleared.   [success]
docker exec -it isle-apache-ld bash   0.04s user 0.03s system 0% cpu 7:52.12 total
```
| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> time docker exec -it isle-apache-ld bash /utility-scripts/isle_drupal_build_tools/isle_islandora_installer.sh |

It was at this point I discovered a new gem in `iTerm2`:  If you hit `Command + shift + A` the terminal will select/highlight all of the output from the last command.  Exactly what I was hoping for.  I've copied all that output and stuck it in [this gist](https://gist.github.com/McFateM/98d09fdcc29f88ac88bf7b3cbfb8324d) rather than pasting it all here.

## Testing the Site
Moving on to [Step 4 in the documentation](https://github.com/DigitalGrinnell/ISLE/blob/ld/docs/install/install-demo.md#step-4-test-the-site)...

A web browser visit to https://isle.localdomain/ shows that the standard ISLE stack is working, and I was able to successfully login as `isle` with a password of `isle`.  

## Installing the DG Theme
[Step 5 in the documentation](https://github.com/DigitalGrinnell/ISLE/blob/ld/docs/install/install-demo.md#step-4-test-the-site) calls for ingest of some sample objects, but this is where I'm departing from the script since I've done this a number of times before.

So my focus here turned to installing the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap) theme instead.  The process was captured to [this gist](https://gist.github.com/McFateM/516d4d8db0d7190bfed4e14874b358a8).

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/themes <br/> git clone https://github.com/drupalprojects/bootstrap.git <br/> chown -R islandora:www-data * <br/> cd bootstrap <br/> git checkout 7.x-3.x <br/> drush -y en bootstrap <br/> mkdir -p /var/www/html/sites/default/themes <br/> cd /var/www/html/sites/default/themes <br/> git clone https://github.com/DigitalGrinnell/digital_grinnell_bootstrap.git <br/> chown -R islandora:www-data * <br/> cd digital_grinnell_bootstrap <br/> drush -y pm-enable digital_grinnell_bootstrap <br/> drush vset theme_default digital_grinnell_bootstrap |

Success! The theme is in place and active on my [ISLE.localdomain](https://ISLE.localdomain) site.  Just one more tweak here...

I visited https://isle.localdomain/#overlay=admin/appearance/settings/digital_grinnell_bootstrap and made sure ONLY the following boxes are checked:

  - Logo
  - Shortcut Icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

A visit to [the site](https://isle.localdomain) with a refresh showed that this worked!

Next, I attempted to dump my production Drupal database and restore it to [ISLE.localdomain](https://ISLE.localdomain) as chronicled in the next sections.

## Install the Islandora Multi-Importer (IMI)
It's important that we take this step BEFORE any that follow, otherwise the module will not install properly. The result is captured in [this gist](https://gist.github.com/McFateM/d8e7694032298e0518a88b3370872db8).

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/mnylc/islandora_multi_importer.git <br/> chown -R islandora:www-data * <br/> cd islandora_multi_importer <br/> composer install <br/> drush -y en islandora_multi_importer <br/> |

## Install the Missing *Backup and Migrate* Module
The *Backup and Migrate* module will be needed to quickly get our new ISLE configured as we'd like.  Install it like so:
```
╭─markmcfate@ma8660 ~/Projects/ISLE ‹ruby-2.3.0› ‹ld*›
╰─$ docker exec -it isle-apache-ld bash
root@9bec4edd3964:/# cd /var/www/html/sites/all/modules/contrib
root@9bec4edd3964:/var/www/html/sites/all/modules/contrib# drush dl backup_migrate
Project backup_migrate (7.x-3.6) downloaded to /var/www/html/sites/all/modules/contrib/backup_migrate.                                         [success]
root@9bec4edd3964:/var/www/html/sites/all/modules/contrib# drush -y en backup_migrate
The following extensions will be enabled: backup_migrate
Do you really want to continue? (y/n): y
backup_migrate was enabled successfully.   [ok]
backup_migrate defines the following permissions: access backup and migrate, perform backup, access backup files, delete backup files, restore from backup, administer backup and migrate
root@9bec4edd3964:/var/www/html/sites/all/modules/contrib#
```
| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/contrib <br/> drush dl backup_migrate <br/> drush -y en backup_migrate |

## Backup and Restore the Database Using *Backup and Migrate*

From the `https://digital.grinnell.edu` (production) site...

  - Login as `System Admin`
  - From the `Development` menu (on the right) select `Clear Cache`
  - On the home page (https://digital.grinnell.edu), scroll to the bottom of the right-hand column.
  - Use the `Quick Backup` dialog, with all the defaults, to create and download a fresh backup.

Alternatively, you could...

  - Navigate to https://digital.grinnell.edu/admin/config/system/backup_migrate/export/advanced
  - In the `Load Settings` box select `Default Settings w/ Users`
  - Click `Backup now` to backup the site
  - Click `Save` to save the file to your workstation `Downloads` folder

In the `isle.localdomain` site...

  - Visit https://isle.localdomain/#overlay=admin/config/system/backup_migrate/restore
  - Click the `Restore`
  - Select the `Restore from an uploaded file` option
  - Click `Browse` in the `Upload a Backup File`
  - Navigate to your workstation `Downloads` folder and choose the backup file created moments ago
  - Click `Restore now`
  - Navigate your browser back to `https://isle.localdomain/`
  - Take note of any warnings or errors that may be present.

## Restore Results...Lots of Warnings

OK, so when I did all of the above backup/restore process what I got back in the "Navigate your browser..." step was a dreaded WSOD, a white-screen-of-death. Without panic I very calmly (so I lied a little) returned to my terminal and the shell open in the *Apache* container and:

```
root@9bec4edd3964:/var/www/html/sites/all/modules/contrib# cd /var/www/html/sites/default
root@9bec4edd3964:/var/www/html/sites/default# drush cc all
  ...numerous lines of output removed for clarity...
'all' cache was cleared.
```

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush cc all |

This returned a number of warnings about missing modules and such.  No matter, that was to be expected.  So I returned to my browser and did a refresh... the site came back up, and presented a more-readable litany of warnings than did `drush cc all`.  The list of warnings is shown in [this gist](https://gist.github.com/McFateM/bb3502c810e27fb1c5149790c39f4ccc).

The remedy for most of these missing bits was to do the following while still in my open *Apache* terminal/shell:

```
root@9bec4edd3964:/var/www/html/sites/default# drush dl masquerade announcements email git_deploy maillog r4032login smtp views_bootstrap field_group
  ...numerous lines of output removed for clarity...
Project masquerade (7.x-1.0-rc7) downloaded to /var/www/html/sites/all/modules/contrib/masquerade.   [success]
Project announcements (7.x-1.x-dev) downloaded to /var/www/html/sites/all/modules/contrib/announcements.   [success]
Project email (7.x-1.3) downloaded to /var/www/html/sites/all/modules/contrib/email.   [success]
Project git_deploy (7.x-1.x-dev) downloaded to /var/www/html/sites/all/modules/contrib/git_deploy.   [success]
Project maillog (7.x-1.0-alpha1) downloaded to /var/www/html/sites/all/modules/contrib/maillog.   [success]
Project r4032login (7.x-1.8) downloaded to /var/www/html/sites/all/modules/contrib/r4032login.   [success]
Project smtp (7.x-1.7) downloaded to /var/www/html/sites/all/modules/contrib/smtp.   [success]
Project views_bootstrap (7.x-3.2) downloaded to /var/www/html/sites/all/modules/contrib/views_bootstrap.   [success]
root@9bec4edd3964:/var/www/html/sites/default# drush cc all
  ...numerous lines of output removed for clarity...
'all' cache was cleared.
```
| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush dl masquerade announcements email git_deploy maillog r4032login smtp views_bootstrap <br/> drush cc all |

Visiting the [site](https://isle.localdomain) again shows that all of the *Drupal* missing modules are happy now, but there are still a number of *Islandora* bits missing. After removing any redundant messages I was left with:

```
   User warning: The following module is missing from the file system: dg7. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: idu. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: islandora_binary_object. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: islandora_collection_search. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: islandora_mods_display. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: islandora_multi_importer. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: islandora_oralhistories. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: islandora_pdfjs_reader. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: islandora_solr_collection_view. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
   User warning: The following module is missing from the file system: transcripts_ui. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
```

Next steps and sections, still working "off-script", will install all of these missing parts.  

## Installing the Missing Islandora/Custom Bits
If I recall correctly, all of the missing Islandora and custom modules listed above can be found in the *Apache* container on *DGDocker1*, our production instance of ISLE, at `/var/www/html/sites/all/modules/islandora`.  So I started this process by opening a new shell in the aforementioned container on *DGDocker1* like so:
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
| Apache Container Commands (on PRODUCTION ISLE only!)* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> cd dg7; git remote -v <br/> cd ../idu; git remote -v <br/> cd ../islandora_binary_object/; git remote -v <br/> cd ../islandora_collection_search/; git remote -v <br/> cd ../islandora_mods_display/; git remote -v <br/> cd ../islandora_solution_pack_oralhistories/; git remote -v <br/> cd ../islandora_pdfjs_reader/; git remote -v <br/> cd ../islandora_solr_collection_view/; git remote -v <br/>|

Note that I did NOT bother with the `islandora_multi_importer` (IMI) directory since I know for a fact that IMI requires installation via *Composer*. I also didn't bother looking for `transcript_ui` because it is a known sub-module of `islandora_solution_pack_oralhistories`.

It looks like all of the others can just be cloned using *git*, like so:
```
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone https://github.com/DigitalGrinnell/dg7.git
Cloning into 'dg7'...
remote: Enumerating objects: 305, done.
remote: Total 305 (delta 0), reused 0 (delta 0), pack-reused 305
Receiving objects: 100% (305/305), 184.14 KiB | 845.00 KiB/s, done.
Resolving deltas: 100% (186/186), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone https://github.com/DigitalGrinnell/idu.git
Cloning into 'idu'...
remote: Enumerating objects: 27, done.
remote: Counting objects: 100% (27/27), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 27 (delta 8), reused 23 (delta 4), pack-reused 0
Unpacking objects: 100% (27/27), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone git://github.com/discoverygarden/islandora_binary_object.git
Cloning into 'islandora_binary_object'...
remote: Enumerating objects: 44, done.
remote: Counting objects: 100% (44/44), done.
remote: Compressing objects: 100% (35/35), done.
remote: Total 623 (delta 17), reused 26 (delta 7), pack-reused 579
Receiving objects: 100% (623/623), 137.23 KiB | 1.48 MiB/s, done.
Resolving deltas: 100% (317/317), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone https://github.com/discoverygarden/islandora_collection_search
Cloning into 'islandora_collection_search'...
remote: Enumerating objects: 24, done.
remote: Counting objects: 100% (24/24), done.
remote: Compressing objects: 100% (21/21), done.
remote: Total 428 (delta 9), reused 14 (delta 3), pack-reused 404
Receiving objects: 100% (428/428), 81.40 KiB | 622.00 KiB/s, done.
Resolving deltas: 100% (201/201), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone https://github.com/DigitalGrinnell/islandora_mods_display.git
Cloning into 'islandora_mods_display'...
remote: Enumerating objects: 1, done.
remote: Counting objects: 100% (1/1), done.
remote: Total 91 (delta 0), reused 0 (delta 0), pack-reused 90
Unpacking objects: 100% (91/91), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git
Cloning into 'islandora_solution_pack_oralhistories'...
remote: Enumerating objects: 3402, done.
remote: Total 3402 (delta 0), reused 0 (delta 0), pack-reused 3402
Receiving objects: 100% (3402/3402), 11.18 MiB | 9.15 MiB/s, done.
Resolving deltas: 100% (1377/1377), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone git://github.com/nhart/islandora_pdfjs_reader.git
Cloning into 'islandora_pdfjs_reader'...
remote: Enumerating objects: 298, done.
remote: Total 298 (delta 0), reused 0 (delta 0), pack-reused 298
Receiving objects: 100% (298/298), 83.65 KiB | 764.00 KiB/s, done.
Resolving deltas: 100% (145/145), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# git clone https://github.com/Islandora-Labs/islandora_solr_collection_view.git
Cloning into 'islandora_solr_collection_view'...
remote: Enumerating objects: 131, done.
remote: Total 131 (delta 0), reused 0 (delta 0), pack-reused 131
Receiving objects: 100% (131/131), 31.64 KiB | 568.00 KiB/s, done.
Resolving deltas: 100% (70/70), done.
root@9bec4edd3964:/var/www/html/sites/all/modules/islandora# chown -R islandora:www-data *
```

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/DigitalGrinnell/dg7.git <br/> git clone https://github.com/DigitalGrinnell/idu.git <br/> # git clone git://github.com/discoverygarden/islandora_binary_object.git <br/> git clone https://github.com/discoverygarden/islandora_collection_search <br/> git clone https://github.com/DigitalGrinnell/islandora_mods_display.git <br/> git clone https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git <br/> # git clone git://github.com/nhart/islandora_pdfjs_reader.git <br/> git clone https://github.com/Islandora-Labs/islandora_solr_collection_view.git <br/> chown -R islandora:www-data *<br/> cd /var/www/html/sites/default <br/> drush cc all <br/> |

The last command line above was required to bring ALL of the new modules' ownership into line with everything else in [ISLE.localdomain](https://isle.localdomain).  Also note that two of the lines, for `islandora_binary_object` and `islandora_pdfjs_reader`, are commented out because of known issues with installation of those modules.

## Temporarily Eliminate Warnings
So the [site](https://isle.localdomain) is still issuing a few annoying warnings about missing pieces.  In order to turn them off, for now, just do this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush -y dis islandora_binary_object islandora_pdfjs_reader <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora_binary_object' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora_pdfjs_reader' AND type = 'module';" <br/> drush cc all |

# Building ISLE-DG-Essentials
The remaining critical step here involves packaging all of the customization of underlying services like FEDORA, FEDORAGSearch, and Solr, that exist for _Digital Grinnell_.  All of the necessary customization is already in play on _DGDocker1_, where ISLE is currently running in production. My approach to this step was to:

  1. Make a local clone of https://github.com/DigitalGrinnell/RepositoryX.git as `~/Projects/ISLE-DG-Essentials`.  
  2. Checkout the `ISLE-ld` branch of this new clone; that's the branch that holds all my work from early 2019.  
  3. Remove _git_ from control of the new cloned repository.  This should leave just the latest `ISLE-ld` work in place.  
  4. Make a new, empty, private _Github_ project at https://github.com/McFateM/ISLE-DG-Essentials.  
  5. Push the local clone to the new _Github_ repo for long-term development and deployment.  
  6. Update the `README.md` document in the new repo to reflect proper use of the project.  

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/DigitalGrinnell/RepositoryX.git ISLE-DG-Essentials <br/> cd ISLE-DG-ESSENTIALS <br/> git checkout ISLE-ld <br/> rm -fr .git <br/> git init <br/> git remote add origin https://github.com/McFateM/ISLE-DG-Essentials.git <br/> git add -A <br/> git commit -m "First commit (from old DigitalGrinnell/RepositoryX repo)" <br/> git push -u origin master |

| Important! |
| --- |
| See https://github.com/McFateM/ISLE-DG-Essentials/blob/master/README.md for much more detail. |

# Spinning up isle.localdomain
I put an updated copy of `docker-compose.override.yml` into the `ld` branch of my new [ISLE repo](https://github.com/McFateM/ISLE) so all that's needed now is to visit the local clone of that project, bring it down, and back up again like so:

| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> git checkout ld <br/> docker-compose stop <br/> docker-compose up -d |

It may take a few minutes for the site to come up.  Be patient and after a short break (5 minutes?) visit https://isle.localdomain to see the new site.

# Connecting to FEDORA
The aforementioned `docker-compose.override.yml` file in the `ld` branch of my https://github.com/McFateM/ISLE project includes 3 lines that direct _FEDORA_ and _FGSearch_ to use the mounted and pre-configured `/Volumes/DG-FEDORA` USB stick for object storage. The commands and process required to use the USB stick are presented here.

## Insert the DG-FEDORA USB Stick
To restore the *Fedora* repository from a previous build just insert the USB stick labeled `DG-FEDORA`.  On a Mac the USB stick should automatically mount as `/Volumes/DG-FEDORA`, and our `docker-compose.override.yml` file should connect this folder to our *Fedora* container to serve as our object repository.  However, by default the USB stick will be mounted `read-only`, and that won't work nicely.  

## Re-Mount the `DG-FEDORA` Stick as Read-Write
To make the `DG-FEDORA` stick writable do this:

| Workstation Commands |
| --- |
| sudo mount -u -w /Volumes/DG-FEDORA |

In this command `-u` modifies the status of the mounted filesystem, and `-w` mounts the filesystem as read-write.  The next steps will follow a documented process to re-index everything as needed.

## Re-Index DG-FEDORA and Solr
To re-index the *Fedora* repository on the aforementioned USB stick, follow the documented guidance at:
https://islandora-collaboration-group.github.io/ISLE/migrate/reindex-process/

Specifics of my `isle.localdomain` include...

### Shutdown FEDORA Using Method 2
You must stop the _FEDORA_ and _FGSearch_ services before proceeding with re-index operations.  Proceed as directed in [the document](https://islandora-collaboration-group.github.io/ISLE/migrate/reindex-process/), `Shutdown FEDORA Method 2` with username `admin` and a password of `isle_admin`.

| Workstation Commands |
| --- |
| docker exec -it isle-fedora-ld bash |

| _FEDORA_ Container Commands |
| --- |  
| wget "http://admin:isle_admin:8080/manager/text/stop?path=/fedora" -O - -q |

### Reindex FEDORA RI (1 of 3)
Proceed as directed in [the document](https://islandora-collaboration-group.github.io/ISLE/migrate/reindex-process/), step 1 of 3.  Shell into the _FEDORA_ container and issue the _FEDORA_ commands documented here.

| Workstation Commands |
| --- |
| docker exec -it isle-fedora-ld bash |

| _FEDORA_ Container Commands |
| --- |  
| cd /usr/local/fedora/server/bin <br/> /bin/sh fedora-rebuild.sh -r org.fcrepo.server.resourceIndex.ResourceIndexRebuilder > /usr/local/tomcat/logs/fedora_ri.log 2>&1 |

Note: Remove the `2>&1` suffix if you want to allow all warning and error messages to display immediately on-screen.

### Reindex SQL Database (2 of 3)
Proceed as directed in [the document](https://islandora-collaboration-group.github.io/ISLE/migrate/reindex-process/), step 2 of 3.  The _MySQL_ `root` password is: `ild_mysqlrt_2018`.

| _FEDORA_ Container Commands |
| --- |  
| mysql -h mysql -u root -pild_mysqlrt_2018 |

| _MySQL_ Prompt Commands |
| --- |  
| use fedora3; <br/> show tables; <br/> truncate table dcDates; <br/> truncate table doFields; <br/> truncate table doRegistry; <br/> truncate table fcrepoRebuildStatus; <br/> truncate table modelDeploymentMap; <br/> truncate table pidGen; <br/> exit |

| _FEDORA_ Container Commands |
| --- |  
| cd /usr/local/fedora/server/bin <br/> /bin/sh fedora-rebuild.sh -r org.fcrepo.server.resourceIndex.ResourceIndexRebuilder > /usr/local/tomcat/logs/fedora_ri.log 2>&1 |

The last command block is indeed a repeat of step 1.  It rebuilds the index after a number of tables have been truncated in _FEDORA_'s _MySQL_ database.

### Reindex Solr (3 of 3)

| Important! |
| --- |
| Although it is NOT documented (as of July 10, 2019) you **must restart _FEDORA_ prior to running these commands! |

| _FEDORA_ Container Commands |
| --- |  
| wget "http://admin:isle_admin:8080/manager/text/start?path=/fedora" -O - -q |

Now, proceed as directed in [the document](https://islandora-collaboration-group.github.io/ISLE/migrate/reindex-process/), step 3 of 3.  The `fgsAdmin` password is: `ild_fgs_admin_2018`

| Workstation Commands |
| --- |
| docker exec -it isle-fedora-ld bash |

| _FEDORA_ Container Commands |
| --- |  
| cd /usr/local/tomcat/webapps/fedoragsearch/client <br/> /bin/sh runRESTClient.sh localhost:8080 updateIndex fromFoxmlFiles |


And that's a wrap.  Until next time...
