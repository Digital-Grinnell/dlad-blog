---
title: "Digital.Grinnell's IMI Workflow"
publishdate: 2019-08-21
lastmod: 2019-08-21T12:48:23-05:00
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
| ForExport | A small set of sample data.  When cloned, this tab/worksheet is where content editors put their data. |

It's worth noting here that **none of these tab names contain spaces**.  That's intentional, and a good practice to follow in general because, while spaces are allowed in names, they can cause problems when they appear in things like web addresses (URLs). Since our tab names eventually appear in URLs elsewhere in this workflow, I kindly ask that you omit spaces if/when you duplicate or create new tabs or worksheets.  

## ForExport
The `ForExport` tab, briefly introduced in the table above, deserves its own section...so here it is.  If you're a Grinnell College content editor or digital collection manager who submits objects for ingest into Digital.Grinnell, then this tab is for you.  It's where you put your object metadata, content controls, and content references.

And that's a ~~wrap~~ good place for a break!  More to come, after the break, of course.  :smile:
