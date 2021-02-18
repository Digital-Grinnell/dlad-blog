---
title: "Everything You Ever Wanted to Know About Digital.Grinnell Entities, but were Afraid to Ask"
date: 2021-02-17T15:12:28-06:00
draft: false
emoji: true
tags:
    - Entities
    - person
    - organization
    - event
    - place
    - profile
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

## Primary Function of Entities

Entities are primarily used in conjunction with autocomplete operations in Islandora's forms where they help to promote consistent use.  Entities are also a form of [linked data](https://www.w3.org/standards/semanticweb/data) so they can also assist with discovery and presentation of related objects.

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

New entity objects are of 4 types, with the first two to be implemented immediately, and the remaining two to follow, if/when they are ever needed.

  - `person` - An entity representing a person, typically an author. New entities of this type will be created in the `profile:` namespace and they will employ the `islandora:personCModel` content model.
  - `organization` - An entity representing an organization, typically a Grinnell College department of study, or similar group. Entities of this type will be created in the `organization:` namespace and will employ the `islandora:organizationCModel` content model.
  - `event` - An entity representing an event, such as a symposium or conference. New entities of this type will be created in the `event:` namespace and they will employ the `islandora:eventCModel` content model.
  - `place` - An entity representing a place, like "Burling Library". New entities of this type will created in the `place:` namespace and they will employ the `islandora:placeCModel` content model.

## Adding a New Organization to DG

  - Login to _Digital.Grinnell_ as an admin.
  - Visit https://digital.grinnell.edu/islandora/object/islandora%3Aentity_collection/manage/overview/ingest to add a new entity.
  - To create a new organization select `New Organization` in the _Select a Content Model to Ingest_ drop-down, and click `Next`.
  - In the _Select a Form_ field choose `Department MADS form` and click `Next`.
  - Fill out the form making sure all required fields (denoted with a red asterisk) are filled in, then click `Ingest` to complete the operation.

**Attention!** Pay special attention to the `U2 Identifier` field.  It should be a short ID string that uniquely identifies the organization among all organizations in the repository.  The value you specify here may subsequently be repeated when adding new profiles (persons) to the repository to associate the person with the organization.

## Adding a New Person/Profile to DG

  - Login to _Digital.Grinnell_ as an admin.
  - Visit https://digital.grinnell.edu/islandora/object/islandora%3Aentity_collection/manage/overview/ingest to add a new entity.
  - To create a new profile select `New Person` in the _Select a Content Model to Ingest_ drop-down, and click `Next`.
  - In the _Select a Form_ field choose `Person MADS form` and click `Next`.
  - Fill out the form making sure all required fields (denoted with a red asterisk) are filled in, then click `Ingest` to complete the operation.

**Attention!** Pay special attention to the `Identifier` field.  It should be a short ID string that uniquely identifies the person/profile among all profiles in the repository.  The value you specify here may subsequently be repeated when adding new scholarly works to the repository. This identifier will associate the scholarly work with the identified person, and subsequently with their department/organization.

## Bulk Ingest of New DG Persons

