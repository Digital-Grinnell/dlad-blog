---
title: "`dg_timestamp` Google Sheet Apps Script" 
publishDate: 2024-12-12T16:10:55-06:00
last_modified_at: 2024-12-12T17:58:45
draft: false
description: Inserts a static/permanent "dg_<timestamp>" value into a Google Sheets cell when any other cell in the corresponding Google Sheet row is edited.  This UNIX epoch timestamp (with "dg_" prepended) becomes the identifier of a "new" -- one that has no legacy identifier -- Digital.Grinnell or _CollectionBuilder_ object.  
supersedes: 
tags:
  - Digital.Grinnell
  - UNIX epoch
  - identifier
  - timestamp
azure:
  dir: 
  subdir: 
---  

When a "new" _Digital.Grinnell_ or _CollectionBuilder_ object is cataloged for the first time, we need to give it a universally unique `identifier`, probably as `dc:identifier` or in _CollectionBuilder_ terms, an `objectid`.  One way to do that is to introduce a Google Sheets App Script in our metadata worksheet.  The following is based on a modified form of the technique that's documented in [How To Create Static Timestamps in Google Sheets](https://www.youtube.com/watch?v=6ixt-b8T8h0).   

The aforementioned _YouTube_ video shows us how to add a Google Sheets App Script to a Google Sheet.  In our case that App Script, named `dg_timestamp`, looks like this:  

```
function onEdit(e){
  var range = e.range;
  if (range.getColumn() == 2) {
    var timestampCell = range.offset(0, -1);
    var existingID = timestampCell.getValue();
    if (!existingID | existingID.length === 0) {
      var t = new Date();
      timestampCell.setValue("dg_" + (t.getTime() - t.getMilliseconds()) / 1000);
    }
  }
}
```

This script assumes that our "timestampCell" will be in column `A`, the FIRST column, and performing an edit in column `B`, the SECOND column, will trigger the "timestampCell" to be populated with a static/permanent identifier as described above.  

## Adding and Managing the `dg_timestamp` Script

As the video says, you can add or manage an App Script by selecting the `Extensions` menu in your Google Sheet, and then select `App Script` from the drop-down menu.  

---

That's all folks... until next time (or should I say "timestamp").  :smile:
