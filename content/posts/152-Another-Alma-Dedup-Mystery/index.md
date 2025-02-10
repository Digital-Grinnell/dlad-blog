---
title: "Another Alma Dedup Mystery" 
publishDate: 2025-02-10T11:19:55-06:00
last_modified_at: 2025-02-10T11:25:03
draft: false
description: A 'reminder' blog post copied from an email thread from Feb 10, 2025.
supersedes: 
tags:
  - Alma
  - migration
azure:
  dir: 
  subdir: 
---  

This is a copy of an email I dispatched regarding bulk import of DG objects using the Alma Digital Uploader... 

{{% boxmd %}}
Summary:  Be VERY CAREFUL when populating the `dcterms:bibliographicCitation` field!  Apparently, Alma uses that field to help identify dedup matches, and if it causes a cascading, or “multiple match” condition, the object WILL NOT IMPORT.   

This came to light with one of the objects you can see at https://grinnell.primo.exlibrisgroup.com/discovery/collectionDiscovery?vid=01GCL_INST:GCL&query=any,contains,Save%20CR%20Heritage%20(https:%2F%2Fwww.savecrheritage.org%2F), and with ingest of the object you can see at https://grinnell.primo.exlibrisgroup.com/permalink/01GCL_INST/1prvshj/alma991011585445404641.  

All 6 of these objects had a `dcterms:bibliographicCitation` value of “Save CR Heritage (https://www.savecrheritage.org/)”.   I’m not a cataloger, but I suspect that is not where that data should be.   

Presumably, that match combined with portions of the title and publisher created a “cascading” dedup so the record would not stick.   

I fixed this by moving the `dcterms:bibliographicCitation` value of “Save CR Heritage (https://www.savecrheritage.org/)” into a `dcterms:isPartOf.dcterms:URI` field where I think it belongs.  

I’d like to suggest that all the objects in this new collection that have a `dcterms:bibliographicCitation` value should be reviewed and those values probably moved to the `dcterms.isPartOf.dcterms.URI` field or elsewhere.  
 
{{% /boxmd %}}
