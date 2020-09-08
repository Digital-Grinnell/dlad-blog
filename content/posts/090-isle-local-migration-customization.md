---
title: "Local ISLE Installation: Migrate Existing Islandora Site - Customizations"
publishDate: 2020-09-08
lastmod: 2020-09-08T10:13:59-05:00
draft: false
tags:
  - ISLE
  - migrate
  - local
  - development
---

This post is an addendum to earlier [post 087](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again/). It is intended to chronicle my _customization_ efforts, necessary steps that follow the aforementioned document's `Step 11`, to migrate to a `local development` instance of _Digital.Grinnell_ on my work-issued iMac, `MA8660`, currently identified as `MAD25W812UJ1G9`.  Please refer to Steps 0 - 11 in [post 087](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again/) for background info.

## Goal
The goal of this project is once again to spin up a local Islandora stack using [the ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE/) following the guidance of the project's [install-local-migrate](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md) document.  My process will be slightly different than documented since I've already created a pair of private [dg-isle](https://github.com/Digital-Grinnell/dg-isle/) and [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora/) repositories. This workflow will also take steps to introduce elements like the [Digital Grinnell theme](https://github.com/DigitalGrinnell/digital_grinnell_theme/) and custom modules like [DG7](https://github.com/DigitalGrinnell/dg7/).  Once these pieces are in-place and working, I'll begin adding other critical components as well as a robust set of data gleaned from https://digital.grinnell.edu/.

{{% annotation %}}
Note that there are no formal "annotations" in this document because everything here is an addendum/annotation to the original [install-local-migrate](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md) document.
{{% /annotation %}}

## Outcomes of Step 11
As part of [Step 11](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again#step-11-test-the-site) I visited [https://dg.localdomain](https://dg.localdomain) on my iMac desktop and found that the site came up but with no theme and it repeats the aforementioned warnings, plus a few new ones, in a different format than before (this is a web/html response rather than command-line output). The new, complete list of warnings was:

```
    User warning: The following module is missing from the file system: antibot. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: dg7. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: idu. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_binary_object. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_collection_search. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_datastream_exporter. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_datastream_replace. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_mods_display. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_mods_via_twig. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_multi_importer. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_oralhistories. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_solr_collection_view. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: islandora_solr_views. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following module is missing from the file system: transcripts_ui. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
    User warning: The following theme is missing from the file system: digital_grinnell_bootstrap. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
```

Once I had the site open in my broswer I also took note of these warnings:

```
Notice: Trying to get property of non-object in _theme_load_registry() (line 335 of /var/www/html/includes/theme.inc). =>

    ... (Array, 10 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/includes/theme.inc, line 335

Notice: Trying to get property of non-object in _theme_load_registry() (line 319 of /var/www/html/includes/theme.inc). =>

    ... (Array, 12 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/includes/theme.inc, line 319

Notice: Undefined index: digital_grinnell_bootstrap in theme_get_setting() (line 1440 of /var/www/html/includes/theme.inc). =>

    ... (Array, 9 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/includes/theme.inc, line 1440

Notice: Trying to get property of non-object in theme_get_setting() (line 1477 of /var/www/html/includes/theme.inc). =>

    ... (Array, 9 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/includes/theme.inc, line 1477

Notice: Trying to get property of non-object in theme_get_setting() (line 1487 of /var/www/html/includes/theme.inc). =>

    ... (Array, 9 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/includes/theme.inc, line 1487

Notice: Undefined index: highlighted in include() (line 126 of /var/www/html/modules/system/page.tpl.php). =>

    ... (Array, 9 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/modules/system/page.tpl.php, line 126

Notice: Undefined index: sidebar_first in include() (line 138 of /var/www/html/modules/system/page.tpl.php). =>

    ... (Array, 9 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/modules/system/page.tpl.php, line 138

Notice: Undefined index: sidebar_second in include() (line 144 of /var/www/html/modules/system/page.tpl.php). =>

    ... (Array, 9 elements)
    Krumo version 0.2.1a | http://krumo.sourceforge.net
    [Click to expand. Double-click to show path.] Called from /var/www/html/modules/system/page.tpl.php, line 144
```

## Dealing with Warnings

It was obvious that I needed to resolve all of the aforementioned installation warnings, and they are all an indication of theme and module components that are "missing" from my _dg-islandora_ repository. Remember, in our `docker-compose.local.yml` file we map the following:

```
volumes:
  # Customization: Bind mounting Drupal Code instead of using default Docker volumes for local development with an IDE.
  - ../dg-islandora:/var/www/html:cached
```

So the task before me was to add these things to _dg-islandora_, and save the changes into the _dg-islandora_ repo for use later on.

### Addressing the Theme

Because it impacts the theme and site display, I chose to begin with this warning:

```
User warning: The following theme is missing from the file system: digital_grinnell_bootstrap. For information about how to fix this, see the documentation page. in _drupal_trigger_error_with_delayed_logging() (line 1156 of /var/www/html/includes/bootstrap.inc).
```

#### Installing the Missing Theme: digital_grinnell_bootstrap

My initial focus here turned to installing the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap).  Initially I did this with a pair of `git clone...` commands, but since I'm adding these to my _Islandora / Drupal_ code repository I will use _Git_ `submodules` instead of `git clone`.

From my workstation, the commands to engage our theme as a submodule were:

| Workstation Commands |
| --- |
| cd ~/GitHub/dg-islandora/sites/all <br/> cd ~/GitHub/dg-islandora/data/apache/html/sites/default/themes <br/> git submodule add -f https://github.com/DigitalGrinnell/digital_grinnell_bootstrap.git |

Then inside the _Apache_ container...

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/default/themes <br/> chown -R islandora:www-data * <br/> cd .. <br/> drush -y pm-enable bootstrap digital_grinnell_bootstrap <br/> drush -y vset theme\default digital_grinnell_bootstrap <br/> drush cc all |

Success! The theme is in place and active on my [dg.localdomain](https://dg.localdomain/) site.  Just one more tweak here...

I visited [#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap](https://dg.localdomain/#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap) and made sure ONLY the following boxes are checked:

  - Logo
  - Site slogan
  - Shortcut icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

A visit to [the site](https://dg.localdomain/) with a refresh showed that this worked!


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

And that's a good place for a quick break.  I'll be back with more in a minute.
