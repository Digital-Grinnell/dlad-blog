---
title: IDU DiffDatastreamVersions Command
publishdate: 2022-02-14
draft: false
tags:
  - IDU
  - Islandora Drush Utilities
  - diff
  - Datastream
  - version
  - islandora_pretty_text_diff
  - islandora_datastream_replace
---

Recently, I have been catching up on processing some pending metadata review edits in DG's _Faculty Scholarship_ and _Student Scholarship_ collections.  Since these two collections are relatively "fluid", they frequent additions and sometimes changes, I was worried that introducing bulk edits could negatively impact some objects.  So, I set out to find or create a tool that would help me evaluate the impact of these edits.

## Islandora Pretty Text Diff

I was fortunate to find a very nice tool all ready-to-go, the _Islandora Pretty Text Diff_ module, specifically [islandora_pretty_text_diff](https://github.com/contentmath/islandora_pretty_text_diff). I installed and enabled this module on _DGDocker1_ in early February 2022.  

It can be used by any DG admin by examining an object's datastream versions, https://digital.grinnell.edu/islandora/object/grinnell:10001/manage/datastream, for example.  In a `manage/datastreams` window like the example an admin can now select the version history of any text datastream, _MODS_ is the most likely choice, and in the ensuing window, like https://digital.grinnell.edu/islandora/object/grinnell:10001/datastreams/MODS/version, there is an option at the bottom of the list/window to select a pair of versions to compare, then click `View Diff`.

In my example the bottom of the window looked like the small image captured below.

{{% figure title="Example MODS Versions Window for grinnell:10001" src="/images/post-118/grinnell-10001-mods-versions.png" %}}

From that window I elected to select two of the most recent MODS versions as you can see in the screen capture posted below.

{{% figure title="Example MODS Versions Window - Two Versions Selected" src="/images/post-118/grinnell-10001-selected-versions.png" %}}

After selecting the two MODS version I simply clicked on the `View Diff` button to open the window shown below.

{{% figure title="Example Version Diff Display" src="/images/post-118/grinnell-10001-diff-display.png" %}}

The single line highlighted in green indicates the only difference between the two versions was the addition of a `<copyrightDate>2014</copyrightDate>` field and value.  Note that anything removed from by the version changes would be similarly highlighted in red.

## The Problem with This Approach

Many of the operations that can generate new datastream versions will deposit more than one new version per operation.  For instance, running a single `islandora_datastream_replace` command (see [Exporting, Editing & Replacing MODS Datastreams: Updated Technical Details](content/posts/115-Exporting-Editing-Replacing-MODS-Datastreams-Updated-Technical-Details.md)) can generate as many as three new versions of an object's MODS record.  You can get a sense of the outcome looking at the portion of the MODS version history displayed below for `grinnell:10001`.

{{% figure title="Example Version History" src="/images/post-118/grinnell-10001-version-history.png" %}}

Note how many versions of the MODS datastream were created at the same instant in time, or only a few seconds apart!

## A New Drush IDU Command

To try and deal with the issue of multiple versions per operation, I crafted a new _IDU_ (Islandora Drush Utilities) command with example syntax like:

```
drush -u 1 iduF grinnell:10000-10001 DiffDatastreamVersions --dsid=MODS
```

This command will examine the creation dates/times of all of the `--dsid` datastream versions and select the current version along with the most recent version *that is at least one minute older than the current*.  This helps avoid comparing versions from the same operation.

The above command produced the following output:

```
root@7f4311ed759c:/var/www/html/sites/default# drush -u 1 iduF grinnell:10000-10001 DiffDatastreamVersions --dsid=MODS
Ok, iduF command 'DiffDatastreamVersions' was verified on 10-Feb-2022.                                [status]
iduCommon_drush_prep will consider only objects modified with a yyyy-mm-dd local time matching 2*.    [status]
Starting operation for PID 'grinnell:10000' and --repeat='1' at 16:01:12.                             [status]
Fetching all valid object PIDs in the specified range.                                                [status]
Completed fetch of 2 valid object PIDs from Solr.                                                     [status]
Progress: iduFix - DiffDatastreamVersions
iduCommon_Connect: Connection to Fedora repository as 'System Admin' is complete.                     [status]
Version diff written to 'public://grinnell-10000_MODS.diff'
Version diff written to 'public://grinnell-10001_MODS.diff' ========>                                 ]  50%
[=====================================================================================================] 100%
Completed 2 'iduFix - DiffDatastreamVersions' operations at 16:01:22.                                 [status]
```

Note that two `.diff` files were created, `public://grinnell-10000_MODS.diff` and `public://grinnell-10001_MODS.diff`.

The first of these files, `grinnell-10000_MODS.diff`, was empty signifying that the two version of MODS were identical.  The second file, `grinnell-10001_MODS.diff`, contained the following:

```
--- /tmp/grinnell-10001_2022-02-10-16-40-43.MODS	2022-02-14 22:01:22.883776814 +0000
+++ /tmp/grinnell-10001_2022-02-10-18-14-27.MODS	2022-02-14 22:01:22.884776813 +0000
@@ -20,6 +20,7 @@
     <dateCreated>2014</dateCreated>
     <publisher>Grinnell College</publisher>
     <dateOther>41933</dateOther>
+    <copyrightDate>2014</copyrightDate>
   </originInfo>
   <physicalDescription>
     <extent>8 objects</extent>
```

A single `+` in the left margin indicates that the line was "added" during the creation of the most recent datastream version.  Likewise, any lines removed or superseded during the creation of the new version would be proceeded by a `-`, but there were none in this example.

A more complete example, using `grinnell:10010` is shown below.

```
root@7f4311ed759c:/var/www/html/sites/default/files# drush -u 1 iduF grinnell:10010 DiffDatastreamVersions --dsid=MODS
Ok, iduF command 'DiffDatastreamVersions' was verified on 10-Feb-2022.                              [status]
iduCommon_drush_prep will consider only objects modified with a yyyy-mm-dd local time matching 2*.  [status]
Starting operation for PID 'grinnell:10010' and --repeat='0' at 16:09:49.                           [status]
Fetching all valid object PIDs in the specified range.                                              [status]
Completed fetch of 1 valid object PIDs from Solr.                                                   [status]
Progress: iduFix - DiffDatastreamVersions
iduCommon_Connect: Connection to Fedora repository as 'System Admin' is complete.                   [status]
Version diff written to 'public://grinnell-10010_MODS.diff'
[===================================================================================================] 100%
Completed 1 'iduFix - DiffDatastreamVersions' operations at 16:09:59.                               [status]
```

The result:

```
root@7f4311ed759c:/var/www/html/sites/default/files# cat grinnell-10010_MODS.diff
--- /tmp/grinnell-10010_2022-02-09-21-24-57.MODS	2022-02-14 22:09:59.181745351 +0000
+++ /tmp/grinnell-10010_2022-02-10-16-29-49.MODS	2022-02-14 22:09:59.181745351 +0000
@@ -1,71 +1,70 @@
 <?xml version="1.0"?>
-<mods xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
-  <name type="personal" xlink:href="grinnell-auth:193">
-    <namePart type="given">Henry</namePart>
-    <namePart type="family">Walker</namePart>
-    <namePart>Walker, Henry M., 1947-</namePart>
+<mods xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd">
+  <titleInfo>
+    <title>ACM Works of Dr. Henry M. Walker</title>
+  </titleInfo>
+  <titleInfo type="alternative">
+    <title>Publications of Henry M. Walker indexed by the ACM Digital Library or from other sources</title>
+  </titleInfo>
+  <name type="personal">
+    <namePart>Walker, Henry M., 1947- (Faculty/Staff)</namePart>
     <role>
       <roleTerm type="text">creator</roleTerm>
     </role>
   </name>
-  <titleInfo>
-    <title>ACM Works of Dr. Henry M. Walker</title>
-  </titleInfo>
   <name type="corporate">
+    <namePart>Grinnell College. Computer Science</namePart>
     <role>
       <roleTerm type="text">supporting host</roleTerm>
     </role>
-    <namePart>Grinnell College. Computer Science.</namePart>
   </name>
-  <abstract>This image is a screen capture (taken February 4, 2015) of a web page listing several ACM (Association for Computing Machinery) copyrighted publications of Dr. Henry M. Walker, Grinnell College.  Associated metadata includes the text of all pertinent links presented in Dr. Walker's page.</abstract>
+  <abstract>Screen capture (taken February 4, 2015) of a web page listing several ACM (Association for Computing Machinery) copyrighted publications of Dr. Henry M. Walker, Grinnell College.</abstract>
   <originInfo>
-    <dateCreated>1981</dateCreated>
-    <edition>current</edition>
-    <edition>current</edition>
+    <dateCreated>2015</dateCreated>
+    <dateOther displayLabel="Date Issued">1981-present</dateOther>
     <publisher>ACM</publisher>
   </originInfo>
-  <typeOfResource>text</typeOfResource>
-  <genre>web site</genre>
-  <physicalDescription>
-    <digitalOrigin>born digital</digitalOrigin>
-    <extent displayLabel="Digital Extent">1 sheet</extent>
-    <internetMediaType>image/jpeg</internetMediaType>
-  </physicalDescription>
-  <note displayLabel="Date Issued" type="creation/production credits">1981-present</note>
-  <language>
-    <languageTerm type="text">English</languageTerm>
-    <languageTerm type="code">eng</languageTerm>
-  </language>
+  <note type="description">This image is a screen capture (taken February 4, 2015) of a web page listing several ACM (Association for Computing Machinery) copyrighted publications of Dr. Henry M. Walker, Grinnell College.  Associated metadata includes the text of all pertinent links presented in Dr. Walker's page.</note>
   <subject authority="lcsh">
     <topic>Computer science</topic>
+    <topic>Bibliography</topic>
   </subject>
   <subject authority="lcsh">
     <temporal>20th century</temporal>
   </subject>
-  <relatedItem type="isPartOf">
+  <relatedItem type="host">
     <titleInfo>
-      <title>Digital Grinnell</title>
+      <title>Faculty Scholarship</title>
     </titleInfo>
-    <identifier type="uri">grinnell:173</identifier>
   </relatedItem>
-  <relatedItem displayLabel="ACM Page" type="isPartOf" xlink:href="http://www.cs.grinnell.edu/~walker/acm-publications.html">
+  <relatedItem type="host">
     <titleInfo>
-      <title>Faculty Scholarship</title>
+      <title>Scholarship at Grinnell</title>
     </titleInfo>
   </relatedItem>
-  <relatedItem type="constituent">
+  <relatedItem type="host" xlink:href="https://digital.grinnell.edu">
     <titleInfo>
       <title>Digital Grinnell</title>
     </titleInfo>
   </relatedItem>
-  <identifier type="hdl">http://hdl.handle.net/11084/10010</identifier>
+  <genre authorityURI="https://id.loc.gov/authorities/genreForms.html">Bibliographies</genre>
+  <physicalDescription>
+    <extent>1 sheet</extent>
+    <internetMediaType>image/jpeg</internetMediaType>
+    <digitalOrigin>born digital</digitalOrigin>
+  </physicalDescription>
+  <classification authoritiy="lcc" type="mixed">QA76</classification>
+  <language>
+    <languageTerm type="text">English</languageTerm>
+    <languageTerm authority="iso639-2b" type="code">eng</languageTerm>
+  </language>
   <identifier type="local">grinnell:10010</identifier>
+  <identifier type="hdl">http://hdl.handle.net/11084/10010</identifier>
   <accessCondition type="useAndReproduction">Copyright to this work is held by the ACM and by the author(s), in accordance with United States copyright law (USC 17). Readers of this work have certain rights as defined by the law, including but not limited to fair use (17 USC 107 et seq.).</accessCondition>
-  <mods:extension>
-    <mods:creators>Walker, Henry M., 1947-</mods:creators>
-    <mods:primarySort>99</mods:primarySort>
-    <mods:CModel>islandora:sp_basic_image</mods:CModel>
-  </mods:extension>
-  <identifier type="u1">walker</identifier>
-  <identifier type="u2">CSC</identifier>
+  <extension>
+    <dg_importIndex>4</dg_importIndex>
+    <primarySort>99</primarySort>
+    <dg_parentObject>grinnell:faculty-scholarship</dg_parentObject>
+    <CModel>islandora:sp_basic_image</CModel>
+  </extension>
```

As you can see, there were numerous differences and they can be very difficult to effectively visualize in this form.  **Have no fear, there's a remedy for this too, and I shall document it as soon as my headache has been addressed.**  8^(






And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
