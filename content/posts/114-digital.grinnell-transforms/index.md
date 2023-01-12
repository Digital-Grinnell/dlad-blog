---
title: "Digital.Grinnell Transforms"
publishDate: 2021-11-17
lastmod: 2021-12-09T13:20:16-06:00
draft: false
tags:
  - XSLT
  - XSL
  - transforms
  - mods
  - dc
  - Islandora MODS Display
  - Group Record
supersedes:
---

[Digital.Grinnell](https://digital.grinnell.edu) relies on two different metadata XSL "transforms" to convert a cataloger's [MODS](http://www.loc.gov/standards/mods/) descriptive data into a modified MODS record and a corresponding [Dublin Core](https://dublincore.org/) record.

## Self-Transforms

The first transform type can be thought of as a "self-transform" because it accepts a MODS input and produces a modified MODS output; there is no change in schema, just changes in the data and its order.

## MODS-to-DC Transforms

All other transforms relevant to this document are "MODS-to-DC" transforms. They accept a valid MODS record and output a corresponding, valid record under the DC schema.

## Metadata Transform Operations

Metadata transformations in _Digital.Grinnell_ take place in three possible scenarios:

  - When a new object is created or an existing object is modified using one of DG's input "Forms".
  - When one or more new or existing objects are processed in-bulk using IMI, the [Islandora Multi-Importer](https://github.com/mnylc/islandora_multi_importer) module.
  - When the system admin invokes an [IDU](https://github.com/Digital-Grinnell/dg-islandora/tree/main/sites/all/modules/islandora/idu), or `Islandora Drush Utilities`, action like `SelfTransform`.

## DG's Available Transforms

A recent survey of [DG's staging instance](https://isle-stage.grinnell.edu) found the following transforms, or `.xsl` files, relevant to MODS and DC records.  The first list includes relevant `.xsl` files from the the `./sites/all/modules/islandora/` path. The second list includes relevant `.xsl` files from all other paths.

### Transforms From `./sites/all/modules/islandora/`

| Path | Purpose |
| --- | --- |
| ./islandora_importer/xsl/mods_to_dc.xsl | Unknown. |
| ./islandora_batch/transforms/mods_to_dc.xsl | Unknown.  |
| ./islandora_mods_display/xsl/mods_display.xsl | See [MODS display module](#mods-display-module) below. |
| ./islandora_mods_display/xsl/mods_display_compound_parent.xsl | See [MODS Display Module](#mods-display-module) below. |
| ./islandora_oai/transforms/mods_to_dc_oai.xsl | Unknown. Part of Islandora's OAI export module. |
| ./islandora/xml/strip_newlines_and_whitespace.xsl | Unknown. |
| ./islandora/xml/transforms/mods_to_dc.xsl | Apparently, this is the default MODS-to-DC transform shipped with Islandora's core module? |
| ./islandora_multi_importer/xslt/mods_to_dc.xsl | See [IMI Transforms](#imi-transforms) below. |
| ./islandora_multi_importer/xslt/islandora_cleanup_mods_extended_strict.xsl | See [IMI Transforms](#imi-transforms) below. |
| ./islandora_xml_forms/builder/transforms/mods_to_dc.xsl | See [Forms Builder](#forms-builder) below. |
| ./islandora_xml_forms/builder/self_transforms/islandora_cleanup_mods_extended.xsl | See [Forms Builder](#forms-builder) below. |
| ./islandora_xml_forms/builder/self_transforms/cleanup_mods.xsl | See [Forms Builder](#forms-builder) below. |
| ./islandora_xml_forms/builder/self_transforms/islandora_cleanup_mods_extended_strict.xsl | See [Forms Builder](#forms-builder) below. |
| ./islandora_xml_forms/tests/islandora_solution_pack_test/xsl/self_transform.xsl | Unknown. Part of the "test" soloution pack. |
| ./islandora_xml_forms/tests/islandora_solution_pack_test/xsl/mods_to_dc_custom.xsl | Unknown. Part of the "test" soloution pack. |
| ./dg7/xslt/cleanup_mods_and_reorder.xsl | See [DG7 Custom Transforms](#dg7-custom-transforms) below. |
| ./dg7/xslt/mods_to_dc_grinnell.xsl | See [DG7 Custom Transforms](#dg7-custom-transforms) below. |

### Transforms From All Other Paths

| Path | Purpose |
| --- | --- |
| ./sites/default/files/cleanup_mods.xsl | `public://` files.  See [Custom `public://` Files](#custom-public-files) below. |
| ./sites/default/files/reorder_mods.xsl | `public://` files.  See [Custom `public://` Files](#custom-public-files) below. |

## MODS Display Module

_Digital.Grinnell_ uses a [DG-specific fork](https://github.com/DigitalGrinnell/islandora_mods_display) of the [Islandora MODS Display](https://github.com/jyobb/islandora_mods_display) module to display metadata on individual object pages like the sample shown here.

{{% figure title="Sample MODS Metadata Display from grinnell:11451" src="/images/post-114/grinnell-11451-mods-display.png" %}}

The two transforms listed as part of this module are for display only.  These transforms are engaged "on-demand" when MODS metadata is to be displayed; the output from these transforms is never saved. They transform an object's stored MODS datastream into a display like that shown in the same above.

The `./islandora_mods_display/xsl/mods_display.xsl` is a customized DG-specific copy of a default transform provided by the module. In most cases this is the only transform that exists as part of the module; however, in _Digital.Grinnell_ we have introduced a mechanism that treats compound objects a little differtently than all others. That's where the module customization and the `./islandora_mods_display/xsl/mods_display_compound_parent.xsl` transform come into play.

When DG's custom `islandora_mods_display` module encounters an object which is a "child" of a compound "parent" object, it engages both transforms to remove most data which is "redundant" between the "parent" and its "child".  The display is split into two sections:

  - The top section shows data specific to the child<sup>\*</sup>, and
  - The bottom section appears below a `Group Record` sub-heading and shows data that is specific to the parent<sup>\*</sup>, or common to both the parent and child.  

<sup>\*</sup>The `Creator` and `Title` elements of BOTH the parent and child are always shown in BOTH sections of the display.

### _Group Record_ Sub-heading Not Displayed

During evaluation of some objects I found that some compound parent objects were not displaying the _Group Record_ sub-heading mentioned above. I devised a quick fix for such compound parents as a simple _drush_ `iduF` command of the form:

`drush -u 1 iduF grinnell:12423 AddXML --title="mods:CModel" --xpath="/mods:mods/mods:extension" --contents="islandora:compoundCModel" --dsid=MODS`

That particular command produced this output...

```markdown
root@b15318351296:/var/www/html/sites/default# drush -u 1 iduF grinnell:12423 AddXML --title="mods:CModel" --xpath="/mods:mods/mods:extension" --contents="islandora:compoundCModel" --dsid=MODS
Ok, iduF command 'AddXML' was verified on 3-Dec-2021.                                                                                                                                                       [status]
icu_drush_prep will consider only objects modified with a yyyy-mm-dd local time matching 2*.                                                                                                                [status]
Starting operation for PID 'grinnell:12423' and --repeat='0' at 12:20:06.                                                                                                                                   [status]
Fetching all valid object PIDs in the specified range.                                                                                                                                                      [status]
Completed fetch of 1 valid object PIDs from Solr.                                                                                                                                                           [status]
Progress: iduFix - AddXML
icu_Connect: Connection to Fedora repository as 'System Admin' is complete.                                                                                                                                 [status]
[==============================================================================================================================================================================================================] 100%
Completed 1 'iduFix - AddXML' operations at 12:20:16.                                                                                                                                                       [status]

```

## Forms Builder

In this context the "forms builder" refers to the [Islandora XML Forms](https://github.com/Islandora/islandora_xml_forms) module. I hate to say it, but this module is an admin nightmare and always has been.  I've found the forms builder difficult to use and impossible to master, there are just too many undocumented or poorly-documented "features".  Forms are made to be customized but they live in the Drupal database where there's no version control.  Even worse, the user interface provided to associate transforms with a form only makes available those transforms that reside within the module at `./islandora_xml_forms/builder/transforms/` and `./islandora_xml_forms/builder/self_transforms/`.  The effect is a module that's intended to be customized, is painful to manage, and with no reasonable means of enforcing version control for necessary customizations!

The transforms associated with the forms builder above are `./islandora_xml_forms/builder/transforms/mods_to_dc.xsl`, `./islandora_xml_forms/builder/self_transforms/islandora_cleanup_mods_extended.xsl`, `./islandora_xml_forms/builder/self_transforms/cleanup_mods.xsl`, and `./islandora_xml_forms/builder/self_transforms/islandora_cleanup_mods_extended_strict.xsl` are all un-customized "default" forms that ship with the _Islandora XML Forms_ module.

{{% annotation %}}
It is my belief that the two "custom" transforms currently found in the `./dg7/xslt/` directory, namely `cleanup_mods_and_reorder.xsl` and `mods_to_dc_grinnell.xsl`, should be copied to `./islandora_xml_forms/builder/self_transforms/cleanup_mods_and_reorder.xsl` and `./islandora_xml_forms/builder/transforms/mods_to_dc_grinnell.xsl`, respectively.  Once these have been copied into the `islandora_xml_forms` module path they should be associated with _Digital.Grinnell_'s latest XML form for all content model types.
{{% /annotation %}}

### I Was Wrong, Again

A short time ago I put my hypothesis (see the annotation just above) to the test.  Specifically, I applied the two XSL transforms from `./dg7/xslt/` to a new XML form and ingested a new test object.  **The results in terms of MODS were NOT good**.  In order to capture the history of this testing process I also created a new GitHub repo, [https://https://github.com/Digital-Grinnell/mods-reordering-notes-mystery.git](https://https://github.com/Digital-Grinnell/mods-reordering-notes-mystery.git).

#### `grinnell:20259` and `test:22591`, `test:22592`, etc.

The subjects of this section are `grinnell:20259`, an object that is missing one of the MODS `note` fields that an editor specified, `test:22591`, and `test:22592`, new copies of that same object ingested and subsequently modified for testing purposes using a series of operations.

`grinnell:20259` was one of many objects found to be "missing" a MODS _note_ field that was originally input by an object editor but later disappeared from the object's MODS display.  

#### History of `grinnell:20259`

I found evidence of changes made to `grinnell:20259` in `/mnt/metadata-review/phpp-dcl/` where there are a number of files named `grinnell_20259_MODS...` as you can see in this directory listing from `dgdocker1`:

```
[root@dgdocker1 phpp-dcl]# ls -alh grinnell_20259*
-rwxr-xr-x. 1 root root 3.4K Apr 14  2020 grinnell_20259_MODS.log
-rwxr-xr-x. 1 root root  291 Apr 14  2020 grinnell_20259_MODS.remainder
-rwxr-xr-x. 1 root root 2.7K Apr  8  2020 grinnell_20259_MODS.xml
```

The `grinnell_20259_MODS.log` file pinpoints why the `notes` element went missing...

```
[root@dgdocker1 phpp-dcl]# cat grinnell_20259_MODS.log
Object PID: grinnell:20259   14-Apr-2020 16:55

Warning: Unexpected structure detected in the data. The element could not be processed.
  Unexpected Element: {"primarySort": " ==> Primary_Sort", "dg_importIndex": " ==> Import_Index"}
Warning: Unexpected structure detected in the data. The element could not be processed.
  Unexpected Element: "290 of 592 slides from the Imagine Grinnell 2000 collection have been added to the Poweshiek History Preservation Project. A physical copy and TIFF images of all the slides can be found at Drake Community Library Archives in Grinnell, Iowa."
Warning: Unexpected structure detected in the data. The element could not be processed.
  Unexpected Element: "290 of 592 slides from the Imagine Grinnell 2000 collection have been added to the Poweshiek History Preservation Project. A physical copy and TIFF images of all the slides can be found at Drake Community Library Archives in Grinnell, Iowa."
Warning: Unexpected structure detected in the data. The element could not be processed.
  Unexpected Element: {"dateCreated": " ==> Index_Date", "dateIssued": " ==> Date_Issued", "publisher": " ==> Publisher"}
Warning: Unexpected structure detected in the data. The element could not be processed.
  Unexpected Element: {"digitalOrigin": " ==> Digital_Origin", "extent": " ==> Extent", "internetMediaType": " ==> MIME_Type"}
Warning: Unexpected structure detected in the data. The element could not be processed.
  Unexpected Element: {"@authority": "lcsh", "geographic": " ==> Subjects_Geographic"}
Warning: Unexpected structure detected in the data. The element could not be processed.
  Unexpected Element: {"@authority": "lcsh", "geographic": " ==> Subjects_Geographic"}

Remaining elements are:
{
  "mods": {
    "@xmlns": "http://www.loc.gov/mods/v3",
    "@xmlns:mods": "http://www.loc.gov/mods/v3",
    "@xmlns:xlink": "http://www.w3.org/1999/xlink",
    "@xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
    "abstract": " ==> Abstract",
    "accessCondition": " ==> Access_Condition",
    "extension": {
      "dg_importIndex": " ==> Import_Index",
      "primarySort": " ==> Primary_Sort"
    },
    "genre": " ==> Genre~AuthorityURI",
    "identifier": [
      " ==> Local_Identifier",
      " ==> Handle"
    ],
    "language": {
      "languageTerm": " ==> Language_Names~Codes"
    },
    "name": " ==> Corporate_Names~Roles",
    "note": [
      " ==> Public_Notes~Types",
      "290 of 592 slides from the Imagine Grinnell 2000 collection have been added to the Poweshiek History Preservation Project. A physical copy and TIFF images of all the slides can be found at Drake Community Library Archives in Grinnell, Iowa."
    ],
    "originInfo": {
      "dateCreated": " ==> Index_Date",
      "dateIssued": " ==> Date_Issued",
      "publisher": " ==> Publisher"
    },
    "physicalDescription": {
      "digitalOrigin": " ==> Digital_Origin",
      "extent": " ==> Extent",
      "internetMediaType": " ==> MIME_Type"
    },
    "relatedItem": [
      " ==> Related_Items~Types",
      " ==> Related_Items~Types",
      " ==> Related_Items~Types"
    ],
    "subject": [
      " ==> LCSH_Subjects",
      {
        "@authority": "lcsh",
        "geographic": " ==> Subjects_Geographic"
      },
      " ==> Keywords"
    ],
    "titleInfo": " ==> Title",
    "typeOfResource": " ==> Type_of_Resource~AuthorityURI"
  }
  ```   

The presence of "leftover" **data** in the above log is an indication of a problem in the process.  

```
"note": [
  " ==> Public_Notes~Types",
  "290 of 592 slides from the Imagine Grinnell 2000 collection have been added to the Poweshiek History Preservation Project. A physical copy and TIFF images of all the slides can be found at Drake Community Library Archives in Grinnell, Iowa."
],
```

It's acceptable and expected that some "labels" will be leftover after the record is processed, but there should never be any "data" left behind.  This is also reflected in the contents of `grinnell_20259_MODS.remainder` which shows:

```
[root@dgdocker1 phpp-dcl]# cat grinnell_20259_MODS.remainder
{"note": ["290 of 592 slides from the Imagine Grinnell 2000 collection have been added to the Poweshiek History Preservation Project. A physical copy and TIFF images of all the slides can be found at Drake Community Library Archives in Grinnell, Iowa."], "subject": [{"@authority": "lcsh"
```

{{% annotation %}}
The outcomes noted above point to a deficiency in the logic of the **Map-MODS-to-MASTER** Python 3 script that was used to map MODS to a new `mods.tsv` file on April 14, 2020.
{{% /annotation %}}



Time for a... break.
