---
title: "Digital.Grinnell's IMI Workflow"
publishdate: 2019-08-21
lastmod: 2019-08-28T07:31:51-05:00
draft: false
tags:
  - Digital.Grinnell
  - IMI
  - Islandora Multi-Importer
  - workflow
  - Google Sheets
---

Note: The abbreviation **IMI** is used frequently in this post to represent the [Islandora Multi-Importer](https://github.com/mnylc/islandora_multi_importer.git), a CSV-file-driven batch ingest tool used by numerous institutions in the Islandora community.

This post is an addition to the discussion in [post 028, Mounting //Storage for IMI Ingest in Digital.Grinnell ](https://static.grinnell.edu/blogs/McFateM/posts/028-mounting-storage-for-imi-ingest-in-digital-grinnell/) which was written largely to remind me how the //Storage mount works. :confused:  Unlike [post 028](https://static.grinnell.edu/blogs/McFateM/posts/028-mounting-storage-for-imi-ingest-in-digital-grinnell/), this post is meant for myself AND for others at Grinnell College who prepare digital objects for ingest via IMI. For those individuals... it's not necessary that you understand all of this, but it you choose to read-on, I hope you find this information helpful.

## IMI Process Overview
At its core, IMI is a CSV ingest batch tool, but at Grinnell we use it almost exclusively with `Google Sheets` rather than actual `.csv` files. We do this largely so that each batch of objects we ingest, or modify, can have one (or more if necessary) **shared** data files... with emphasis on **shared**.  Also, since IMI supports direct use of `Google Sheets` we are able to ingest objects without having to create and juggle multiple copies or revisions of `.csv` files which can be difficult to track and effectively manage.

Here at Grinnell we also have a single metadata template and metadata "form" so we don't have to maintain a different template or form for each content type or `cModel`.  Instead, we maintain a `master` Google Sheet that gets "cloned" for each set of objects that we ingest.  The `master`, or   [Digital_Grinnell_MODS_Master](https://docs.google.com/spreadsheets/d/1G_pQgKJwtgBZYDAHcMC7dCTOnwexIYGHjarHPFKaAOg/edit#gid=1910204194), is shared with a small group of Grinnell College staff who are responsible for it's use and maintenance.  

The `master` features four "tabs" or worksheets:

| Tab Name | Description |
| --- | --- |
| Instructions | A set of instructions for cloning the master and using this workflow. |
| History | Presents a brief revision history of the `master`. |
| Twig | The latest revision of the [Twig](https://twig.symfony.com/) template used to transform cell contents into MODS field data. |
| Pending-Master | A small set of sample data.  When the `master` is cloned, this tab/worksheet is where content editors put their data. |

It's worth noting here that **none of these tab names contain spaces**.  That's intentional, and a good practice to follow in general because, while spaces are allowed in names, they can cause problems when they appear in things like web addresses (URLs). Since our tab names eventually appear in URLs elsewhere in this workflow, I kindly ask that you omit spaces if/when you duplicate or create new tabs or worksheets.  

## Pending-Master
The `Pending-Master` tab, briefly introduced in the table above, deserves its own section...so here it is.  If you're a Grinnell College content editor or digital collection manager who submits objects for ingest into Digital.Grinnell, then this tab is for you.  It's where you put your object metadata, content controls, and content references. Note that the tab name, `Pending-Master`, is meaningful too, and it follows a new tab-naming convention documented in the `Instructions` tab and here [in this post](https://static.grinnell.edu/blogs/McFateM/posts/040-digital.grinnells-imi-workflow/) in August 2019.  

It's also important to note that **the name `Pending-Master` should NEVER be changed!**  It is the "master" copy of the data and, as such, it should be copied to a new tab before changing its state or status.  See the examples section below for more on this.

## Tab Names Convention
The tab name, `Pending-Master`, mentioned above, is meaningful and intended to convey the status of the tab's contents.  The first term, "pending" indicates that this data is being constructed and has not yet been ingested  into the Digital.Grinnell repository, nor is it ready for ingest.  The second term, "master", indicates that the tab's contents, both metadata and object content, are being being prepared by the content author or editor.  This name follows an established two-part or three-part naming convention of the form `State-Type-Date`, where the `-Date` portion is optional.  The following bullets explain all the tab name possibilities.

  - The first word in the tab name indicates the `state` in our process.  It may be either `Pending`, `Ready`, `Ingested`, or `Updated`.
    - `Pending` - Means this data is pending ingest or update but is not yet ready for the repository... it is work-in-progress.
    - `Ready` - Means this data is ready for ingest or update into Digital.Grinnell.  This state may be followed by an optional `-Date` to indicate the date on which the contents became ready for ingest.
    - `Ingested` - Means this data has already been ingested into Digital.Grinnell.  This state should be followed by a `-Date` value to indicate the date on which the contents were ingested.   
    - `Updated` - Means this data has already been ingested AND subsequently updated or altered in Digital.Grinnell.  This state should be followed by a `-Date` value to indicate the date on which the contents were last updated.   
  - The second word in the tab name indicates the "type" of content within.  It may be either `Master`, `Mixed`, `Metadata`, or `Content`.  
    - `Master` - Is the initial term in this position and it indicates that this is "original" data, not a copy.
    - `Mixed` - This term appears only in copies of `Pending-Master` and it indicates that the data within is a mix of metadata and content.  
    - `Metadata` - This term appears only in copies of `Pending-Master` and it indicates that the data within is intended only to populate objects' metadata, but not content.  In a tab with this "type" the content columns like OBJ or TN may be blank or are expected to be ignored.
    - `Content` - This term appears only in copies of `Pending-Master` and it indicates that the data within is intended only to populate objects' content, but not metadata. In a tab with this "type" the content columns like OBJ and TN will be significant, but the metadata columns may be blank or are expected to be ignored.
  - The optional third term in the tab name indicates the `date` on which either of the first two terms were modified.

Note that the contents of the `PID` column also helps to indicate the `state` of a tab.  Once an object has been ingested, that object's PID should appear in the corresponding row of the `PID` column, and the `PID` column should always be the left-most column in the worksheet.  So, the presence of a PID in this column indicates that the corresponding object already exists in the repository.     

### Examples
The following example tab names may help understand this convention.

    - `Pending-Master`  This is the default/initial tab name and it should never be changed. Differently named tabs should always be made from **copies of this tab!**  This name simply indicates that data entry is not complete and is not yet ready for ingest.
    - `Pending-Metadata` This example name suggests that a content editor is still preparing the data in this tab for metadata-only ingest into Digital.Grinnell, and that the metadata is not yet ready for ingest.
    - `Ready-Master-28Aug2019` This example name indicates that the content editor has completed preparation of the information in this tab and made it ready for review and ingest on the date indicated in the third term.  A tab name like this should be included in an appropriate Trello card update so that the DG administrator knows the content is ready for ingest.
    - `Ingested-Master-28Aug2019` This example name indicates that on or after 28-Aug-2019 a DG administrator made a copy of `Ready-Master-28Aug2019`, reviewed, and successfully ingested the data creating a new set of objects.  
    - `Updated-Master-28Aug2019` This example name indicates that on or after 28-Aug-2019 a DG administrator made a copy of `Ready-Master-28Aug2019`, reviewed, and successfully ingested the data to update a set of existing objects.   

And that's a ~~wrap~~ good place for a break!  More to come, after the break, of course.  :smile:
