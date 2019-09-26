---
title: "DG-FEDORA: A Portable FEDORA Repository"
publishdate: 2019-09-16
lastmod: 2019-09-26T08:35:23-05:00
draft: false
tags:
  - DG-FEDORA
  - FEDORA
  - portable
  - docker-compose
  - override
  - COMPOSE_FILE
---

## Teaser

Late last night (don't ask how late it was) I discovered a really slick trick, aka "feature", of _docker-compose_.  Full disclosure: I love _docker-compose_ "overrides", a feature I found a couple of months ago. However, implementing overrides in a granular fashion, as I'd like, and within a _docker-compose_ hierarchy of environments like the [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) stack, can be difficult and counter-productive. I may have found a workable compromise last night.  If you're interested, please, read on...

## History

About a year ago I created a "portable" _FEDORA_ object repository "on a stick", a USB stick.  I call that "stick" _DG-FEDORA_, because it contains a number of sample objects gleaned from [Digital.Grinnell.edu](https://digital.grinnell.edu). Shortly after I created the "stick" I started using a _docker-compose.override.yml_ file (see [Adding and overriding configuration](https://docs.docker.com/compose/extends#adding-and-overriding-configuration) for details) to implement it in some of my _ISLE_ work.  But there were lots of other "customizations" that I also wanted to implement, and over time my _docker-compose.override.yml_ grew too large to be easily maintained...there was just too much stuff to squeeze into a file that was supposed to make life easier for me.

## ISLE Details

The _ISLE_ stack now uses a very simple and elegant _.env_ file -- four lines of environment variables, nothing more -- to ultimately control what the _docker-compose_ command does.  The last environment variable in the file is `COMPOSE_FILE`, and I found last evening that this variable can be used to specify "multiple" _.yml_ files to build a stack; and according the _docker-compose_ rules of order and overrides applys. Nirvana!

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

In the file above note that I've commented out the original definition of _COMPOSE_FILE_ and added my own definition which appends a second _.yml_ file reference to the original.  That 2nd file, _docker-compose.DG-FEDORA.yml_ is also provided on the _DG-FEDORA_ USB stick and it reads like this:

```
version: '3.7'

#### docker-compose up -d;
## Demo Environment - Used for exploring a full sandboxed ISLE system with an un-themed Islandora / Drupal site.
## Updated 2019-09 - Release 1.3.0-dev (@ 1.3.0-dev)

services:

  fedora:
    volumes:
      - /Volumes/DG-FEDORA/datastreamStore:/usr/local/fedora/data/datastreamStore
      - /Volumes/DG-FEDORA/objectStore:/usr/local/fedora/data/objectStore
```

Simple. It's just a repeat of the original _docker-compose.demo.yml_ file with only the necessary "overrides" included.

The _DG-FEDORA_ USB stick also includes a _README.md_ file and since you don't have a copy of the "stick", I'll share that with you here.

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

If your workstation is not a Mac, you will need to insert the USB stick and take appropriate steps to:

  - Mount the stick with read/write permissions as _/Volumes/DG-FEDORA_.
  - Share the _/Volumes_ or _/Volumes/DG-FEDORA_ directory in your _Docker_ settings/preferences.

## Modifying the _ISLE_ Environment

Navigate to your _ISLE_ project directory and execute the following operations:

  - Shut down _ISLE_ if it is running.  Example: `cd ~/pathto/ISLE; docker-compose down`.  These commands will do no harm if _ISLE_ is not currently running.
  - Copy necessary files from _DG-FEDORA_ to your project.  Example: `cd /Volumes/DG-FEDORA; cp -f .env docker-compose.DG-FEDORA.yml ~/pathto/ISLE/.`
  - Edit the new _ISLE_ project _.env_ file according to directions within the file.  Example: `nano ~/pathto/ISLE/.env`.  The objective is to select the appropriate "demo" or "local" environment as needed.
  - Navigate to your project directory and restart the stack.  Example: `cd ~/pathto/ISLE; docker-compose up -d`.
  - Wait until the stack has started, open your browser and visit your site at https://isle.localdomain (demo) or https://yourprojectnamehere.localdomain (local).

### Re-Index _FEDORA_

  - Re-index your _FEDORA_ _resourceIndex_ like so: `docker exec -it isle-apache-ld bash; cd utility_scripts; ./rebuildFedora.sh`.  See _./docs/install/install-production-migrate.md#reindex-fedora-ri--fedora-sql-database-23_ for additional details.

### Re-Index _Solr_

  - Re-index your _Solr_ instance from the same terminal session launched in the step above (or repeat `docker exec -it isle-apache-ld bash; cd utility_scripts;`) like so: `./updateSolrIndex.sh`.  See _./docs/install/install-production-migrate.md#reindex-fedora-ri--fedora-sql-database-23_ for additional details.

### Confirm Your Work

  - Visit the repository home page at https://isle.localdomain/islandora/object/islandora:root (demo) or https://yourprojectnamehere.localdomain/islandora/object/islandora:root (local).  You should see new collections on the first page of your display.  

# Feedback is Welcome

This is very much a work-in-progress. If you have an opinion, or would like to suggest improvements, please share!

That's a wrap... until next time.  :smile:
