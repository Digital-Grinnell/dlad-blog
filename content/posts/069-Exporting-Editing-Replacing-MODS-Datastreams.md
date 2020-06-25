---
title: "Exporting, Editing, & Replacing MODS Datastreams"
publishdate: 2020-03-17
draft: false
tags:
  - MODS
  - Export
  - Replace
  - Twig
  - Islandora Multi-Importer
  - islandora_datastream_export
  - islandora_datastream_replace
  - islandora_mods_via_twig
  - islandora_mods_post_processing
---

> Attention: On 21-May-2020 an optional, but recommended, sixth step was added to this workflow in the form of a new _Drush_ command: _islandora\_mods_post\_processing_, an addition to my previous work in [islandora_mods_via_twig](https://github.com/DigitalGrinnell/islandora_mods_via_twig). See my new post, [Islandora MODS Post Processing](/en/posts/075-islandora-mods-post-processing) for complete details.

The transition to distance learning, social distancing, and more remote work at _Grinnell College_ in the wake of the _COVID-19_ pandemic may afford _GC Libraries_ an opportunity to do some overdue and necessary metadata cleaning in [Digital.Grinnell](https://digital.grinnell.edu).

# A 5-Step Workflow

This turned out to be a much more difficult undertaking than I imagined, but as of mid-April, 2020, I have a 5-step workflow that actually works.  This post will introduce all five steps, but only provides details for Step 3, [Editing a MODS TSV File](#editing-a-modstsv-file), the portion that metadata editors need to be most aware of.  All technical details, as well as steps 1, 2, 4 and 5, will be addressed in [Exporting, Editing, & Replacing MODS Datastreams: Technical Details](https://dlad.summittdweller.com/en/posts/070-exporting-editing-replacing-mods-datastreams-technical-details/).

Attention: This document uses a shorthand `./` in place of the frequently referenced `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/` directory.  For example, `./social-justice` is equivalent to the _Social Justice_ collection sub-directory at `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/social-justice`.

The five steps are:

  1. Export of all `grinnell:*` _MODS_ datastreams using `drush islandora_datastream_export`.  This step, last performed on April 14, 2020, was responsible for creating all of the `grinnell_<PID>_MODS.xml` exports found in `./<collection-PID>`.

  2. Execute my _Map-MODS-to-MASTER_ _Python 3_ script on iMac _MA8660_ to create a `mods.tsv` file for each collection, along with associated `grinnell_<PID>_MODS.log` and `grinnell_<PID>_MODS.remainder` files for each object. The resultant `./<collection-PID>/mods.tsv` files are tab-seperated-value (.tsv) files, and they are **key** to this process.

  3. Edit the MODS .tsv files.  Refer to the dedicated section below for details and guidance.

  4. Use `drush islandora_mods_via_twig` in each ready-for-update collection to generate new .xml MODS datastream files. For a specified collection, this command will find and read the `./<collection-PID>/mods-imvt.tsv` and create one `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file for each object.

  5. Execute the `drush islandora_datastream_replace` command once for each collection.  This command will process each `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file and replace the corresponding object's MODS datastream with the contents of the .xml file.  The `digital_grinnell` branch version of the `islandora_datastream_replace` command also performs an implicit update of the object's "Title", a transform of the new MODS to DC (_Dublin Core_), and a re-indexing of the new metadata in _Solr_.

##  Editing a mods.tsv File

Creating or editing metadata can be a monumental task, and doing it effectively can demand a wealth of knowledge and experience working with metadata standards and practices. This step in our workflow is easily the most labor-intensive. The goal of this project is largely to present metadata editors with a form, in this case the `mods.tsv` or tab-seperated-value file, to make consistent editing of metadata possible.  In addition to the `mods.tsv` file the workflow will rely on guidance and conventions that are documented in the _Metadata Clean-up_ tab of the [Digital_Grinnell_MODS_Master](https://docs.google.com/spreadsheets/d/1G_pQgKJwtgBZYDAHcMC7dCTOnwexIYGHjarHPFKaAOg/edit#gid=791993009) worksheet.

A metadata editor should focus on only one collection at a time. The suggested practice for working through one collection is as follows:

  1. Find the collection's `mods.tsv` file using the collection's persistent identifier, or PID. For example, the target .tsv file for _Digital.Grinnell_'s "Social Justice" collection, with a PID equal to `social-justice`, will be found in `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/social-justice/mods.tsv`.

  2. Copy the `mods.tsv` file, preferably to your local workstation, and optionally give it a new name, like `social-justice-mods.tsv`.

  3. Open the _Metadata Clean-up_ tab of the [Digital_Grinnell_MODS_Master](https://docs.google.com/spreadsheets/d/1G_pQgKJwtgBZYDAHcMC7dCTOnwexIYGHjarHPFKaAOg/edit#gid=791993009) worksheet in a browser so that you have guidance available at all times.

    - Note that if you find yourself repeating very cumbersome changes while you edit, please consider taking notes in the _Metadata Clean-up_ tab and email [digital@grinnell.edu](mailto://digital.grinnell.edu) with any questions or concerns you may have about the process or the guidance.

  4. Open your copy of the .tsv file in _Excel_, _Numbers_, or any .csv or .tsv capable worksheet editor.

  5. Edit the data.  We suggest doing so on a column-by-column, one column at at time where possible. You are likely to find that the values in a single column may be similar from row-to-row, as it should be.  You may also find it possible to do large-scale find/replace in a column.  For example, many of our records may list a corporate (organization) name as a "~ Supporting host", but the proper form of that term is "~ supporting host", in all lowercase, and you might save time by doing a find/replace operation to make all such changes.

  6. When you are done editing, be sure to save your work AND export the data back into a new .tsv file specifically named `mods-imvt.tsv`.  Note that "-imvt" stands for `islandora_mods_via_twig`, the command that will subsequently used in the next step of our workflow.

  7. Save a copy of your `mods-imvt.tsv` file in `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/<collection-PID/mods-imvt.tsv`.

  8. Email [digital@grinnell.edu](mailto://digital.grinnell.edu) to let us know that you have a collection ready for processing, and be sure to provide the _collection-PID_ in your email.

  9. Expect a follow-up email from [digital@grinnell.edu](mailto://digital.grinnell.edu) in one or two days.  After the metadata has been processed we may ask you to review some of the changes to make sure they appear correctly in [Digital.Grinnell](https://digital.grinnell.edu).

And that's a wrap.  Until next time, thank you for your attention to our metadata!  :smile:
