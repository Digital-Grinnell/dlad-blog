---
title: "Here There Be WARCs"
publishdate: 2020-06-17
draft: false
tags:
  - WARC
  - wget
  - web archive
  - islandora_solution_pack_web_archive
  - islandora_datastream_replace
  - PDF
superseded_by: posts/126-Creating-WARC-from-a-Wordpress-Clone  
---

The term `WARC`, an abbreviation of [Web ARChive](https://en.wikipedia.org/wiki/Web_ARChive), always reminds me of things like hobbits, elves, dark lords, and orcs, of course.  But this post has nothing to do with those things so I need to clear my head and press on.

A WARC is essentially a file format used to capture the content and organization of a web site. Recently, I was asked to add a pair of WARCs to _Digital.Grinnell_. Doing so proved to be quite an adventure, but I am pleased to report that we now have these two objects to show for it:

  - [The Global Mongol Century](https://digital.grinnell.edu/islandora/object/grinnell:27856), and
  - [World Music Instruments](https://digital.grinnell.edu/islandora/object/grinnell:27858).

## WARC Ingest - Failures and Success

What follows is a table of the steps, both failed and successful, taken to ingest the two new _Digital.Grinnell_ objects, along with notes about each step in the process.

| Ingest Step | Outcome | Notes |
| ---         | ---     | ---   |
| 1. .warc File Creation | **Success** | Rebecca Ciota used a `wget` command to create a .warc archive file and a .cdx "index" of each site from existing, "live" web content.  That command took this form: `wget --warc-file=<FILENAME> --recursive --level=5 --warc-cdx --page-requisites --html-extension --convert-links --execute robots=off --directory-prefix=. -x /solr-search --wait=10 --random-wait <WEBSITE-URL> `  |
| 2. .gz Compression | **Success** | Rebecca compressed each .warc and .cdx file pair into a compressed .gz archive to package the contents for subsequent processing. |
| 3. MODS Metadata Prep | **Success** | Rebecca added two rows of control data and MODS metadata to Google Sheet https://docs.google.com/spreadsheets/d/1X3rs7UhIdS6SumTwFUvRR0F6-OnGEIF5xnGzcLrFqNY to prep for [IMI](https://github.com/mnylc/islandora_multi_importer) ingest. |
| 4. .gz Files Added to //Storage | **Success** | The two .gz files generated in a previous step were copied to [//Storage](smb://storage.grinnell.edu/MEDIADB/DGIngest/WARC) for ingest. |
| 5. Attempted IMI Ingest | Failed | The aforementioned [IMI](https://github.com/mnylc/islandora_multi_importer) ingest process was invoked with Google Sheet https://docs.google.com/spreadsheets/d/1X3rs7UhIdS6SumTwFUvRR0F6-OnGEIF5xnGzcLrFqNY in [Digital.Grinnell](https://digital.grinnell.edu/multi_importer).  The process ran for a very long time, in excess of 30 minutes, before it failed with no error messages or indication of root cause. |
| 6. Attempted "Forms" Ingest of WMI Object | Failed | I navigated to the management page in our [Pending Review](https://digital.grinnell.edu/islandora/object/pending-review/manage) collection and engaged the "Add an object to this Collection" link. I selected the "Islandora Web ARChive Content Model" and "Web ARChive MODS Form" for ingest.  The form was not available so the ingest failed. |
| 7. WARC Module Updated | **Success** | Steps were taken to update the key module, [islandora_solution_pack_web_archive](https://github.com/Islandora/islandora_solution_pack_web_archive) on Digital Grinnell's node DGDocker1. The update ran without error. |
| 8. Repeated Step 6 | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous step (6) but even after the update no "Web ARChive MODS Form" was available. |
| 9. Repeated Step 8 with the Correct Form | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous steps (6 and 8) choosing the "DG ONE Form to Rule them All". The form opened and accepted input, but clicking "Next" presented the sub-form shown below, indicating that a .gz file could not be ingested. |
| 10. Unzipped the .gz Files | **Success** | The WMI's .gz file was nearly 2 GB in size, so I was unable to unzip it using the archive tool on my iMac.  I was able to use `gunzip` to process the files on CentOS node _DGDocker1_. The result was a `.warc` file and `.cdx` file pair for each object (a total of 4 files). |
| 11. Repeated Step 9 | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous step (9) and the sub-form. I terminated the upload process after about 2 hours (included my lunch break). The process could not be resumed from that point. |
| 12. Repeated Step 11 with the "Global Mongol Century" File | Limited **Success** | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous step (11) but with the .warc file representing "The Global Mongol Century" archive.  This .warc file was only 24.2 MB in size and the ingest worked (taking less than 5 minutes) producing [grinnell:27856](https://digital.grinnell.edu/islandora/object/grinnell:27856). No thumbnail image or other image derivatives were created, presumably because I did not choose the `Upload a screenshot?` option. |
| 13. Investigated Using `drush` | Failed | The updated [islandora_solution_pack_web_archive](https://github.com/Islandora/islandora_solution_pack_web_archive) module includes at least one `drush` command, and a non-web ingest of such large files would be preferred. However, investigation determined that the provided `drush` command does not provide an alternate means of ingest. |
| 14. Repeat Step 12 | **Success** | I repeated step 12 still using the relatively small "Global Mongol Century" .warc, but gave the object a title of "World Music Instruments". [grinnell:27858](https://digital.grinnell.edu/islandora/object/grinnell:27858) was created, again with no thumbnail image or other image derivatives. |
| 15. Attempted to Replace the OBJ Datastream | Failed | Navigating to https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/datastreams, I selected the `replace` link associated with the OBJ datastream in an attempt to replace the small .warc object with the proper WMI .warc.  This process failed to finish after nearly an hour of processing, presumably because the WMI .warc is simply too large causing the web process to time-out before completion. |
| 16. Replaced the OBJ Datastream Using FEDORA | **Success** | I navigated to _Digital.Grinnell_'s FEDORA admin page at http://dgdocker1.grinnell.edu:8081/fedora/admin/, logged in as an admin, opened the grinnell:27858 object, and used the FEDORA admin interface there to replace its OBJ datastream. I allowed the upload portion of the process to "spin" for more than an hour, but when I stopped it and saved changes, I found a new OBJ that is 1.97 GB in size. That new OBJ appears to be viable. |
| 17. Generated SCREENSHOT Images | **Success**  | Rebecca used the "Snip Tool" in Windows to collect screenshot images of each "live" website home page. These were uploaded to [//Storage](smb://storage.grinnell.edu/MEDIADB/DGIngest/WARC) for subsequent ingest. |
| 18. Added Images via Manage/Datastreams Menu | **Success** | I navigated to each WARC object's [manage/datastreams page](https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/datastreams) and used the `Add a datastream` links to create new `SCREENSHOT` datastreams using the home page .jpg images. |
| 19. Added Empty MODS Datastreams | **Success** | While still working in each object's [manage/datastreams page](https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/datastreams) I used the `Add a datastream` links again to create new, empty `MODS` datastreams. This step was necessary because _Web ARChive_ content models do not normally include any MODS record by default. |
| 20. Exported Google Sheet to TSV | **Success** | To prep for updating each object's MODS record, I exported the "MASTER" tab of our [Google Sheet](https://docs.google.com/spreadsheets/d/1X3rs7UhIdS6SumTwFUvRR0F6-OnGEIF5xnGzcLrFqNY) to a .tsv, tab-seperated-values, file and saved the export in [//Storage/Library/AllStaff/DG-Metadata-Review-2020-r1/WARC/mods-imvt.tsv](smb://Storage/Library/AllStaff/DG-Metadata-Review-2020-r1/WARC).  |
| 21. Invoked Islandora-MODS-via-Twig Workflow | **Success** | I engaged the `drush imvt`, _islandora\_mods\_via\_twig_, command and subsequent workflow, including _islandora\_datastream\_replace_, to replace the empty MODS records (see step 19) with correct data.  See [Exporting, Editing, & Replacing MODS Datastreams: Technical Details](/en/posts/070-exporting-editing-replacing-mods-datastreams-technical-details) for complete details. |
| 22. Initiate Derivative Regeneration | **Success** | Since the two WARC objects were not ingested in a "traditional" manner, it was necessary to regenerate all derivative datastreams to complete the object. I did so, in the case of `grinnell:27858`, for example, by visiting the object's [manage/properties](https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/properties) page and clicking `Regenerate all derivatives`. |


![WARC sub-form](/images/post-082/WARC-sub-form.png "WARC Sub-Form")

## Summary

Completing steps 1-4, 7, 10, 12, 14, and 16-22, resulted in the two "complete" WARC objects we now have in:

  - [The Global Mongol Century](https://digital.grinnell.edu/islandora/object/grinnell:27856), and
  - [World Music Instruments](https://digital.grinnell.edu/islandora/object/grinnell:27858).

## Move to Faculty Scholarship

All of the above steps were performed while the two objects were part of the `Pending-Review` collection in _Digital.Grinnell_.  Once the objects were reviewed and determined to be correct, steps were taken using each object's [manage page](https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage) to `Migrate this Object to another collection`, choosing to move them both to [Faculty Scholarship](https://digital.grinnell.edu/islandora/object/grinnell%3Afaculty-scholarship).

## Setting Object Permissions

Since both of the WARC objects are for archival only, it was determined that both objects should be accessible only to system administrators. To enforce that restriction I visited each object's [manage/xacml page](https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/xacml) to set appropriate restrictions on object management and object viewing.

## Adding PDF Datastreams

The `islandora_solution_pack_web_archive` module and the Web ARChive content model provide an option to include a PDF in the ingest process. We did not initially generate any PDFs for the two WARCs that were ingested, but we have since taken steps to add PDF datastreams in order to experience what that option has to offer.  The process we employed is briefly documented below.

### PDF Creation

As mentioned earlier, a `wget` command was used to create the .warc files that we ingested, but `wget` does not appear to offer a viable option to create a PDF file. Fortunately, Rebecca's research turned up this _Adobe Acrobat Pro_ trick: https://lenashore.com/2019/06/how-to-make-a-pdf-of-an-entire-website/.

Rebecca reports that this process works, but can take a very long time. She apparently had to specify a limited number of "levels" to enable creation of a reasonable PDF in the case of the _WMI_ web site.

### PDF Datastream Addition

Each object's PDF file was uploaded and ingested to join its corresponding object using steps similar to 18 and 22 above. Each object's [manage/datastreams page](https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/datastreams) was engaged and the `Add a datastream` link used to create new `PDF` datastreams using the .pdf files created earlier.  

Again, since the two WARC objects were not ingested in a "traditional" manner, I thought it necessary to regenerate all derivative datastreams to complete each object. I did so, in the case of `grinnell:27858`, for example, by visiting the object's [manage/properties](https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/properties) page and clicking `Regenerate all derivatives`. The addition of the `PDF` datastream did not appear to create any additional derivatives, but each object came away with an empty `WARC_CSV` and `WARC_FILTERED` datastreams that I manually removed.

The addition of the `PDF` datastreams did produce new PDF-download links like the one shown here:

![DOWNLOAD links](/images/post-082/download-links-example.png "Example: WARC Download Links")


And that's a wrap.  Until next time...
