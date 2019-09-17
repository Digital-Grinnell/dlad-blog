---
title: "Digital.Grinnell's IMI Workflow"
publishdate: 2019-08-21
lastmod: 2019-09-16T22:11:35-05:00
draft: false
tags:
  - Digital.Grinnell
  - IMI
  - Islandora Multi-Importer
  - workflow
  - Google Sheets
---

Note: The abbreviation **IMI** is used frequently in this post to represent the [Islandora Multi-Importer](https://github.com/mnylc/islandora_multi_importer.git), a CSV-file-driven batch ingest tool used by numerous institutions in the Islandora community.

Also, while updating this post I found this gem... [Diagrams in Documentation (Markdown Guide)](https://medium.com/technical-writing-is-easy/diagrams-in-documentation-markdown-guide-4e78419e8d2f).

This post is an addition to the discussion in [post 028, Mounting //Storage for IMI Ingest in Digital.Grinnell ](https://static.grinnell.edu/blogs/McFateM/posts/028-mounting-storage-for-imi-ingest-in-digital-grinnell/) which was written largely to remind me how the //Storage mount works. :confused:  Unlike [post 028](https://static.grinnell.edu/blogs/McFateM/posts/028-mounting-storage-for-imi-ingest-in-digital-grinnell/), this post is meant for myself AND for others at Grinnell College who prepare digital objects for ingest via IMI. For those individuals... it's not necessary that you understand all of this, but it you choose to read-on, I hope you find this information helpful.

## IMI Process Overview
At its core, IMI is a CSV ingest batch tool, but at Grinnell we use it almost exclusively with _Google Sheets_ rather than actual `.csv` files. We do this largely so that each batch of objects we ingest, or modify, can have one (or more if necessary) **shared** data files... with emphasis on **shared**.  Also, since IMI supports direct use of _Google Sheets_ we are able to ingest objects without having to create and juggle multiple copies or revisions of `.csv` files which can be difficult to track and effectively manage.

Here at Grinnell we also have a single metadata template and metadata "form" so we don't have to maintain a different template or form for each content type or `cModel`.  Instead, we maintain a "master" Google Sheet or workbook that gets "cloned" for each set of objects that we ingest.  The "master", [Digital_Grinnell_MODS_Master](https://docs.google.com/spreadsheets/d/1G_pQgKJwtgBZYDAHcMC7dCTOnwexIYGHjarHPFKaAOg/edit#gid=1910204194) workbook is shared with a small group of Grinnell College staff who are responsible for it's use and maintenance.  

The workflow is perhaps best explained with a (rather complex and busy) diagram:

  ![IMI Workflow Diagram](https://digital.grinnell.edu/islandora/object/grinnell%3A26883/datastream/OBJ/view)

## Tabs or Worksheets
The "master" workbook features four "tabs" or worksheets:

| Tab Name | Description |
| --- | --- |
| Instructions | A set of instructions for cloning the master and using this workflow. |
| History | Presents a brief revision history of the workbook. |
| Twig | The latest revision of the [Twig](https://twig.symfony.com/) template used to transform cell contents into MODS field data. |
| MASTER | A small set of sample data.  When the "master" workbook is cloned, this tab/worksheet is where content editors put their data. |

It's worth noting here that **none of these tab names contain spaces**.  That's intentional, and a good practice to follow in general because, while spaces are allowed in names, they can cause problems when they appear in things like web addresses (URLs). Since our tab names eventually appear in URLs elsewhere in this workflow, I kindly ask that you omit spaces if/when you duplicate or create new tabs or worksheets.  

## MASTER
The `MASTER` tab, briefly introduced in the table above, deserves its own section...so here it is.  If you're a Grinnell College content editor or digital collection manager who submits objects for ingest into Digital.Grinnell, then this tab is for you.  It's where you put your object metadata, content controls, and content references. Note that the tab name, `MASTER`, is meaningful too, and it follows a new tab-naming convention documented in the `Instructions` tab and here [in this post](https://static.grinnell.edu/blogs/McFateM/posts/040-digital.grinnells-imi-workflow/) in August 2019 (revised in September 2019).  

It's also important to note that **the `MASTER` worksheet name should NEVER be changed!**  It is the "master" copy of the data and, as such, it should be copied to a new tab/worksheet when it is "ready" for ingest.  See the examples section below for more on this.

## Tab Names Convention
Tab or worksheet names, like `MASTER`, are meaningful and intended to convey the status of the tab's contents.  Content editors **should always work in the MASTER worksheet**, adding and modifying data as-necessary.  When content in `MASTER` is ready for review and ingest the editor should first make a copy of the `MASTER` worksheet, naming it `READY-[date]`, where `[date]` reflects the date the worksheet copy was made.

Note that in any tab, the contents of the `PID` column also helps to indicate the "state" of the worksheet and the data within.  Once an object has been ingested, that object's PID should appear in the corresponding row of the `PID` column, and the `PID` column should always be the left-most column in the worksheet.  So, the presence of a PID in this column indicates that the corresponding object already exists in the repository.     

### Examples
The following example tab names may help understand this convention.

    - `MASTER`  This is the default/initial data tab/worksheet name and it should never be changed. Differently named tabs should always be made from **copies of this tab!**  This name simply indicates that data entry is not complete and is not yet ready for ingest.
    - `Ready-26Aug2019` This example name indicates that the content editor has completed preparation of the information in `MASTER` and made a copy which is ready for review and ingest on the date indicated in the third term.  A tab name like this should be included in an appropriate Trello card update so that the DG administrator knows the content is ready for ingest.
    - `Ingested-28Aug2019` This example name indicates that on 28-Aug-2019 a DG administrator made a copy of a worksheet that was ready-for-ingest, reviewed, and successfully ingested the data creating a new set of objects.  
    - `Updated-28Aug2019` This example name is similar to the name above, but indicates that on 28-Aug-2019 a DG administrator ingested the content to update one or more existing DG objects.

And that's a ~~wrap~~ good place for a break!  More to come, after the break, of course.  :smile:
