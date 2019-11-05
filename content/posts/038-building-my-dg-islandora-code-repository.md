---
title: Building My `dg-islandora` Code Repository
publishDate: 2019-08-16
lastmod: 2019-11-05T07:47:27-05:00
draft: false
emoji: true
tags:
  - ISLE
  - v1.3.0
  - git
  - dg-islandora
  - code repository
---

As promised in [post 037](https://static.grinnell.edu/blogs/McFateM/posts/037-migrating-dg-to-isle-1.2.0-ld/), this post combines elements of [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/) with [post 034](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.2.0-ld/) to create a "customized" local ISLE instance with features of Digital.Grinnell. In this November 2019 update I'm building the repository on my MacBook MA7053 using ISLE v1.3.0. The target of this endeavor will be a properly populated [Digital.Grinnell custom Islandora code repository](https://github.com/DigitalGrinnell/dg-islandora) featuring ISLE v1.3.0 code.

## Process Overview
I believe the process I need to engage here can be outlined like this:

  1. Repeat [post 034](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.2.0-ld/) through [Step 9](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.2.0-ld/#step-9-test-the-site) but using ISLE v1.3.0. Assuming a successful test...

  2. Move to [post 21](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/) and complete the following steps, in order:

    - [Installing the DG Theme](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#installing-the-dg-theme)
    - [Install the Islandora Multi-Importer (IMI)](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#install-the-islandora-multi-importer-IMI)
    - [Install the Missing Backup and Migrate Module](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#install-the-missing-backup-and-migrate-module)
    - [Backup and Restore the Database Using Backup and Migrate](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#backup-and-restore-the-database-using-backup-and-migrate)
    - [Restore Results...Lots of Warnings](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#restore-results-lots-of-warnings)
    - [Installing the Missing Islandora/Custom Bits](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#installing-the-missing-islandora-custom-bits)
    - [Temporarily Eliminate Warnings](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#temporarily-eliminate-warnings)  


  3. Continue with [post 034, step 11](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.2.0-ld/#step-11-check-in-the-newly-created-drupal-islandora-site-code-to-a-git-repository), again using ISLE v1.3.0.

# Sections That Follow May be Temporarily Out-of-Order

## Clone to Local
I started by following the `Cloning to Local` guidance in [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#clone-to-local).  The commands and output were like so:

```
╭─markmcfate@ma7053 ~/Projects/ISLE ‹ruby-2.3.0› ‹master*›
╰─$ git remote -v
origin	https://github.com/Islandora-Collaboration-Group/ISLE.git (fetch)
origin	https://github.com/Islandora-Collaboration-Group/ISLE.git (push)
╭─markmcfate@ma7053 ~/Projects/ISLE ‹ruby-2.3.0› ‹master*›
╰─$ git pull
remote: Enumerating objects: 14, done.
remote: Counting objects: 100% (14/14), done.
remote: Total 28 (delta 13), reused 14 (delta 13), pack-reused 14
Unpacking objects: 100% (28/28), done.
From https://github.com/Islandora-Collaboration-Group/ISLE
   cb56d788..879de85c  master             -> origin/master
 * [new branch]        ISLE-1.3.0         -> origin/ISLE-1.3.0
 * [new branch]        behat-url-change   -> origin/behat-url-change
 * [new tag]           ISLE-1.3.0-release -> ISLE-1.3.0-release
Updating cb56d788..879de85c
Fast-forward
╭─markmcfate@ma7053 ~/Projects/ISLE ‹ruby-2.3.0› ‹master*›
╰─$ git checkout ISLE-1.3.0
D	config/apache/settings_php/settings.local.php
Branch 'ISLE-1.3.0' set up to track remote branch 'ISLE-1.3.0' from 'origin'.
Switched to a new branch 'ISLE-1.3.0'
```

## Cleaning Up
Next, I ran my usual `Docker clean-up` commands from `Cleaning Up` in [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#cleaning-up).  Specifically...

```
╭─markmcfate@ma7053 ~/Projects/ISLE ‹ruby-2.3.0› ‹ISLE-1.3.0*›
╰─$ docker stop $(docker ps -q)
docker rm -v $(docker ps -qa)
docker image rm $(docker image ls -q) --force
docker system prune --force
```

## Launching the Stack
I started it all up as documented in `Launching the Stack` from [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#launching-the-stack). While that was spinning up I took a look at my workstation's `/etc/hosts` file, and made sure I had the following in control:

```
## For ISLE ld
127.0.0.1  localhost isle.localdomain admin.isle.localdomain images.isle.localdomain portainer.isle.localdomain
```
Just FYI... my `time` to `docker-compose up -d` was:
```
docker-compose up -d  1.30s user 0.39s system 1% cpu 2:17.93 total
```
## Running the Drupal Installer Script
Did so exactly as prescribed in the `Running the Drupal Installer Script` portion of [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#running-the-drupal-installer-script).

My `time` to complete... `docker exec -it isle-apache-ld bash   0.11s user 0.14s system 0% cpu 6:44.70 total`.  The good news is, after just a couple of minutes the site comes up successfully as `https://isle.localdomain`.  Woot!  Now, time to add my theme and some other features.

## Installing the DG Theme
Moving on to `Installing the DG Theme` in [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#installing-the-dg-theme) and running the commands verbatim...

Nice!  It's beginning to take shape.

## Install the Islandora Multi-Importer (IMI)
Next step followed [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#install-the-islandora-multi-importer-imi) to the letter.  It's installed and visible in my `Navigation` menu as it should be.  Moving on...

## Install the Missing Backup and Migrate Module
I did this just as advertised in [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#install-the-missing-backup-and-migrate-module).

## Backup and Restore the Database Using _Backup and Migrate_
I used the first backup option, not the "alternative", and then the restore process documented in [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#backup-and-restore-the-database-using-backup-and-migrate). The process created the same "WSOD" as documented in [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#Restore-results-lots-of-warnings), but when I cleared the cache the site returned, with lots of the same warnings as noted before.

I skipped the diagnostic steps presented in [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#installing-the-missing-islandora-custom-bits), but did run the `git clone...` commands specified for the *Apache* container, and that worked nicely.  

## Temporarily Eliminate Warnings
When it was time to eliminate the remaining warnings I had to add one `drush sqlq...` command (line 5 of 6 below) to the original [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#temporarily-eliminate-warnings) list, so the commands were:

```
cd /var/www/html/sites/default
drush -y dis islandora_binary_object islandora_pdfjs_reader
drush sqlq "DELETE FROM system WHERE name = 'islandora_binary_object' AND type = 'module';"
drush sqlq "DELETE FROM system WHERE name = 'islandora_pdfjs_reader' AND type = 'module';"
drush sqlq "DELETE FROM system WHERE name = 'ldap_servers' AND type = 'module';"
drush cc all

```

The rest of [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld) beginning with the [`Building ISLE-DG-Essentials` section](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/#building-isle-dg-essentials) is geared more to the creation of a `dg-isle` configuration repository, and is not  relevant to my goal of building a `dg-islandora` code repository.  So, this is where I depart from [post 021](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld) in favor of [post 034](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.2.0-ld/).