As stated in the [Entities Solution Pack](https://wiki.lyrasis.org/display/ISLANDORA715/Entities+Solution+Pack) documentation, new person entities can be bulk-ingested using the _Islandora Entities CSV Import_ which is documented in DG's _Apache_ container at `/var/www/html/sites/all/modules/islandora/islandora_solution_pack_entities/modules/islandora_entities_csv_import/README.md`.  Since that file can be hard to find, here's the contents pulled from _Digital.Grinnell_...

{{% original %}}
# Islandora Entities CSV Import [![Build Status](https://travis-ci.org/Islandora/islandora_solution_pack_entities.png?branch=7.x)](https://travis-ci.org/Islandora/islandora_solution_pack_entities)

## Introduction

This module is for adding person entities to Islandora using a .csv file.

## Requirements

This module requires the following modules/libraries:
* [Islandora](https://github.com/islandora/islandora)
* [Islandora Basic Collection](https://github.com/Islandora/islandora_solution_pack_collection)
* [Islandora Entities](https://github.com/Islandora/islandora_solution_pack_entities)

## Installation

Install as usual, see [this](https://drupal.org/documentation/install/modules-themes/modules-7) for further information.

## Configuration

Prepare a comma-delimited CSV file using the column names below. Only columns with names in the list will be processed;
all others will be ignored. Any comma within a field must be replaced with a double pipe ie - 'Nursing, Department of'
must be replaced with 'Nursing|| Department of'.

Multiple arguments within one column can be separated with a tilde (~). However, this may yield unexpected results
(missing XML attributes, improper nesting) if used outside the following fields: FAX, PHONE, EMAIL, POSITION.


```
STATUS
POSITION
EMAIL
BUILDING
ROOM_NUMBER
IDENTIFIER
TERM_OF_ADDRESS
GIVEN_NAME
FAMILY_NAME
FAX
PHONE
DISPLAY_NAME
DEPARTMENT
BUILDING
CAMPUS
NAME_DATE
STREET
CITY
STATE
COUNTRY
POSTCODE
START_DATE
END_DATE
ROOM_NUMBER
BUILDING
CAMPUS
```

This will be transformed into the following MADS record:

```xml
<mads xmlns="http://www.loc.gov/mads/v2" xmlns:mads="http://www.loc.gov/mads/v2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    <authority>
        <name type="personal">
            <namePart type="given">[GIVEN_NAME]</namePart>
            <namePart type="family">[FAMILY_NAME]</namePart>
            <namePart type="termsOfAddress">[TERM_OF_ADDRESS]</namePart>
            <namePart type="date">[NAME_DATE]</namePart>
        </name>
        <titleInfo>
            <title>[DISPLAY_NAME]</title>
        </titleInfo>
    </authority>
    <affiliation>
        <organization>[DEPARTMENT]</organization>
        <position>[POSITION]</position>
        <address>
		<email>[EMAIL]</email>
		<phone>[PHONE]</phone>
		<fax>[FAX]</fax>
		<street>[STREET]</street>
		<city>[CITY]</city>
		<state>[STATE]</state>
		<country>[COUNTRY]</country>
		<postcode>[POSTCODE]</postcode>
		<start_date>[START_DATE]</start_date>
		<end_date>[END_DATE]</end_date>
	</address>
    </affiliation>
    <note type="address">[ROOM_NUMBER] [BUILDING] [CAMPUS]</note>
    <identifier type="u1">[IDENTIFIER]</identifier>
    <note type="status">[STATUS]</note>
</mads>
```

## Documentation

Further documentation for this module is available at [our wiki](https://wiki.duraspace.org/display/ISLANDORA/Entities+Solution+Pack).

## Troubleshooting/Issues

Having problems or solved a problem? Check out the Islandora google groups for a solution.

* [Islandora Group](https://groups.google.com/forum/?hl=en&fromgroups#!forum/islandora)
* [Islandora Dev Group](https://groups.google.com/forum/?hl=en&fromgroups#!forum/islandora-dev)

## Maintainers/Sponsors

Current maintainers:

* [Rosie Le Faive](https://github.com/rosiel)

## Development

If you would like to contribute to this module, please check out our helpful [Documentation for Developers](https://github.com/Islandora/islandora/wiki#wiki-documentation-for-developers) info, as well as our [Developers](http://islandora.ca/developers) section on the Islandora.ca site.

## License

[GPLv3](http://www.gnu.org/licenses/gpl-3.0.txt)
{{% /original %}}

Unfortunately, it's not clear if such a bulk ingest will still work properly with the new [Islandora Scholar Extended Profiles](https://github.com/Islandora-Collaboration-Group/islandora_scholar_profiles) module in-play?  Also, there's no mention of similar capability for organizations, and it would be nice to have a bulk ingest process that works for both.  So, I'm going to play with "manual" creation of a few entities, a couple organizations and a couple of profiles, and then see if I can determine what it might take to auto-populate both kinds of objects using an [IMI import](https://github.com/mnylc/islandora_multi_importer).

## Suggestions for Profile and Organization Identifiers

It appears that creation and use of "U1" and "U2" identifiers is key to making objects properly associate with profiles, and profiles properly associate with organizations. So, I'd like to suggest that we use a person's Grinnell College email address prefix, the portion before _\@grinnell.edu_, as their identifier.  My identifier, for example, would be _mcfatem_, taken from my college email address which is _mcfatem\@grinnell.edu_. 

And that's a wrap.  Until next time, always remember to "Use your entities, Luke".
