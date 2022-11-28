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

---

I'm sure there will be more here soon, but for now... that's a wrap.
