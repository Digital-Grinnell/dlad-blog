---
title: PDF Ingest in Digital.Grinnell
date: 2019-07-24T16:56:44-07:00
draft: false
emoji: true
tags:
    - PDF
    - OCR
    - Digital.Grinnell
    - FULL_TEXT
---

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
