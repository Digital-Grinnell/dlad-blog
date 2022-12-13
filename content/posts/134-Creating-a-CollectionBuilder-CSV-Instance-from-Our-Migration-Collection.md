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

One of the exceptions: the project's metadata CSV in a time-stamped tab at [https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/](https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/).

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

The next task here involves properly populating the project's metadata CSV in the _ready-for-CB_ tab at [https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/](https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/).  At the time of this writing that tab is just a raw copy of our original [MODS metadata .csv](https://migrationtestcollection.blob.core.windows.net/migration-test-metadata/mods.csv) as exported from _Digital.Grinnell_ and described in [Creating a Migration Collection](/posts/129-creating-a-migration-collection/).  Essentially the _ready-for-CB_ tab needs to contain the data that it currently holds, but transformed into a structure matching that of _Sheet 1_, the initial imported demo data from the [CollectionBuilder-CSV Metadata Template](https://docs.google.com/spreadsheets/d/1nN_k4JQB4LJraIzns7WcM3OXK-xxGMQhW1shMssflNM/copy?usp=sharing).

### Using _Open Refine_?

My first thought was to use [Open Refine](https://openrefine.org/) to manipulate the CSV structure and data, and I do have this tool installed on all of my Macs in case it is needed.  However, I'm not a huge fan of _Open Refine_, in part because it is, in my opinion, Java-based and therefore bloated and cumbersome.  My bigger concern is that capturing the transform "process" isn't a natural thing in _Open Refine_, and I expect to repeat this same process many times over as we work through each collection of _Digital.Grinnell_ objects.  Also, over time I expect to refine and improve the transformation process so I'd like to have the logic captured in a repeatable script rather than a GUI-driven tool.

### Python?

Of course!  My intent is to create a Python script capable of reading and writing _Google Sheet_ data and structures so that I can create, manage, improve, and above all, _repeat_ my transforms.  _CollectionBuilder_ is Jekyll-based so it does not involve [Hugo](https://gohugo.io), but the Python scripts in my [Hugo Front Matter Tools](https://github.com/Digital-Grinnell/hugo-front-matter-tools) should still provide a good starting point for crafting scripts to help with this.  

**Update**: I'm going to pivot the effort described above and take a little different approach.  My first efforts in Python produced [transform-mods-csv-to-ready-for-CB](https://github.com/Digital-Grinnell/transform-mods-csv-to-ready-for-CB) plus a new Google Sheet at https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/.  The head of the `README.md` file describes where I "was" going with the effort:

{{% original %}}
This script, evolved from rootstalk-google-sheet-to-front-matter.py from my https://github.com/Digital-Grinnell/hugo-front-matter-tools project, is designed to read all exported MODS records from the `mods.csv` tab of https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/ and transform that data into a new ready-for-CB tab of the same Google Sheet, but using the column heading/structure of the CollectionBuilder demo Sheet1 tab.
{{% /original %}}

#### The Pivot

Essentially, rather than making the `ready-for-CB` tab conform to _CollectionBuilder_'s out-of-the-box metatdata schema, I'm going to make my initial _CollectionBuilder_ configuration conform to the schema reflected in the `mods.csv` tab of the aforementioned Google Sheet.  Wish me luck.

#### Not Going to Pivot After All

Ok, I changed my mind, again.  I started re-strucutring my exported MODS data into a brand new _CollectionBuilder_ configuration as suggested in the "Pivot", and realized that my initial approach of scripting the transformation of MODS to initially match _CB_'s out-of-the-box "demo" schema was a better idea after all.  So, I did just that, and this morning I have a working script, [transform-mods-csv-to-ready-for-CB](https://github.com/Digital-Grinnell/transform-mods-csv-to-ready-for-CB/blob/main/transform-mods-csv-to-ready-for-CB.py) and a transformed set of data now in the aformentioned Google Sheet at https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/.   

Time now to reconfig [CB-CSV_DG-01](https://github.com/Digital-Grinnell/CB-CSV_DG-01) and point it to the new `.csv` data.

## Metadata Changes

With our metadata stored in the latest time-stamped tab at https://docs.google.com/spreadsheets/d/1ic4PxHDbuzDrmf4YtauhC4vEQJxt3QSH8bYfLBCM3Gc/, I exported the Google Sheet to a `transformed.csv` file and dropped that file into this repo's `_data` directory as prescribed in the `README.md` documentation.  

## Config Changes

After exporting and depoisting the `transformed.csv` I incrementally made changes to the project's `_config.yml` file, and others as described below, regenerating a new _CB_ instance with each change to the config.

### Change Collection Settings: metadata

I changed the last line of `_config.yml` from...

```yaml
##########
# COLLECTION SETTINGS
#
# Set the metadata for your collection (the name of the CSV file in your _data directory that describes the objects in your collection) 
# Use the filename of your CSV **without** the ".csv" extension! E.g. _data/demo-metadata.csv --> "demo-metadata"
metadata: demo-metadata
```
...to...

```yaml
metadata: transformed
```

The result wasn't great, it included a host of "Notice" messages like the one shown below.

```sh
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/CB-CSV_DG-01 ‹main●› 
╰─$ bundle exec jekyll s
Configuration file: /Users/mcfatem/GitHub/CB-CSV_DG-01/_config.yml
            Source: /Users/mcfatem/GitHub/CB-CSV_DG-01
       Destination: /Users/mcfatem/GitHub/CB-CSV_DG-01/_site
 Incremental build: disabled. Enable with --incremental
      Generating... 
Error cb_helpers: Item for featured image with objectid 'demo_001' not found in configured metadata 'transformed'. Please check 'featured-image' in '_data/theme.yml'
Notice cb_page_gen: record '0' in 'transformed', 'grinnell:10023' is being sanitized to create a valid filename. This may cause issues with links generated on other pages. Please check the naming convention used in 'objectid' field.
...
```

Clearly, the `objectid` values I'm writing to the metadata `.csv` file need to be improved.  I'm making that change in the [transform-mods-csv-to-ready-for-CB](https://github.com/Digital-Grinnell/transform-mods-csv-to-ready-for-CB/blob/main/transform-mods-csv-to-ready-for-CB.py) script now.

#### After Sanitizing the `objectid` Field

After the change I got this output...

```sh
 Auto-regeneration: enabled for '/Users/mcfatem/GitHub/CB-CSV_DG-01'
    Server address: http://127.0.0.1:4000
  Server running... press ctrl-c to stop.
[2022-12-13 12:52:26] ERROR `/items/grinnell:23517.html' not found.
      Regenerating: 1 file(s) changed at 2022-12-13 13:01:21
                    _data/transformed.csv
Error cb_helpers: Item for featured image with objectid 'demo_001' not found in configured metadata 'transformed'. Please check 'featured-image' in '_data/theme.yml'
                    ...done in 0.492276 seconds.
```
...and the output looks better, but there's still an issue with 'demo_001' as a "featured item".  

## Changing the Home Page (Featured Image) in `theme.yml`

In _CB_ the `theme.yml` file is home to settings that "...help configure details of individual pages in the website".  I made the following changes to that file.  

Changing the last line from this "HOME PAGE" snippet from...

```yaml
##########
# HOME PAGE
#
# featured image is used in home page banner and in meta markup to represent the collection
# use either an objectid (from an item in this collect), a relative location of an image in this repo, or a full url to an image elsewhere
featured-image: demo_001
```
...to...

```yaml
featured-image: grinnell_23345
```

That change automatically regenerated my local site, but this time with the following error...

```sh
      Regenerating: 1 file(s) changed at 2022-12-13 13:14:09
                    _data/theme.yml
Error cb_helpers: Item for featured image with objectid 'grinnell_23345' does not have an image url in metadata. Please check 'featured-image' in '_data/theme.yml' and choose an item that has 'object_location' or 'image_small'
                    ...done in 0.499817 seconds.
```                    

This is actually indicative of a MUCH bigger issue...  Apparently the `object_location` values that I'm providing -- as links to the original objects in _Digital.Grinnell_ -- are not acceptable.  They need to have something like `/datastream/OBJ/view` appened to them in order to work correctly.

## Pointing _CB_ to _Digital.Grinnell_ Storage

It's now time to clone the `filename` function for a new `obj` function in [transform-mods-csv-to-ready-for-CB](https://github.com/Digital-Grinnell/transform-mods-csv-to-ready-for-CB/blob/main/transform-mods-csv-to-ready-for-CB.py) so that it references exported "OBJ" objects with URLs from _DG_ like https://digital.grinnell.edu/islandora/object/grinnell:23517/datastream/OBJ/view.  I'm also going to add a `thumbnail` function to populate the `image_thumb` AND `image_small` metadata columns.

With those columns completed the site local site at http://127.0.0.1:4000/ is working, but it's not pretty.  One lesson learned... the `featured-image` listed in `_data/theme.yml` MUST have a valid `image_small` element in order to display correctly.  The error message shown above will be present until `image_small` is resolved. 

## Next, Pushing Local Changes to _Azure_

At this time I'm going to follow the guidance in [Tutorial: Publish a Jekyll site to Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/publish-jekyll) to create a shared/visible instance of the new _CB_ site.

---

I'm sure there will be more here soon, but for now... that's a wrap.
