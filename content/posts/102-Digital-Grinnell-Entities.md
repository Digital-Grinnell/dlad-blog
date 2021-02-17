---
title: "Everything You Ever Wanted to Know About Digital.Grinnell Entities, but were Afraid to Ask"
date: 2021-02-17T13:49:27-06:00
draft: false
emoji: true
tags:
    - Entities
    - person
    - organization
    - event
    - place
    - islandora:entityCModel
    - Islandora Scholar Extended Profiles
    - LASIR
---

_Digital.Grinnell_ used to support and use "entities", metadata-only objects that are referential in nature. Entities are best described in this [Entities Solution Pack](https://wiki.lyrasis.org/display/ISLANDORA715/Entities+Solution+Pack) documentation. Quoting from that resource...

{{% original %}}
This module allows you to add person, place, event, and organization entities to an Islandora repository. Entities are small, metadata-based objects. A number of forms and additional features are provided in this module for those building an institutional repository with Islandora. Much of the functionality for batch ingest and autocomplete (to use entities as authority objects) centres [sic] around the MADS forms provided with the module.

 Custom thumbnails can be added via the manage tab to ingested Events, Places, and Organizations. When creating People entities, a thumbnail can be added at time of object creation. If the thumbnail is not added afterward for the Events, Places, and Organizations Entities, the default icon is the folder icon used for collections.

Objects ingested under Events, Places, Organization and People content models are also affiliated with the generic "Entity" content model provided with the solution pack. To use the Entity content model, you must add it explicitly to the collection policy and associate an appropriate form.
{{% /original %}}

As of today, February 17, 2021, "entities" are back-in-play in _Digital.Grinnell_, thanks to implementation of the [Islandora Scholar Extended Profiles](https://github.com/Islandora-Collaboration-Group/islandora_scholar_profiles) module.  This module is the first part of [LASIR](https://github.com/Islandora-Collaboration-Group/LASIR) to be implemented here at Grinnell.

## DG's Old Entity Structure

In _Digital.Grinnell_'s first implementation of Islandora entities, circa 2015, the `islandora:entity_collection` was established under the repository root, so it's a child/sub-collection of `islandora:root`.  A summary snapshot of that collection shows...

{{% figure title="Existing Entity Collection" src="/images/post-102/entity_collection.png" %}}

Entity objects in this collection were of 4 types:

  - `entity` - A generic entity type that was previously NOT used.
  - `person` - An entity representing a person, typically an author. Entities of this type were created in the `grinnell-person:` namespace and they employ the `islandora:personCModel` content model.
  - `subject` - An entity representing a subject or "topic" like "Chemistry". There's only one remaining entity of this type in DG and it uses a now-defunct namespace of `grinnell-subject:`. Subjects employ the `islandora:subjectCModel` content model.
  - `organization` - An entity representing an organization, typically a Grinnell College department of study, or similar group. Entities of this type were created in the `grinnell-organization:` namespace and they employ the `islandora:organizationCModel` content model.

## DG's New Entity Structure

With the implementation of the [Islandora Scholar Extended Profiles](https://github.com/Islandora-Collaboration-Group/islandora_scholar_profiles) module come some necessary changes. The old `islandora:entity_collection` remains intact, as do all of the related content models, but with some enhancements, and new namespaces to accommodate a new set of objects.  **Note that the old objects listed in the figure above are still present, for now.**






And that's a wrap.  Until next time, always remember to "Use your entities, Luke".
