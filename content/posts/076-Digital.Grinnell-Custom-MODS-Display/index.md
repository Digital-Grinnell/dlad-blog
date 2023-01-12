---
title: "Digital.Grinnell Custom MODS Display"
publishdate: 2020-05-28
draft: false
tags:
  - Digital.Grinnell
  - MODS
  - metadata
  - custom
  - display
image: images/post-076/grinnell-10365-mods.png
---

[Digital.Grinnell](https://digital.grinnell.edu) has seen a lot of customization over the years, and quite a bit of it relates to how an object's metadata, especially its [MODS](http://www.loc.gov/standards/mods/) metadata, is displayed. My aim for the past couple of years has been to remove as much customization as possible, but I've found it difficult to remove features of our MODS display because those features seem to be rather popular. This is particulary true of our compound object display.

## Custom Compound/Child MODS Display

At present, May 28, 2020, the MODS display for a typical compound/child object in Digital.Grinnell looks something like the example image from [grinnell:10365](https://digital.grinnell.edu/islandora/object/grinnell:10365) included here:

![grinnell:10365 MODS Example](/images/post-076/grinnell-10365-mods.png "Sample MODS Display")

The display feature demonstrated above is supposed to "hide" any field in the child object, the first 8 lines of metadata that appear above the "Group Record", which are __identical__ to the same field in the parent/compound object, the lines below the "Group Record" heading.  This rule applies to all fields **except** "Title" and "Supporting Hoste", but if you look closely at the image above you'll see there are some duplicates displayed, specifically:

  - Related Item: Digital Grinnell
  - Language: English
  - Access Condition: Copyright to this work...

### Details

The process of hiding "duplicate" metadata from a child/parent object pair is relatively simple, but it involves some [XSL transformations (XSLT)](https://en.wikipedia.org/wiki/XSLT), so it's inherently messy. The heavy-lifting all takes place in Digital.Grinnell's [islandora_mods_display](https://github.com/DigitalGrinnell/islandora_mods_display) module.

#### XSL Transform

The aforementioned transform happens in a "hook" function called _islandora\_mods\_display\_preprocess\_islandora\_mods\_display\_display_ that can be found in [theme.inc](https://github.com/DigitalGrinnell/islandora_mods_display/blob/master/theme/theme.inc). The .xsl file used in the transform is [mods_display.xsl](https://github.com/DigitalGrinnell/islandora_mods_display/blob/master/xsl/mods_display.xsl). The "merging" of child/parent metadata happens inside the aforementioned function.

#### Hidden Elements

Another function, _islandora\_mods\_display\_remove\_redundant\_rows_, from _theme.inc_ hides redundant rows by applying a CSS class named `hidden` to the `<tr>` elements of the child object MODS that have identical counterparts in the parent's MODS metadata.

## Fixing the Displayed Duplicates

Found it, and fixed it too! The _islandora\_mods\_display\_remove\_redundant\_rows_ code in _theme.inc_ added the `hidden` class to `<tr>` elements like so:

```
$elements[$i] = str_replace('<tr>', '<tr class="hidden">', $elements[$i]);
```

The problem with that statement is that **some table rows now have `xmlns:xlink` attributes** due to the recent addition of live links in some metadata fields.  As a result, those fields that now support live links could not be "hidden".  The same code now reads like so:

```
$elements[$i] = str_replace('<tr', '<tr class="hidden"', $elements[$i]);
```

Note that the closing carret has been removed from both the search string and the replacement.  It works!  Yay:exclamation:  As a result, the same object metadata shown above now looks like this:

![grinnell:10365 MODS Example - Corrected](/images/post-076/grinnell-10365-new-mods.png "Corrected MODS Display")


And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
