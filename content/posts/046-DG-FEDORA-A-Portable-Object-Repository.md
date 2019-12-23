---
title: "DG-FEDORA: A Portable FEDORA Repository"
publishdate: 2019-09-16
lastmod: 2019-12-23T10:43:02-05:00
draft: false
tags:
  - DG-FEDORA
  - FEDORA
  - portable
  - docker-compose
  - override
  - COMPOSE_FILE
  - re-index
---

## Teaser

Late last night (don't ask how late it was) I discovered a really slick trick, aka "feature", of _docker-compose_.  Full disclosure: I love _docker-compose_ "overrides", a feature I found a couple of months ago. However, implementing overrides in a granular fashion, as I'd like, and within a _docker-compose_ hierarchy of environments like the [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) stack, can be difficult and counter-productive. I may have found a workable compromise last night.  If you're interested, please, read on...

## History

About a year ago I created a "portable" _FEDORA_ object repository "on a stick", a USB stick.  I call that "stick" _DG-FEDORA_, because it contains a number of sample objects gleaned from [Digital.Grinnell.edu](https://digital.grinnell.edu). Shortly after I created the "stick" I started using a _docker-compose.override.yml_ file (see [Adding and overriding configuration](https://docs.docker.com/compose/extends#adding-and-overriding-configuration) for details) to implement it in some of my _ISLE_ work.  But there were lots of other "customizations" that I also wanted to implement, and over time my _docker-compose.override.yml_ grew too large to be easily maintained...there was just too much stuff to squeeze into a file that was supposed to make life easier.

## ISLE Details

The _ISLE_ stack now uses a very simple and elegant _.env_ file -- four lines of environment variables, nothing more -- to ultimately control what the _docker-compose_ command does.  The last environment variable in the file is `COMPOSE_FILE`, and I found that this variable can be used to specify "multiple" _.yml_ files to build a stack; and _docker-compose_ does so using a well-documented and sensible set of rules. Nirvana!

## The Solution

So what I've done is simply provide a modified _.env_ file and some instruction for using it properly.  My _.env_ file (there is a copy of it on the _DG-FEDORA_ USB stick) reads like this:

```
#### Activated ISLE environment
# To use an environment other than the default Demo, please change values below
# from the default Demo to one of the following: Local, Test, Staging or Production
# For more information, consult https://islandora-collaboration-group.github.io/ISLE/install/install-environments/

COMPOSE_PROJECT_NAME=isle_demo
BASE_DOMAIN=isle.localdomain
CONTAINER_SHORT_ID=ld
# COMPOSE_FILE=docker-compose.demo.yml
COMPOSE_FILE=docker-compose.demo.yml:docker-compose.DG-FEDORA.yml
```  

In the file above, note that I've commented out the original definition of _COMPOSE_FILE_ and added my own definition which appends a second _.yml_ file reference to the original.  That 2nd file, _docker-compose.DG-FEDORA.yml_ is also provided on the _DG-FEDORA_ USB stick and it reads like this:

```
version: '3.7'

#### docker-compose up -d;
## Local Environment - Used for Drupal site development, more extensive metadata, Solr and Fedora development work on a local laptop or workstation
## Updated 2019-09 - Release 1.3.0-dev (@ 1.3.0-dev)

services:

  # Bind-mount the datastreamStore and objectStore directories in /Volumes/DG-FEDORA (the USB stick)
  #  into the FEDORA container to become our FEDORA datastream and object store directories.  FEDORA digital
  #  live in these directories, so this effectively puts your FEDORA repository on the DG-FEDORA stick.

  fedora:
    volumes:
      - /Volumes/DG-FEDORA/datastreamStore:/usr/local/fedora/data/datastreamStore
      - /Volumes/DG-FEDORA/objectStore:/usr/local/fedora/data/objectStore

  # Bind-mount the /Volumes/DG-FEDORA/Storage directory tree in the Apache container. This bind-mount to /mnt/storage
  #  is usefule with IMI, the Islandora Multi-Importer when a local* file fetch hook is defined, as it is in the DG7
  #  custom module.

  apache:
    volumes:
      - /Volumes/DG-FEDORA/Storage:/mnt/storage
```

Simple. It's just a repeat of the original _docker-compose.demo.yml_ file with only the necessary "overrides" included.

The _DG-FEDORA_ USB stick also includes a _README.md_ file and since you don't have a copy of the "stick", I'll share that with you here.

# A Master Copy of _DG-FEDORA_

My _Digital.Grinnell_ staging server, _DGDockerX_ is a networked _CentOS 7_ virtual machine with lots of available storage, but no accessible USB ports, or course...it's a VM after all.  Consequently, it's not practical to maintain all of my "portable" _FEDORA_ data on a USB stick alone. So, on _DGDockerX_ I've created a copy of the _DG-FEDORA_ USB stick at `/mnt/data/DG-FEDORA`, and I've declared it to be copy "zero", so on it there's a `DG-FEDORA-0.md` file proclaiming it to be the "master" copy of _DG-FEDORA_.

It's worth noting, perhaps, that at the time of this writing _DG-FEDORA-0_ contains 126 _FEDORA_ objects.  **Anything less than that number should be considered an incomplete set**.  

The `README.md` file on the `DG-FEDORA-0` **MASTER** volume suggests using a command like this to copy the **MASTER** repository to a mounted `DG-FEDORA` USB stick:

```
sudo rsync -aruvi --exclude DG-FEDORA-0.md --exclude from-DGDocker1 --exclude site-public islandora@132.161.132.101:/mnt/data/DG-FEDORA/. /Volumes/DG-FEDORA/. --progress
```

# README.md from DG-FEDORA

_DG-FEDORA_ is the name of a USB stick/volume (I actually maintain 2 USB memory sticks named _DG-FEDORA_, numbers 1 and 2) which holds a small sample of FEDORA digital objects gleaned from [Digital.Grinnell](https://digital.grinnell.edu).  Using _DG-FEDORA_ you can easily add a pre-populated repository of objects to your "demo" or "local" environment _ISLE_ project in as little as 5 minutes.

## Prerequisites

To successfully use _DG-FEDORA_ your system will need to meet the following prerequisite requirements.

  - Your workstation must meet all the hardware requirements of ISLE.  See _ISLE_'s _./docs/install/host-hardware-requirements.md_ for details.
  - Your workstation environment must meet all the minimum software requirements of _ISLE_.  See _ISLE_'s _./docs/install/host-software-dependencies.md_ for details.
  - This workflow assumes your workstation is running OSX.  Other workstation types supported by _ISLE_ may be acceptable, but the _DG-FEDORA_ USB volume will have to be mounted differently.
  - You must have a working "demo" or "local" _ISLE_ environment already running.

## Mounting DG-FEDORA

In MacOSX you simply have to plug the _DG-FEDORA_ USB stick into an available USB port on your Mac workstation.  After a few seconds the USB stick will be automatically mounted as _/Volumes/DG-FEDORA_, and the _/Volumes_ directory is automatically "shared" with _Docker_.

### Make DG-FEDORA Writable

In MacOSX, open a terminal and use the following command to make _DG-FEDORA_ writable, so that you can save newly ingested objects and updates to existing objects:

  - `sudo mount -u -w /Volumes/DG-FEDORA`

## Not Using MacOSX?  

If your workstation is not a Mac, you will need to insert the USB stick and take appropriate steps to:

  - Mount the stick with read/write permissions as _/Volumes/DG-FEDORA_.
  - Share the _/Volumes_ or _/Volumes/DG-FEDORA_ directory in your _Docker_ settings/preferences.

## Modifying the _ISLE_ Environment

Navigate to your _ISLE_ project directory and execute the following operations:

  - Shut down _ISLE_ if it is running.  Example: `cd ~/pathto/ISLE; docker-compose down`.  These commands will do no harm if _ISLE_ is not currently running.
  - Copy two files from _DG-FEDORA_ to your local project.  Example: `cd /Volumes/DG-FEDORA; cp -f .env docker-compose.DG-FEDORA.yml ~/pathto/ISLE/.`
  - Edit the new _ISLE_ project _.env_ file according to directions within the file.  Example: `nano ~/pathto/ISLE/.env`.  The objective is to select the appropriate "demo" or "local" environment as needed.
  - Navigate to your project directory and restart the stack.  Example: `cd ~/pathto/ISLE; docker-compose up -d`.
  - Wait until the stack has started, open your browser and visit your site at https://isle.localdomain (demo) or https://yourprojectnamehere.localdomain (local).

### Rebuild _FEDORA_'s _resourceIndex_

Rebuild your _FEDORA_ _resourceIndex_ using the steps documented in [Step 17: On Remote Production - Re-Index Fedora & Solr](https://github.com/Born-Digital-US/ISLE/blob/ISLE-v.1.3.0-dev/docs/install/install-production-migrate.md#step-17-on-remote-production---re-index-fedora--solr).

  - Open a terminal in the _isle-fedora-ld_ container, `docker exec -it isle-fedora-ld bash`, and then run `cd utility_scripts/; ./rebuildFedora.sh`.

### Rebuild the _Solr_ Index

Once the previous rebuild process is complete, you should rebuild your _Solr_ search index using the remaining steps documented in [Step 17: On Remote Production - Re-Index Fedora & Solr](https://github.com/Born-Digital-US/ISLE/blob/ISLE-v.1.3.0-dev/docs/install/install-production-migrate.md#step-17-on-remote-production---re-index-fedora--solr).

  - Open a terminal in the _isle-fedora-ld_ container, `docker exec -it isle-fedora-ld bash` (or using the terminal opened in the previous step), and then run `cd utility_scripts/; ./updateSolrIndex.sh`.

This rebuilding process may take a few minutes.  Proceed to the check your work after some minutes have passed.

### Check Your Work

  - Visit the repository home page at https://isle.localdomain/islandora/object/islandora:root (demo) or https://yourprojectnamehere.localdomain/islandora/object/islandora:root (local).  You should see new collections on the first page of your display.  
  - Follow the install documentation for enabling the _Islandora Simple Search_ block and test _Solr_ by searching for a term like "Ley".

# Feedback is Welcome

This is very much a work-in-progress. If you have an opinion, or would like to suggest improvements, please share!

That's a wrap... until next time.  :smile:
