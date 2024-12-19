---
title: "Discovery Import Profile (DIP) Record Removal" 
publishDate: 2024-12-19T17:08:23-06:00
last_modified_at: 2024-12-19T17:21:24
draft: false
description: A public blog post copied from `Removing-Primo-VE-Imported-OAI-Records.md` in my private repo at https://github.com/Digital-Grinnell/Migration-to-Alma-D.
supersedes: 
tags:
  - DIP
  - OAI
  - Alma
  - Primo VE
azure:
  dir: 
  subdir: 
---  

Follow the guidance provided in https://knowledge.exlibrisgroup.com/Primo/Community_Knowledge/How_to_%E2%80%93_Force_records_from_external_data_sources_to_be_updated_or_deleted_in_Primo_VE for building an XML file that looks like this:  

```
<ListRecords>
  <record>
    <header status="deleted">
      <identifier>oai:repositoryx.grinnell.edu:grinnell_16184</identifier>
    </header>
  </record>
  <record>
    <header status="deleted">
      <identifier>oai:repositoryx.grinnell.edu:grinnell_16185</identifier>
    </header>
  </record>
</ListRecords>
```  

The above .xml file will remove TWO Primo VE records created from import of OAI exported from _Digital.Grinnell_.  It will do so for `grinnell:16184` and `grinnell:16185`, a pair of objects with similar titles that got de-duped into https://grinnell.primo.exlibrisgroup.com/permalink/01GCL_INST/1prvshj/alma991011546867904641.  

## Finding the DIP/OAI Identifiers

The OAI identifiers for these objects were determined by appending `&showPnx=true` to the end of the object's Primo permalink, so https://grinnell.primo.exlibrisgroup.com/permalink/01GCL_INST/1prvshj/alma991011546867904641&showPnx=true which yields a wealth of data including these two lines:  

```yml
    "ilsApiId" : "oai:repositoryx.grinnell.edu:grinnell_16185",
    "ilsApiId" : "oai:repositoryx.grinnell.edu:grinnell_16184",
```  

Note that the aforementioned XML syntax is much easier to create in-bulk, and it's perfectly acceptable:  

```xml
<ListRecords>
<record><header status='deleted'><identifier>oai:repositoryx.grinnell.edu:grinnell_16184</identifier></header></record>
<record><header status='deleted'><identifier>oai:repositoryx.grinnell.edu:grinnell_16185</identifier></header></record>
</ListRecords>
```

## Final Outcome

After running the file shown above, I believe the old OAI records did disappear from _Primo_ after a few minutes time.  During the "purge" _Primo_ did display a placeholder "inkingParameter1" link to https://digital.grinnell.edu/islandora/object/ for the recently removed OAI record.  This too is expected to disappear after about 30 to 60 minutes time.

# Before and After

Permalink here is https://grinnell.primo.exlibrisgroup.com/permalink/01GCL_INST/1prvshj/alma991011547306404641.  This is an object in the `Ancient Coins` collection and the corresponding DIPs were removed on 8-Nov-2024.   The XML file used in this operation was subsequently renamed to `remove-DIP-records-Nov-8.xml` to make way for the next DIP removal job on November 11.  

{{% figure title="Before..." src="/images/post-150/2024-11-08-19-37-37.png" %}}

{{% figure title="After processing and about an hour wait..." src="/images/post-150/2024-11-08-19-52-08.png" %}}

Yay!  The `MMS Id` and permalink remain unchanged too!

A similar DIP removal job was run on November 11 using the XML file named `remove-DIP-records-Nov-11.xml`.  That file was intended to remove ALL remaining DIP records from collections that migrated to Alma before November 11.  That file contained 4301 records to be removed.   

