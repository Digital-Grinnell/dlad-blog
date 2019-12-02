---
title: Rebuilding ISLE-ld (for Local Development)
publishDate: 2019-07-06
lastmod: 2019-11-25T18:05:34-05:00
draft: false
tags:
  - ISLE
  - local
  - development
---

This post is intended to chronicle my efforts to build a new ISLE v1.3.0 `local development` instance of _Digital.Grinnell_ on my work-issued iMac, `MA8660`, and MacBook Air, `MA7053`.

## Goal
The goal of this project is to spin up a pristine, local Islandora stack using [the ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE/) at https://github.com/Digital-Grinnell/dg-isle/, then introduce elements like the [Digital Grinnell theme](https://github.com/DigitalGrinnell/digital_grinnell_theme/) and custom modules like [DG7](https://github.com/DigitalGrinnell/dg7/).  Once these pieces are in-place and working, I'll begin adding other critical components as well as a robust set of data gleaned from https://digital.grinnell.edu/.

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

| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> docker exec -it isle-apache-ld bash |


## Cloning to Local
The first step is to clone my fork of _ISLE_, namely [dg-isle](https://github.com/Digital-Grinnell/dg-isle.git), to my workstation at `~/Projects/GitHub/dg-isle`, checkout the `local-dg-fedora` branch there, and begin, like so...

| Workstation Commands |
| --- |
| cd ~/Projects/GitHub <br/> git clone https://github.com/Digital-Grinnell/dg-isle.git <br/> cd dg-isle <br/> git checkout local-dg-fedora |

## Cleaning Up
I typically use the following command stream to clean up any _Docker_ cruft before I begin anew.  Note: Uncomment the third line ONLY if you want to delete images and download new ones.  If you do, be patient, it could take several minutes depending on connection speed.

| Workstation Commands |  
| --- |  
| docker stop &dollar;(docker ps -q) <br/> docker rm -v &dollar;(docker ps -qa) <br/> # docker image rm &dollar;(docker image ls -q) --force <br/> docker system prune --force |    

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

So my focus here turned to installing the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap) theme instead.  The process was captured to [this gist](https://gist.github.com/McFateM/516d4d8db0d7190bfed4e14874b358a8).

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/themes <br/> git clone https://github.com/drupalprojects/bootstrap.git <br/> chown -R islandora:www-data * <br/> cd bootstrap <br/> git checkout 7.x-3.x <br/> drush -y en bootstrap <br/> mkdir -p /var/www/html/sites/default/themes <br/> cd /var/www/html/sites/default/themes <br/> git clone https://github.com/DigitalGrinnell/digital\_grinnell\_bootstrap.git <br/> chown -R islandora:www-data * <br/> cd digital\_grinnell\_bootstrap <br/> drush -y pm-enable digital\_grinnell\_bootstrap <br/> drush vset theme\_default digital\_grinnell\_bootstrap |

Success! The theme is in place and active on my [dg.localdomain](https://dg.localdomain/) site.  Just one more tweak here...

I visited [#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap](https://dg.localdomain/#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap) and made sure ONLY the following boxes are checked:

  - Logo
  - Shortcut Icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

A visit to [the site](https://dg.localdomain/) with a refresh showed that this worked!

## Install the Islandora Multi-Importer (IMI)

It's important that we take this step BEFORE any that follow, otherwise the module will not install properly. The result is captured in [this gist](https://gist.github.com/McFateM/d8e7694032298e0518a88b3370872db8).

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/mnylc/islandora\_multi\_importer.git <br/> chown -R islandora:www-data * <br/> cd islandora\_multi\_importer <br/> composer install <br/> drush -y en islandora\_multi\_importer |

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

It looks like all of the others can just be cloned using *git*, like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/DigitalGrinnell/dg7.git <br/> git clone https://github.com/DigitalGrinnell/idu.git <br/> # git clone git://github.com/discoverygarden/islandora\_binary\_object.git <br/> git clone https://github.com/discoverygarden/islandora\_collection\_search <br/> git clone https://github.com/DigitalGrinnell/islandora\_mods\_display.git <br/> git clone https://github.com/Islandora-Labs/islandora\_solution\_pack\_oralhistories.git <br/> # git clone git://github.com/nhart/islandora\_pdfjs\_reader.git <br/> git clone https://github.com/Islandora-Labs/islandora\_solr\_collection_view.git <br/> chown -R islandora:www-data * <br/> cd /var/www/html/sites/default <br/> drush cc all |

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

A vist in my browser to [https://dg.localdomain/#overlay=admin/reports/status](https://dg.localdomain/#overlay=admin/reports/status) helps to pinpoint the problem... we don't yet have a `private` file system.  Let's create one like so:

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

And that's a wrap.  Until next time...
