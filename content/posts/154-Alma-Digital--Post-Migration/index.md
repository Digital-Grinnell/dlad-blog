---
title: "Alma-Digital: Post Migration" 
publishDate: 2025-03-25T10:19:54-05:00
last_modified_at: 2025-03-25T11:24:50
draft: false
description: "Migration of Digital.Grinnell to Alma-D is 'complete'.  It's time now to reconfigure for future bulk import of new content."
supersedes: 
tags:
  - Alma-Digital
  - Digital.Grinnell
azure:
  dir: 
  subdir: 
---  

Formal migration of content from our legacy `Digital.Grinnell` platform in Islandora, to `Alma-Digital` was "completed" on about March 19, 2025.  The configuration and infrastructure used during migration is still viable, but not optimal for bulk import of NEW content.  In this blog post I hope to capture some of the past, and our vision for the immediate future in terms of Alma-D configuration and bulk import.  

## The Past - Migration

Migration from Islandora to Alma-D involved a mix of workflow procedures and (mostly) Python scripts and apps aimed at exporting MODS and digital content from our Islandora instance of Digital.Grinnell (currently residing at https://legacy-dg.grinnell.edu) and importing it into Alma-Digital and a new [qualified DC](https://www.dublincore.org/specifications/dublin-core/usageguide/qualifiers/) record profile.  

### DigitalGrinnell Qualified DC Import Profile

The migration import profile mentioned above was named `DigitalGrinnell Qualified DC Import Profile`; it was basically a modified (augmented) copy of the `dcap01` profile provided by Alma.  In fact, that profile still has an internal name of `dcap01`.  Since it is NOT possible to "copy" or "duplicate" an Alma import profile, we have decided to reuse `dcap01` and give a new name of `NEW DG Qualified DC Import Profile` while removing some of the migration cruft so that the profile is more sensible for import (not migration) of new digital objects.  

Before making modifications to `dcap01`, we felt compelled to capture the migration version of the profile for eternity, so here it is in a series of configuration screen grabs...  

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-39-56.png)

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-40-38.png)

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-41-10.png)

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-41-52.png)

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-42-14.png)

### DigitalGrinnell Qualified DC

This is the qualified DC metadata schema that was used for migration.  As mentioned, it was derived from the `dcap01` profile and will keep that internal name going forward.  It's name, `DigitalGrinnell Qualified DC` will also remain the same going forward, but some of the migration-specific fields/columns will be dropped.  

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-45-18.png)

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-48-17.png)

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-48-41.png)

![](https://dgdocumentation.blob.core.windows.net/alma-digital/2025-03-25-10-49-05.png)





