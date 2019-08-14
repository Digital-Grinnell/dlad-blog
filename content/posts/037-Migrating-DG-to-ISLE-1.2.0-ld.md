blog/master---
title: Migrating Digital.Grinnell (DG) to ISLE 1.2.0 (ld) for Local Development
publishDate: 2019-08-13
lastmod: 2019-08-14T16:53:57-05:00
draft: false
emojiEnable: true
tags:
  - ISLE
  - v1.2.0
  - local
  - migration
---

This post is a follow-up to [previous post 034](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.2.0-ld/) where I successfully completed a "local" build of ISLE v1.2.0, but did no "customization" of that local instance.  So, this post's intent is to complete the goal stated in [post 034](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.2.0-ld/), specifically to:

{{% original %}}
The goal of this project is to spin up a pristine, local Islandora stack using an updated fork of [the ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE) at https://github.com/DigitalGrinnell/dg-isle, then introduce elements like the [Digital Grinnell theme](https://github.com/DigitalGrinnell/digital_grinnell_theme) and custom modules like [DG7](https://github.com/DigitalGrinnell/dg7).  Once these pieces are in-place and working, I'll begin adding other critical components as well as a robust set of data gleaned from https://digital.grinnell.edu.
{{% /original %}}

As before, this effort will involve an `ld`, or `local development`, instance of Digital.Grinnell on my work-issued Mac Mini, `ma8066`. Unlike my previous work, this instance will follow the guidance of a different document, specifically [`install-local-migrate.md`](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.2.0/docs/install/install-local-migrate.md).

