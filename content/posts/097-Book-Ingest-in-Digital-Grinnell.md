---
title: Book Ingest in Digital.Grinnell
date: 2021-02-05T16:12:55-06:00
publishdate: 2020-11-30
draft: false
tags:
    - Book
    - Ingest
    - Workflow
    - Digital.Grinnell
emoji: true
---

It's high-time this was posted to my blog, but the canonical copy of this document can be found in `smb://Storage/LIBRARY/mcfatem/DG-Book-Ingest-Workflow.md`.

## Valid Book Datastream Structure

I want to begin here by showing what I see as a "proper" working book datastream structure in _Digital.Grinnell_.  The image below is a screen grab of the datastreams from the [Grinnell College Yearbook 1961](https://digital.grinnell.edu/islandora/object/grinnell:23749), _DG_ object `grinnell:23749`:

{{% figure title="Valid Book Datastreams" src="/images/post-097/grinnell-23749-datastreams.png" %}}


## Creating a Valid Book Structure

One of the biggest problems I have encountered with ingest of books is uploading very large multi-page PDFs.  Fortunately, I've crafted the following procedure for working around that limitation.

### Procedure

On the host workstation (`DGDocker1` in the case of *Digital.Grinnell*) open a command terminal and...

  - Mount the *.pdf* file(s) representing the book(s) into the host's `/mnt/storage` folder using something like:
    `sudo mount -t cifs -o username=mcfatem //storage.grinnell.edu/MEDIADB/DGIngest /mnt/storage`
  - Find or create an empty *book.pdf* file on the host using something like:
    `touch ~/book.pdf`

Open a browser from your local workstation and...

  - Login to https://digital.grinnell.edu as an admin (`Library Staff` for example).
  - Navigate your browser to the book's intended parent collection object in DG.
  - Append `/manage` to the end of the parent object address and return.
  - Click the link to `Add an object to this Collection`.
  - Choose the `Islandora Internet Archive Book Content Model` content type.
  - Enter necessary MODS metadata and submit the form.
  - In the *PDF Upload* field navigate to the `book.pdf` file created in Step 2 and upload it.  *The file should now appear in the `isle-apache-dg` container as `/tmp/book.pdf`*

Return to the open command terminal and...

  - Copy the book's actual *.pdf* file into the `isle-apache-dg` container like so: `docker cp /mnt/storage/name-of-book.pdf isle-apache-dg:/tmp/book.pdf`

When the `docker cp` command is finished return to your browser and...

  - Complete the process by clicking `Submit` at the end of the form.

Now sit back and watch the magic.

## Incomplete Book... Orphaned pages

Unfortunately, I also have some "broken" books that have a slew of ingested book pages all pointing to the wrong parent.  One of my entries in _Trello_, for the _1962 Cyclone_ relates to one such case:

```
grinnell:25521 - 25862 [Pages but NO Book!]  Empty book object is grinnell:23747
```

The problem in the case of `grinnell:23747` is twofold:

  1. That book object has no PDF - This condition can be corrected simply by uploading the appropriate PDF file as a new `PDF` datastream in the book/parent object.
  2. The pages/children of that book/parent all incorrectly reference `grinnell:25520` as their book/parent - Fortunately, there's an easy fix for this too, see below.

Since `grinnell:25520` never ingested properly all of the pages are effectively "orphans". In the case of the _1962 Cyclone_ I used this command running inside the `isle-apache-dg` container:

```
root@28eb71ea69bf:/var/www/html/sites/default# drush -u 1 iduF grinnell:25521-25862 ChangeText --find="grinnell:25520" --replace="grinnell:23747" --dsid=RELS-EXT
```

<!--
A set of 21 PDF objects were ingested into _Digital.Grinnell's_ _Faculty Scholarship_ collection using [IMI](https://github.com/DigitalGrinnell/islandora_multi_importer) on 22-July-2019; unfortunately none of these PDFs contained OCR (optical character recognition) or "text recognition" data, so none of them generated a valid FULL\_TEXT datastream.  FULL\_TEXT datastreams are required to make PDF, and similar text content, searchable and discoverable in _Digital.Grinnell_.

In order to confirm that the lack of OCR was in fact the problem, I ran a little test on https://digital.grinnell.edu/islandora/object/grinnell:26702, one of the 21 objects.  

In my test I...

  - signed in to _Digital.Grinnell_ as an admin,
  - opened the object (see address above) in my browser,
  - clicked `Manage` to see all the object details,
  - clicked `Datastreams` to see the list of all the object's datastreams,
  - clicked the `download` link corresponding to the `OBJ` datastream - this allowed me to download a copy of the PDF file to my workstation.
  - Once the PDF was downloaded I opened it on my workstation in _Adobe Acrobat Pro_,
  - clicked `Tools` and `Text Recognition`,
  - then I chose\* `In This File`.
  - After a few minutes I had a new PDF with OCR'd and searchable text.
  - I saved that new PDF on my workstation,
  - went back into the `Manage` tab in my browser,
  - clicked `replace` in the `OBJ` datastream line,
  - then uploaded the new PDF file to _Digital.Grinnell_.

Once the upload was complete the system automatically generated new derivatives for the object which now has a valid FULL\_TEXT datastream, so this should make the content searchable and discoverable.

\*Note that if I had multiple PDFs to process I believe I could have selected the `In Multiple Files` option to save some time and OCR several PDFs in one operation.

The lesson-to-be-learned here is to... `always run "Text Recognition" on a PDF BEFORE it is ingested into Digital.Grinnell.`  But, if you forget, this procedure in the hands of any _Digital.Grinnell_ admin, can save the day!  :smile:

And that's a wrap.  Until next time...
