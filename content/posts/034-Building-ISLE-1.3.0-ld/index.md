---
title: Building ISLE 1.3.0 (ld) for Local Development
publishDate: 2019-08-05
lastmod: 2019-11-05T20:38:47-05:00
draft: false
emoji: true
tags:
  - ISLE
  - ISLE-1.3.0
  - local
---

This post, an updated (the original was written in August 2019 for ISLE-1.2.0) follow-up to [a previous post](/posts/021-rebuilding-isle-ld/) is intended to chronicle my efforts to build a new ~ISLE v1.2.0~ ISLE-1.3.0, _ld_, or _local development_, instance of Digital.Grinnell on my work-issued MacBook, _ma7053_.  

## Goal Statement
The goal of this project is to spin up a pristine, local Islandora stack using an updated fork of [the ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE) at https://github.com/Digital-Grinnell/dg-isle, then introduce elements like the [Digital Grinnell theme](https://github.com/DigitalGrinnell/digital_grinnell_theme) and custom modules like [DG7](https://github.com/DigitalGrinnell/dg7).  Once these pieces are in-place and working, I'll begin adding other critical components as well as a robust set of data gleaned from https://digital.grinnell.edu.

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
╭─markmcfate@ma7053 ~/Projects/dg-isle ‹ruby-2.3.0› ‹ld*›
╰─$ docker exec -it isle-apache-ld bash
root@9bec4edd3964:/# cd /var/www/html
root@9bec4edd3964:/var/www/html#
```
| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> docker exec -it isle-apache-ld bash |

# Installing per [install-local-new.md](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md)

This is first-and-foremost a _local development_ copy of _ISLE_, but with considerable _Digital.Grinnell_ customization, so I'm following the process outlined in the project's _./docs/install/install-local-new.md_. References to _Step X_ that follow refer to corresponding sections of [install-local-new.md](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md).  Each section or "Step" listed below is also a link back to the corresponding section of the canonical document.

## [Step 1: Choose a Project Name](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-1-choose-a-project-name)

I choose a very short and simple name, __dg__, as my value for _yourprojectnamehere_.

## [Step 1.5: Edit "/etc/hosts" File](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-15-edit-etchosts-file)

In this step I found it necessary to be very diligent about editing my _/etc/hosts_ file, even though I've done this a thousand times (and that's not exaggerated).  Why?  Because every time I update _Docker Desktop for Mac_, the hideous thing adds a new _127.0.0.1_ entry to the bottom of my _/etc/hosts_ file, effectively overriding my own additions.

The critical line in _/etc/hosts_ now reads:
```
127.0.0.1    localhost dg.localdomain admin.dg.localdomain images.dg.localdomain portainer.dg.localdomain
```

And there's no comment, and no active `127.0.0.1...` lines later in the file!

## [Step 2: Setup Git Project Repositories](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-2-setup-git-project-repositories)

Since I choose **dg** as my value for `yourprojectnamehere`, and since this step calls for creation of two **private** repos, I logged in to _Github_ as "Digital-Grinnell" and created:

  - https://github.com/Digital-Grinnell/dg-isle
  - https://github.com/Digital-Grinnell/dg-islandora

Then I cloned the empty https://github.com/Digital-Grinnell/dg-isle to _ma7053_ and made the prescribed additions like so:

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/Digital-Grinnell/dg-isle <br/> cd dg-isle <br/> git remote add icg-upstream https://github.com/Islandora-Collaboration-Group/ISLE.git <br/> git remote -v <br/> git fetch icg-upstream <br/> git pull icg-upstream master <br/> git push -u origin master <br/> atom . |

The final command in that sequence simply opened a copy of the local _dg-isle_ project files in my [Atom](https://atom.io) editor.

## [Step 3: Edit the ".env" File to Point to the Local Environment](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-3-edit-the-env-file-to-point-to-the-local-environment)

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

## [Step 4: Create New Users and Passwords by Editing "local.env" File](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-4-create-new-users-and-passwords-by-editing-localenv-file)

No secrets here either... Since this is a _local_ instance of _ISLE_, I set the following:

| Item(s) | My Value |
| --- | --- |
| All site, user, and database names | **local** |
| All passwords | **password** |
| All hashes | **thisisalengthyhash** |

Also note that I kept all of the original _# Replace this..._ comments by pushing them to the line below.  A copy of my customized _local.env_ file can be found [in this gist](https://gist.github.com/Digital-Grinnell/8449b99fb55d26531b139f3202b33bdd).  

## [Step 5: Create New Self-Signed Certs for Your Project](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-5-create-new-self-signed-certs-for-your-project)

As before, no secrets here, so there's a copy of my customized _local.sh_ file [in this gist](https://gist.github.com/Digital-Grinnell/6135109fd87c7e6b8cd4847a86227cb9) and my _traefik.local.toml_ file [in this gist](https://gist.github.com/Digital-Grinnell/c931d07b74e67eaa26d6aa090c1fb0df).

Certs were generated as prescribed.  All is well.

## [Step 6: Download the ISLE Images](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-6-download-the-isle-images)

Only comment here is that **you must navigate to your project folder, like `cd ~/Projects/dg-isle`, before you do** `docker-compose pull`.  The command will not work properly in any other directory!  

I used the command `time docker-compose pull` so:

| Workstation Commands |
| --- |
| cd ~/Projects/dg-isle <br/> time docker-compose pull |

And my download time was: `docker-compose pull  3.95s user 0.89s system 2% cpu 3:21.16 total`.

## [Step 7: Launch Process](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-7-launch-process)

Same comment here as above, **you must navigate to your project folder, like `cd ~/Projects/dg-isle`, before you do** `docker-compose up -d`.  The command will not work properly in any other directory!

| Workstation Commands |
| --- |
| cd ~/Projects/dg-isle; <br/> time docker-compose up -d; <br/> sleep 300; <br/> docker ps; <br/> docker ps -a |

And my launch time was: `docker-compose up -d  1.45s user 0.34s system 14% cpu 12.546 total`.  Elapsed time was, of course, on the order of 6 minutes.

## [Step 8: Run Islandora Drupal Site Install Script](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-8-run-islandora-drupal-site-install-script)

Ok, fingers crossed for good luck. :v:  I left `docker-compose.local.yml` just as it was, right out of the box, and did almost as instructed:

| Workstation Commands |
| --- |
| cd ~/Projects/dg-isle; <br/> time docker exec -it isle-apache-ld bash -c "cd /utility-scripts/isle_drupal_build_tools && ./isle_islandora_installer.sh" |

Note the addition of the `time` command out front; that was put there to record how long this process takes.  My `time...` results: `docker exec -it isle-apache-ld bash -c   0.21s user 0.15s system 0% cpu 31:07.34 total`.

## [Step 9: Test the Site](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-9-test-the-site)

Woot!  It works! :sparkles::thumbsup::sparkles: No funky errors this time.

For the record (remember, no secrets here) my admin username and password for the site are: `local` and `password`.  Pretty sneaky, eh?  And the address is https://dg.localdomain.

## [Step 10: Ingest Sample Objects](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-10-ingest-sample-objects)

OK, so this is where I generally depart from the "script", because I'm lazy, and I already have a portable _Fedora_ repository to test from.  So, my process in this step follows what I wrote more than a month ago, [046 DG-FEDORA: A Portable Object Repository](/posts/046-dg-fedora-a-portable-object-repository/).

Next, I added the _Islandora Simple Search_ block as instructed in [Step 10: Ingest Sample Objects](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-10-ingest-sample-objects), and ran some search tests.  :ballot_box_with_check:  It works!

## [Step 11: Check-In the Newly Created Islandora Drupal Site Code Into Your Git Repository](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-11-check-in-the-newly-created-islandora-drupal-site-code-into-is-git-repository)

OK, I have to admit this "step" was confusing at first, but it works and seems to make sense now that I've completed it.  I'll spare you the output details, because there was a LOT of it, but here is the exact command sequence I used...

| Workstation Commands |
| --- |
| cd ~/Projects/dg-isle <br/> git checkout master <br/> cd data/apache/html <br/> git init <br/> git add . <br/> git commit -m "Created new dg.localdomain site" <br/> git remote add origin https://github.com/Digital-Grinnell/dg-islandora.git <br/> git push -u origin master |

## Something Missing Here?

Step 11 is essentially the end of the _install-local-new.md_ process, but it left me with a local ISLE project directory, namely _~/Projects/dg-isle_, with the following _Git_ status and remotes...

```
╭─markmcfate@ma7053 ~/Projects/dg-isle ‹ruby-2.3.0› ‹master*›
╰─$ git status; git remote -v
On branch master
Your branch is up to date with 'origin/master'.

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
	docker-compose.DG-FEDORA.yml

no changes added to commit (use "git add" and/or "git commit -a")
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (fetch)
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (push)
origin	https://github.com/Digital-Grinnell/dg-isle (fetch)
origin	https://github.com/Digital-Grinnell/dg-isle (push)
```

Since this is a local ISLE with no secrets, it seems prudent to add, commit, and push at least my "off-script" additions, _.env_ and _docker-compose.DG-FEDORA.yml_.  To safeguard against making a bad move I'm going to approach this like so:

| Workstation Commands |
| --- |
| cd ~/Projects/dg-isle <br/> git checkout -b local-with-dg-fedora <br/> git add .env docker-compose.DG-FEDORA.yml  <br/> git commit -m "Added DG-FEDORA to dg.localdomain site" <br/> git push -u origin local-with-dg-fedora |

I hope that was the right thing to do, because I just did it.  :heavy_exclamation_mark:

And that's a wrap.  Until next time...
