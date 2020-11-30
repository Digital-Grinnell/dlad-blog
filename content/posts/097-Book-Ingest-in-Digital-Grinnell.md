---
title: Book Ingest in Digital.Grinnell
date: 2020-11-30T10:46:56-06:00
draft: false
emoji: true
tags:
    - Book
    - Ingest
    - Workflow
    - Digital.Grinnell
---

It's high-time this was posted to my blog, but the canonical copy of this document can be found in `smb://Storage/LIBRARY/mcfatem/DG-Book-Ingest-Workflow.md`.

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