# Fork Synchronization
Before beginning this process I need to get my Github environment updated by synchronizing my ISLE fork with the canonical copy.  I followed [this workflow](https://gist.github.com/CristinaSolana/1885435) to do so, like this:

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/McFateM/ISLE.git <br/> cd ISLE <br/> git remote add upstream https://github.com/Islandora-Collaboration-Group/ISLE.git <br/> git fetch upstream <br/> git pull upstream master <br/> git push <br/> atom . |

Nice!  In case you haven't seen it before, the last command in that sequence, `atom .`, simply opens my `Atom` editor to the new local instance of the `ISLE` project.

# Installing per ISLE's `install-local-migratrion.md`
This is first-and-foremost a `local development` copy of ISLE, but with considerable Digital Grinnell customization, so I'm following the process outlined in the project's `./docs/install/install-local-migration.md`.  References to `Step X` that follow refer to corresponding sections of https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md.  Each section or "Step" listed below is also a link back to the corresponding section of the canonical document.

## [Step 0: Copy Production Data to Your Local](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md#step-0-copy-production-data-to-your-local)

### [Drupal Site Files & Code](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md#drupal-site-files--code)

Per the aforementioned guidance, I did this...

Opened a `zsh` shell (terminal) on Digital.Grinnell production node `DGDocker1` as user `islandora` using `iTerm2` at `ssh://islandora@dgdocker1.grinnell.edu`.  Then, in that shell on the `DGDocker1` host I did:

| DGDocker1 Commands |
| --- |
| cd ~ <br/> mkdir -p migration-copy/var/www/html/sites/default/files <br/> cd migration-copy </br> docker cp isle-apache-dg:/var/www/html/sites/default/files/. var/www/html/sites/default/files/ |

Note that the `-p` option on `mkdir` is critical, it will create all, or port of, the entire directory tree as-specified, if it does not already exist.  The final command, `docker cp...`, subsequently takes advantage of this new directory tree and copies all of the Drupal `.../default/files` from the production container to a similar directory on the host, `DGDocker1` in this case.

For the 2nd bullet item in this step, I've identified that my Drupal/Islandora customizations should eventually reside in the private repo that is https://github.com/McFateM/dg-islandora.

### [Drupal Site Database](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md#drupal-site-database)

For this process I already have a workflow in place, and it's a little different than what's documented.  So here's what I did:

  - Visit my production site at https://digital.grinnell.edu.
  - Login as the `System Admin`, that's `User 1` or the super-user in Drupal terms.
  - The home page at https://digital.grinnell.edu provides, in the right-hand menu bar, a `Management` menu with a first option to `Clear cache`.  Click it.
  - The home page also provides a `Quick Backup` block where the default options do a great job of backing up only what's needed.  Accept all defaults and click the `Backup Now` button.  This feature takes the site offline, makes and downloads a backup of the database (in my case it created `digital.grinnell.edu-2019-08-13T15-51-20.mysql`), and brings the site back online..."automagically".  

### [Fedora Hash Size (Conditional)](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md#fedora-hash-size-conditional)

I found this section a little confusing, which I assume means that it does not apply to Digital.Grinnell.  Moving on.

### [Solr Schema & Islandora Transforms](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md#solr-schema--islandora-transforms)

This section definitely applies to Digital.Grinnell! :blush: Since I recently completed spin-up of a "Demo" ISLE using `install-local-new.md`, and since this is "not my first rodeo", I choose to take the "advanced" path here and will "[diff & merge current production customization edits into ISLE configs](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.2.0/docs/install/install-local-migrate.md#advanced---diff--merge-current-production-customization-edits-into-isle-configs)".  Wish me luck.  :four_leaf_clover:

To begin this portion of the process I created a new `~/diff-and-merge-customizations` directory structure and with https://isle.localdomain running the `Demo`, I copied files from it like so:

| Workstation Commands |
| --- |
| mkdir -p ~/diff-and-merge-customizations/ld <br/> mkdir -p ~/diff-and-merge-customizations/prod <br/> cd ~/diff-and-merge-customizations/ld <br/> docker cp isle-solr-ld:/usr/local/solr/collection1/conf/schema.xml schema.xml <br/> docker cp isle-fedora-ld:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt foxmlToSolr.xslt <br/> docker cp isle-fedora-ld:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms islandora_transforms |

I subsequently pulled the three diff targets from my production instance of ISLE using these commands on `DGDocker1`, followed by another set on my workstation:

| DGDocker1 Commands |
| --- |
| mkdir -p ~/migration-copy/solr <br/> mkdir -p migration-copy/fedora <br/> cd migration-copy/solr <br/> docker cp isle-solr-dg:/usr/local/solr/collection1/conf/schema.xml . <br/> cd ../fedora <br/> docker cp isle-fedora-dg:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt . <br/> docker cp isle-fedora-dg:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms islandora_transforms |

| Workstation Commands |
| --- |
| cd ~/diff-and-merge-customizations/prod <br/> rsync -aruvi islandora@dgdocker1.grinnell.edu:migration-copy/solr/. . <br/> rsync -aruvi islandora@dgdocker1.grinnell.edu:migration-copy/fedora/. . |

This left me with a local `~/diff-and-merge-customizations` directory with sub-dirs `ld` and `prod`. The diff-and-merge operation subsequently compared the contents of these two sub-dirs, merging the differences from `prod` into the corresponding files found in `ld`.  I did both the `diff` and merge operations using `Atom`.

The command and output from the first `diff` of the `islandora_transforms` was:

```
╭─markmcfate@ma8660 ~
╰─$ cd ~/diff-and-merge-customization/ld
╭─markmcfate@ma8660 ~/diff-and-merge-customization/ld
╰─$ diff -r islandora_transforms ../prod/islandora_transforms   1 ↵
Only in islandora_transforms: .git
diff -r islandora_transforms/WORKFLOW_to_solr.xslt ../prod/islandora_transforms/WORKFLOW_to_solr.xslt
95c95
</xsl:stylesheet>
\ No newline at end of file
---
</xsl:stylesheet>
```

So, no significant differences here. Yay!

Next, I compared the two files, one-at-a-time, using `Atom` and its `Split Diff` package.  There were very few differences in `foxmToSolr.xslt` so it was easy to merge. I took the significant differences in the `prod` copy and merged them into the `ld` copy.  I did the same with `schema.xml`, but it was an entirely different beast.  There were 34 sections of differences, and in many cases it was not clear if our existing customizations should be merged. As a result, **the changes I made in `schema.xml`, and some I did NOT make, will need to be carefully re-evaluated as this local migrate "test" proceeds**.

**Now things get confusing**...

I followed the documented "diff and merge" process with:

| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> git checkout -b diff-and-merge-customizations <br/> mkdir -p config/solr <br/> cp -f diff-and-merge-customizations/ld/schema.xml config/solr/. <br/> mkdir -p config/fedora/gsearch <br/> cp -fr diff-and-merge-customizations/ld/islandora_transforms config/fedora/gsearch/. <br/> cp -f diff-and-merge-customizations/ld/foxmlToSolr.xslt config/fedora/gsearch/ |

Next, I returned to `Atom` and used it to edit my `docker-compose.local.yml` file as instructed, with additions to the `solr` and `fedora` volumes sections like so:

```
solr:
  ...
  volumes:
    - isle-solr-data:/usr/local/solr
    - ./config/solr/schema.xml:/usr/local/solr/collection1/conf/schema.xml
```

```
fedora:
  ...
  volumes:
    ...
    - isle-fedora-XACML:/usr/local/fedora/data/fedora-xacml-policies
    - ./config/fedora/gsearch/islandora_transforms:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms
    - ./config/fedora/gsearch/foxmlToSolr.xslt:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
```

Phew, that was a lot of Step 0!

## [Step 1: Edit `/etc/hosts` File](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-migrate.md#step-1-edit-etchosts-file)
Easy peasy, relatively speaking.  :smile:

## [Step 2: Setup Git for the ISLE Project](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-migrate.md#step-2-setup-git-for-the-isle-project)

I have to confess, I'm already confused reading this.  In the first bullet there's a statement: "create this new empty git repositories" followed by a single sub-bullet, _i_.  Is there going to be more than one empty repository, because I can't find _ii_ anywhere?

In any case, I think I've already satisified the reqiurements of `Step 2` with [my `dg-isle` project repository from `install-local-new.md`](https://github.com/McFateM/dg-isle).

## [Step 3. `git clone` the Production Drupal Site Code](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-migrate.md#step-3-git-clone-the-production-drupal-site-code)

OK, having just read this section I think I see what the "missing" _ii_ reference in `Step 2` needs to be. This step assumes that I already have an Islandora/Drupal code repository with all my customization in it, I don't, but I know what's needed and how to get there.  That repo, in my case, is https://github.com/McFateM/dg-islandora, but my copy isn't complete yet.

...be right back...

<!-- The old post 034 info is below...

## [Step 1: Edit the `/etc/hosts` File](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-1-edit-etchosts-file)

In this step I found it necessary to be very diligent about editing my `/etc/hosts` file, even though I've done this a thousand times (and that's not exaggerated).  Why?  Because every time I update `Docker Desktop for Mac`, the hideous thing adds a new `127.0.0.1` entry to the bottom of my `/etc/hosts` file, effectively overriding my own additions.

## [Step 2: Setup Git for the ISLE Project](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-2-setup-git-for-the-isle-project)

I choose **dg** as my value for `yourprojectnamehere`, and since this step calls for creation of two **private** repos, I made mine:

  - https://github.com/McFateM/dg-isle
  - https://github.com/McFateM/dg-islandora

Then I cloned the empty https://github.com/McFateM/dg-isle to `ma7053` and activated the `ISLE-v1.2.0-dev` branch like so:

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/McFateM/dg-isle.git <br/> cd dg-isle |

Next, I had to deviate from the documentation just a bit.  The docs call for creating an `icg-upstream` remote for the new local repo, then doing `git fetch icg-upstream`. However, in my case I needed to create an alternate "upstream" remote, fetch from it, and ultimately work with the `ISLE-v1.2.0-dev` branch of it, like so:

| Workstation Commands |
| --- |
| cd ~/Projects/dg-isle <br/> git remote add icg-upstream https://github.com/Islandora-Collaboration-Group/ISLE.git <br/> git remote add bd-upstream https://github.com/Born-Digital-US/ISLE.git <br/> git fetch bd-upstream <br/> git checkout -b ISLE-v1.2.0-dev <br/>  git pull bd-upstream ISLE-v1.2.0-dev <br/> git push -u origin ISLE-v1.2.0-dev <br/> atom . |

The final command in that sequence simply opened a copy of the local `ISLE-v1.2.0-dev` project files in my [Atom](https://atom.io) editor.

## [Step 3: Edit the `.env` File to Change to the Local Environment](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-3-edit-the-env-file-to-change-to-the-local-environment)

Since this is a short-lived, local, development project, I have no reservations about sharing this with you.  So, as instructed I modified `.env` to read as follows:

```
#### Activated ISLE environment
# To use an environment other than the default Demo, please change values below
# from the default Demo to one of the following: Local, Test, Staging or Production
# For more information, consult https://islandora-collaboration-group.github.io/ISLE/install/install-environments/

COMPOSE_PROJECT_NAME=dg_local
BASE_DOMAIN=dg.localdomain
CONTAINER_SHORT_ID=ld
COMPOSE_FILE=docker-compose.local.yml
```

## [Step 4: Create New Users and Passwords by Editing `local.env`](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-4-create-new-users-and-passwords-by-editing-localenv)

No secrets here either... a copy of [my customized `local.env` file in this gist](https://gist.github.com/McFateM/7af92bb51a239d1a36df06a4fa629a94).  

The `install-local-new.md` document is deserving of a couple comment here:

  - I like this document so much better now that config file line number references have been PURGED and replaced with contextual references.  :smile:
  - Hint: If you do as I did, and use [Atom](https://atom.io) or some other handy editor of your choice, when you edit these files it's easy to let auto-complete do the typing for you, and that's really nice when you have to repeat long strings, like a 26-character password, or a 45-character hash salt. :grin:

One change that I would still like to see... be consistent and change the headings in `install-local-new.md` to "Title Case", as I have done in this blog post.

## [Step 5: Create New Self-signed Certs for Your Project](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-5-create-new-self-signed-certs-for-your-project)

As before, no secrets here, so there's a copy of [my customized `local.sh` file in this gist](https://gist.github.com/McFateM/c5def81467d2dfc9c378c4637a690104).  

## [Step 6: Download the ISLE Images](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-6-download-the-isle-images)

Only comment here is that **you must navigate to your project folder, like `cd ~/Projects/dg-isle`, before you do** `docker-compose pull`.  The command will not work properly in any other directory!

## [Step 7: Launch Process](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-7-launch-process)

Same comment here as above, **you must navigate to your project folder, like `cd ~/Projects/dg-isle`, before you do** `docker-compose up -d`.  The command will not work properly in any other directory!

## [Step 8: Run Islandora / Drupal Site Install Script](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-8-run-islandora--drupal-site-install-script)

Ok, fingers crossed for good luck. :v:  I left `docker-compose.local.yml` just as it was, right out of the box, and did almost as instructed:

```
time docker exec -it isle-apache-ld bash /utility-scripts/isle_drupal_build_tools/isle_islandora_installer.sh
```

Note the addition of the `time` command out front; that was put there to record how long this process takes.  My `time` results... `0.22s user 0.31s system 0% cpu 28:01.00 total`.

## [Step 9: Test the Site](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-9-test-the-site)

Woot!  It works! :sparkles::thumbsup::sparkles: No funky errors this time.

For the record (remember, no secrets here) my admin username and password for the site are: `administrator` and `twentysixalphacharactersnow`.  

## [Step 10: Ingest Sample Objects](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-10-ingest-sample-objects)

I followed the instructions to-the-letter and ended up populating my local repository with 2 basic images, 1 large image, 1 video, and 1 PDF.  All of the objects ingested and behaved as-expected.

Next, I added the `Islandora Simple Search` block as instructed, and ran some search tests.  :ballot_box_with_check: It works!

## [Step 11: Check-in the Newly Created Drupal / Islandora Site Code to a Git Repository](https://github.com/Born-Digital-US/ISLE/blog/master/docs/install/install-local-new.md#step-11-check-in-the-newly-created-drupal--islandora-site-code-into-a-git-repository)

OK, I have to admit this "step" was confusing at first, but it works and seems to make sense now that I've completed it.  I'll spare you the output details, because there was a LOT of it, but here is the exact command sequence I used...

| Workstation Commands |
| --- |
| cd ~/Projects/dg-isle <br/> git checkout -b ISLE-v1.2.0-dev <br/> cd data/apache/html <br/> git init <br/> git add . <br/> git commit -m "Created new dg.localdomain site" <br/> git remote add origin https://github.com/McFateM/dg-islandora.git <br/> git push -u origin master |

## Something Missing Here?

Step 11 is essentially the end of the `install-local-new.md` process, but it left me with a local ISLE project, namely `~/Projects/dg-isle`, with the following Git status and remotes...

```
╭─markmcfate@ma7053 ~/Projects/dg-isle ‹ruby-2.3.0› ‹ISLE-v1.2.0-dev*›
╰─$ git status
On branch ISLE-v1.2.0-dev
Your branch is up to date with 'origin/ISLE-v1.2.0-dev'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   .env
	modified:   config/apache/settings_php/settings.local.php
	modified:   config/proxy/traefik.local.toml
	modified:   local.env
	modified:   scripts/proxy/ssl-certs/local.sh

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	config/proxy/ssl-certs/dg.localdomain.key
	config/proxy/ssl-certs/dg.localdomain.pem

no changes added to commit (use "git add" and/or "git commit -a")
╭─markmcfate@ma7053 ~/Projects/dg-isle ‹ruby-2.3.0› ‹ISLE-v1.2.0-dev*›
╰─$ git remote -v
bd-upstream	https://github.com/Born-Digital-US/ISLE.git (fetch)
bd-upstream	https://github.com/Born-Digital-US/ISLE.git (push)
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (fetch)
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (push)
origin	https://github.com/McFateM/dg-isle.git (fetch)
origin	https://github.com/McFateM/dg-isle.git (push)
```

This is a local ISLE with no secrets, so wouldn't it be prudent to add all of these changes (`git add -A`), commit them (`git commit -m "Completed install-local-new process"`), and push them to `origin` (`git push origin ISLE-v1.2.0-dev`)?

I hope that was the right thing to do, because I just did it.  :heavy_exclamation_mark:

<!-- This is the end of the NEW document.  What follows is from the old document...

<br/> git checkout -b ISLE-v1.2.0-dev

## A Bit of History
I've already got two forks of the [Islandora Collaboration Group's ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE) so it's not practical to create another withtout some changes.  So, the first step in my process is rename my [old fork](https://github.com/DigitalGrinnell/ISLE) to it's new identity: https://github.com/DigitalGrinnell/ISLE-Deprecated-Fork, and clone that to `~/Projects/ISLE-Deprecated-Fork` on `MA8660` for safe-keeping.  I also renamed my existing `~/Projects/ISLE` folder on `MA8660` to `~/Projects/ISLE-Archived-0805` to get it out of the way.

## Creating a New Fork
I subsequently deleted https://github.com/DigitalGrinnell/ISLE-Deprecated-Fork so that I could make a fresh new fork, this time from https://github.com/Born-Digital-US/ISLE, where the `ISLE-v1.2.0-dev` branch can be found, to https://github.com/Born-Digital-US/ISLE.  This is the code and documentation that I'll be working from now.

## Cloning to Local
Next step created a local instance of the new fork so I cloned it to `MA8660`, made the `ISLE-v1.2.0-dev` branch active there, and launched my `Atom` editor to browse files. The following command stream captures all of that...

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/DigitalGrinnell/ISLE <br/> cd ISLE <br/> git checkout ISLE-v1.2.0-dev <br/> atom . |

## Installing per install-local-new.md
This is first-and-foremost a `local development` copy of ISLE, but with considerable Digital Grinnell customization, so I'm following the process outlined in the project's `./ISLE/docs/install/install-local-new.md`.

## Step 1: Edit `/etc/hosts` File
This step calls for editing the host's `/etc/hosts` file, but my edits are already in place on `MA8660`, like so:
```
127.0.0.1    localhost  isle.localdomain admin.isle.localdomain images.isle.localdomain portainer.isle.localdomain
```

# Step 2. Setup `git` for the ISLE Project
This step calls for the creation of two `private` repositories; I made mine https://github.com/McFateM/dg-isle and https://github.com/McFateM/dg-islandora.  My local clone of ISLE is in `~/Projects/ISLE`, on the `ISLE-v1.2.0-dev` branch there, so I created remotes there that look like this:

```
╭─markmcfate@ma8660 ~/Projects/ISLE ‹ruby-2.3.0› ‹ISLE-v1.2.0-dev›
╰─$ git remote -v
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (fetch)
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (push)
origin	https://github.com/DigitalGrinnell/ISLE.git (fetch)
origin	https://github.com/DigitalGrinnell/ISLE.git (push)
```

## Step 3: Edit the `.env` File to Change to the Local Environment
Followed to the letter.

## Step 4: Create New Users and Passwords by Editing `local.env`
Followed to the letter.

## Step 5: Create New Self-signed Certs for Your Project
Followed to the letter.  **Suggestion - It's not clear here that the certs are generated into `./config/proxy/ssl-certs` since the `./config/` prefix is NOT documented.  This is especially misleading since we are working in `./scripts/proxy/ssl-certs` at the time!**

## Step 6: Download the ISLE Images
Followed to the letter.

## Step 7. Launch Process
Followed to the letter.  **Suggestion - To determine when the process is finished...**
```
docker logs isle-apache-ld
```
When complete this log dump should end with a line something like this:
```
[%timestamp%] [core:notice] [pid %%%] AH00094: Command line: '/usr/sbin/apache2 -D FOREGROUND'
```

## Step 8. Run Islandora / Drupal Site Install Script


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

Note that even with this change you will still get the following error when trying to update the _FEDORA_ `Resource Index` (RI):

```
Rebuilding...
java.lang.UnsupportedOperationException: This MulgaraConnector is read-only!
```

To get around this problem, permanently, I've modified the `docker-compose.override.yml` file to keep the `RI` off of the USB stick.  Not convenient, but apparently necessary.

## Re-Index DG-FEDORA and Solr
To re-index the *Fedora* repository on the aforementioned USB stick, follow the documented guidance at:
https://islandora-collaboration-group.github.io/ISLE/migrate/reindex-process/.

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

## Check Your Status
At this point in the process I had a working local ISLE instance that looks and behaves almost exactly like _Digital.Grinnell_.  That's great!  But not perfect.  8^(  I also noted that there were NO oral history objects in my portable _FEDORA_ repository yet, and when I tried to add one I got a host of warnings.  So, I decided to pay a visit to https://isle.localdomain/admin/reports/status, the _Drupal_ site status report.  That report did flag a host of issues, mostly related to my `private file system`.  The full report is captured in [this gist](https://gist.github.com/McFateM/c5ea76f38c06971df32dcdaf90d61b45).

To correct the most pressing problem, the lack of a `private file system`, try this:

| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> docker exec -it isle-apache-ld bash |  

| Apache Container Commands |
| --- |
| cd /var/www <br/> mkdir private <br/> chown islandora:www-data private <br/> chmod 774 private <br/> cd /var/www/html/sites/default <br/> drush cc all |

Now revisit http://isle.localdomain/admin/reports/status and refresh your browser to see if this has fixed one or more issues.  In my case, multiple issues were resolved by taking this action.  However, one critical issue remained:
```
Error - Database updates -	Out of date
Some modules have database schema updates to install. You should run the database update script immediately.
```

I opened the [database update script](https://isle.localdomain/update.php?op=info) in my browser and used it to run all pending updates, 7 of them.  I then returned to the site's [home page](http://isle.localdomain) and used the `Clear Cache` link in the right-hand margin (under the `Development` menu heading) to refresh the cache.  Then I re-visited the [status report](http://isle.localdomain/admin/reports/status) for one more check.  Only the inconsequential `Glip Library` and `HTTP request status` warnings remain.

## Ingest an Oral History with Transcription
My `DG-FEDORA` USB stick is still read/write mounted at `/Volumes/DG-FEDORA` so I put a copy of one transcribed oral history interview package (an entire directory of files) titled `Lynne_Simcox_64` on the stick.  Ingest of this content went something like this:

  - Open https://isle.localdomain/islandora/object/grinnell:alumni-oral-histories/manage
  - Click the `Add an object to this Collection` link
  - I entered minimal metadata (only the `Title` is required) and clicked `Next`
  - At the `Video or Audio` prompt I browsed and selected the `Lynne_Simcox_64.MP3` file in `/Volumes/DG-FEDORA/Lynne_Simcox_64`, then clicked `Upload`
  - Under the `Trasncript file` prompt I browsed and selected `Lynne_Simcox_64_transcript.xml` from the same directory and clicked `Upload`
  - Finally, I clicked `Ingest` and waited for a couple of minutes for the magic to happen

What I got in the end were these messages:

```
    Derivatives successfully created.
    "Lynne Simcox '64" (ID: grinnell:25497) has been ingested.
```

...plus an ominous message stating: ` This transcript is still being processed for display.`  That's the "error" I am trying to debug/eliminate now, but since that debugging is not part of a "normal" spin-up of _ISLE_, I'm going to document it in a future blog post (starting minutes from now).

And that's a wrap.  Until next time...

-->
