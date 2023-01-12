---
title: Updating DG's Collection Views
publishdate: 2020-03-17
lastmod: 2020-03-17T12:47:36-05:00
draft: false
tags:
  - Digital.Grinnell
  - dg7 Collection View
  - Maintenance Mode
---

[Digital.Grinnell](https://digital.grinnell.edu) employs a custom-built _Drupal_ "view" we call the _dg7 Collection View_; it's part of the code in our custom [dg7 module](https://github.com/DigitalGrinnell/dg7) where all of _Digital.Grinnell_'s hook implementations are also defined.  Experience leads me to beleive that keeping a complex _Drupal_ view in code is prudent, but overriding that code with a database copy of the view helps tremendously in terms of system performance. So, I recommend keeping the view code in the module, but that means that when significant changes are made, like the addition of a new colleciton, the code should be updated in the database to speed things up.  _Digital.Grinnell_ employs the following workflow to keep the view in code, but allow it to be selectively updated in the database as needed:

  1. Put the site into _Maintenance Mode_.  _Drupal_'s default behavior with views in code is to reload and cache views every time they are needed.  If/when the cache is cleared or expires this default process can be quite time-consuming, so it's prudent to take control. Putting the site into _Maintenance Mode_ helps in this regard because the _dg7_ module is coded to ONLY update the _dg7 Collection View_ while the site is in that mode.

  2. Visit the [admin/structure/views page](https://digital.grinnell.edu/admin/structure/views) and DELETE the existing _dg7 Collection View_ from the database.  Deleting the view triggers the system to re-populate it, something that only happens if the site is in _Maintenance Mode_.

  3. Clear all caches to complete the reset of _dg7 Collection View_.  An easy way to do this is to execute the following command on the _DGDocker1_ host:

```
docker exec -w /var/www/html/sites/default isle-apache-dg drush cc all
```
When you return to the site you should now see messages like this:

```
dg7_views_default_views has been called in MAINTENANCE MODE and dg7_collection does not exist so it will be created.

Note that you MUST alter the new dg7_Collection view in order to secure the new definitions in the database! It's easy, just edit the view and update all display titles to be empty. Do NOT delete the existing dg7_Collection view again unless you want to force an update from this code in MAINTENACE MODE!
```

  4. Force the view to refresh back into the database. Visit the [admin/structure/views page](https://digital.grinnell.edu/admin/structure/views), click `Edit` for the _dg7 Collection View_, click `Title: none`, then click `Apply (all displays)`, and finally click `Save`.  This action changes NOTHING, but it does force the view back into the database where the _dg7_ module code is overridden.

  5. Take the site out of _Maintenance Mode_.  Visit the site's [admin/config/development/maintenance page](https://digital.grinnell.edu/admin/config/development/maintenance), remove the _Maintenance Mode_ checkmark, and click `Save configuration`.

This workflow was written for the production instance of [Digital.Grinnell](https://digital.grinnell.edu), but the same can be applied to local development or staging instances of _Digital.Grinnell_ simply by changing URLs as needed.

And that's a wrap.  Until next time... :smile:
