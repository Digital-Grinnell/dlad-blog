---
title: "Creating a CollectionBuilder-CSV Instance from Our Migration Collection"
publishdate: 2022-11-28
draft: false
tags:
  - migration
  - collection
  - Digital.Grinnell
  - CollectionBuilder-CSV
content_updated:   
---

This post is essentially a [CollectionBuilder-CSV](https://github.com/CollectionBuilder/collectionbuilder-csv) follow-up to [Creating a Migration Collection](/posts/129-creating-a-migration-collection/), intended to document the path I've taken and the decisions I made when creating a first cut of [Digital.Grinnell](https://digital.grinnell.edu) content using the aformentioned _CollectionBuilder-CSV_.  

## CB-CSV_DG-01

With few notable exceptions, everything mentioned below will be visible in a new _public_ _GitHub_ repo at [Digital-Grinnell/CB-CSV_DG-01](https://github.com/Digital-Grinnell/CB-CSV_DG-01).

## Corresponding Google Sheet

One of the exceptions: the project's metadata CSV in the _ready-for-CB_ tab at [https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/edit#gid=586145055](https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/edit#gid=586145055).

Other worksheets/tabs in [the Google Sheet](https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc) contain:

  - _Sheet 1_ = the initial imported demo data from the [CollectionBuilder-CSV Metadata Template](https://docs.google.com/spreadsheets/d/1nN_k4JQB4LJraIzns7WcM3OXK-xxGMQhW1shMssflNM/copy?usp=sharing)

  - _mods.csv_ = original [MODS metadata .csv](https://migrationtestcollection.blob.core.windows.net/migration-test-metadata/mods.csv) as exported from _Digital.Grinnell_ and described in [Creating a Migration Collection](/posts/129-creating-a-migration-collection/). 

## Creating the Development Environment

The steps required to create a _CollectionBuilder-CSV_ instance are well-documented in the [CollectionBuilder Docs](https://collectionbuilder.github.io/cb-docs/).  I selected the [CollectionBuilder-CSV](https://github.com/CollectionBuilder/collectionbuilder-csv) version of _CB_, and because my development enviroment will be on a Mac, I consistenly selected Mac-specific options throughout the process, including the use of [Homebrew](https://brew.sh/) whenever it was an option.

An ordered list of documentation sections I followed includes:

  - [CollectionBuilder Docs](https://collectionbuilder.github.io/cb-docs/#collectionbuilder-docs)
  - [Templates](https://collectionbuilder.github.io/cb-docs/#templates)
    - [CollectionBuilder-CSV](https://github.com/CollectionBuilder/collectionbuilder-csv)
  - [GitHub](https://collectionbuilder.github.io/cb-docs/docs/software/github/#github)
    - I skipped this section because I am already familiar with _GitHub_ use.
  - [Git Setup](https://collectionbuilder.github.io/cb-docs/docs/software/git/#git-setup)
    - I skipped this section because _Git_ is already properly configured on my Mac.
  - [Get a Text Editor](https://collectionbuilder.github.io/cb-docs/docs/software/texteditor/#get-a-text-editor) 
    - I skipped this section because _Visual Studio Code_ is already installed and includes all of the extensions mentioned in the document.
  - [Install Ruby](https://collectionbuilder.github.io/cb-docs/docs/software/ruby/#install-ruby)   
    - [Ruby on Mac](https://collectionbuilder.github.io/cb-docs/docs/software/ruby_mac/#ruby-on-mac) - I used all of the recommended commands with _Ruby_ version `3.1.3`.
  - [Install Jekyll](https://collectionbuilder.github.io/cb-docs/docs/software/jekyll/#install-jekyll)    
  - [Optional Software](https://collectionbuilder.github.io/cb-docs/docs/software/optional/#optional-software) 
    - [Install on Mac](https://collectionbuilder.github.io/cb-docs/docs/software/optional/#install-on-mac)
  - [Set Up Project Repository](https://collectionbuilder.github.io/cb-docs/docs/repository/#set-up-project-repository) 
    - I worked through all of the sub-sections here to produce the [CB-CSV_DG-01 repository](https://github.com/Digital-Grinnell/CB-CSV_DG-01).  Most of the work was done using _VSCode_ and it included initial commits and push with project-specific information added to the _README.md_ file.

## Adding Metadata

The next task here involves properly populating the project's metadata CSV in the _ready-for-CB_ tab at [https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/edit#gid=586145055](https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/edit#gid=586145055).  At the time of this writing that tab is just a raw copy of our original [MODS metadata .csv](https://migrationtestcollection.blob.core.windows.net/migration-test-metadata/mods.csv) as exported from _Digital.Grinnell_ and described in [Creating a Migration Collection](/posts/129-creating-a-migration-collection/).  Essentially the _ready-for-CB_ tab needs to contain the data that it currently holds, but transformed into a structure matching that of _Sheet 1_, the initial imported demo data from the [CollectionBuilder-CSV Metadata Template](https://docs.google.com/spreadsheets/d/1nN_k4JQB4LJraIzns7WcM3OXK-xxGMQhW1shMssflNM/copy?usp=sharing).

### Using _Open Refine_?

My first thought was to use [Open Refine](https://openrefine.org/) to manipulate the CSV structure and data, and I do have this tool installed on all of my Macs in case it is needed.  However, I'm not a huge fan of _Open Refine_, in part because it is, in my opinion, Java-based and therefore bloated and cumbersome.  My bigger concern is that capturing the transform "process" isn't a natural thing in _Open Refine_, and I expect to repeat this same process many times over as we work through each collection of _Digital.Grinnell_ objects.  Also, over time I expect to refine and improve the transformation process so I'd like to have the logic captured in a repeatable script rather than a GUI-driven tool.

### Python?

Of course!  My intent is to create a Python script capable of reading and writing _Google Sheet_ data and structures so that I can create, manage, improve, and above all, _repeat_ my transforms.  _CollectionBuilder_ is Jekyll-based so it does not involve [Hugo](https://gohugo.io), but the Python scripts in my [Hugo Front Matter Tools](https://github.com/Digital-Grinnell/hugo-front-matter-tools) should still provide a good starting point for crafting scripts to help with this.  

---

I'm sure there will be more here soon, but for now... that's a wrap.
