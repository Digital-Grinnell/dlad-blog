---
title: How to Add a Collection to Digital.Grinnell
publishdate: 2020-06-25
lastmod: 2023-09-11T13:54:15-05:00
draft: false
tags:
  - collection
  - sub-collection
  - PID
  - thumbnail
  - title
  - abstract
  - Digital.Grinnell
  - search
---

So, you want to add a new collection or sub-collection (they are really the same thing) to [Digital.Grinnell](https://digital.grinnell.edu), eh?  It's easy, but there are some things to consider before I show you how.

## Collection Guidelines

There are no "formal" guidelines for the creation of a collection or sub-collection in _Digital.Grinnell_, but I can think of a couple "informal" things to consider.

  - Are there or will there ever be enough objects, old and/or new, with something in common to warrant a new collection?  How many is "enough"? I dunno, but anything fewer than a dozen individual objects is borderline at best, at least in my book.
    - A corollary to this "rule": If a collection has sub-collections, there should be at least two of them, and three is a better minimum.  Why? Because we don't want to create a vertical "tower" of collections stacked one atop another. For more on this see the next rule, below.

  - Is the new collection ever likely to have its own "sub-collections"?
    - As a rule, we don't like having "hybrid" or "mixed" collections because they complicate presentation and sorting. So the rule-of-thumb in _Digital.Grinnell_ is that _a collection can have EITHER many individual objects OR three or more sub-collections, but NEVER a mix of individual objects and sub-collections_.
      - As of this date, 25-June-2020, our [Grinnell College Museum of Art](https://digital.grinnell.edu/islandora/object/grinnell:faulconer) collection is in violation of this "rule" because it contains numerous individual objects AND two sub-collections.  Have a look at the collection using the link provided and you'll probably see why this is not a good idea.

  - Every collection needs a "parent" unless it is going to be a "top-level" collection, and those require SPECIAL consideration.
    - Bottom line, before you set about to create a new collection, presumably a sub-collection, we have to identify the existing "parent" collection that it will reside in.

## What Do I Need Before I Create a New Collection?

Glad you asked. For starters, you'll need to have considered the questions posed above. Having answered those questions, if you elect to proceed, your collection will need the following:

  - A "parent" or "home" collection to reside in. We need to know the PID of that "parent" collection. See the last bullet point above.
  - A "title", something short and to-the-point, usually expressed in title case.
  - A non-numeric PID (Persistent IDentifier). PIDs in _Digital.Grinnell_ have the form: `namespace:identifier`. Numeric identifiers are reserved for individual objects, but collections have non-numeric identifiers like: `grinnell:faculty-scholarship` or `grinnell:jimmy-ley`. The namespace is almost always "grinnell", and the identifier should be short but descriptive, with no spaces, please.
  - An "abstract" or descriptive short paragraph describing the collection. Have a look at existing collections for some good examples.
  - A thumbnail image. This should be a .jpg or .png image to represent the collection. Any size is acceptable, but something on the order of 200-400 pixels is probably best. Larger images will be automatically reduced but they tend to waste space and bandwidth.  The image shown below is a fine example.

![AOH Thumbnail](/images/post-084/aoh-thumbnail.png "Example Collection Thumbnail")

## Ok, How Do I Add My New Collection?

That's really easy... send an [email to digital@grinnell.edu](mailto:digital@grinnell.edu) and ask, politely, please. Honestly, that's what you need to do.

Someday maybe _digital@grinnell.edu_ will take the time to document that part of the process too.  :wink:

## Admin Reminders

So, there are a couple of things that the _Digital.Grinnell_ admins need to remember when adding a collection to the mix:

  - Edit the following source code files in the [dg7 custom module](https://github.com/DigitalGrinnell/dg7) and add the new collection PID as needed to support custom sorting and display.
    - dg7.module
    - dg7.views.inc   _Note: Editing this file is probably NOT necessary._
  - Perform the steps documented in [Updating DG's Collection Views](/posts/068-updating-dgs-collection-views/) to update DG's "collection view" and make the new collection display properly.
  - Visit https://digital.grinnell.edu/admin/islandora/tools/collection_search and determine if the new collection should be added as a "Collection Search" target!  

And it's time to do some real work... I'll be back to share more here, someday.  :smile:
