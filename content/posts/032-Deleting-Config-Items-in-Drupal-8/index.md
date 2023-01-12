---
title: Deleting Config Items in Drupal 8
publishdate: 2019-07-30
lastmod: 2019-07-31T22:53:06-05:00
tags:
  - Drupal
  - config
  - orphan
---
None of this is my creation, but it's too valuable to forget! So kudos to [Goran Nikolovski](https://gorannikolovski.com) and [his blog post](https://gorannikolovski.com/blog/4-ways-delete-configuration-items-drupal-8).  

The problem I ran into involved the Drupal `update.php` script, and an orphaned bit of configuration data.  When I tried running `update.php` the first of 13 pending database updates kept throwing an exception telling me of a missing plugin, and that effectively killed the other 12 updates. :frowning: Well, I really didn't care that it was missing (and Drupal should not either) because the update was there to delete it, but since the update kept failing, we had ourselves an impossible loop.

The first technique in Goran's post worked for me.  Specifically, it suggested I visit the `/admin/config/development/configuration/single/export` page in my site, select `Configuration type` of `Action` in my case, then the errant `Configuration name`, and at the bottom of the screen I could now see the full path to that configuration item.  Goran's first technique then uses `drush` to wash that config item away.  In my case the command was:

```
drush config-delete system.action.auto_nodetitle_update_action
```
Bingo! This did the trick and enabled `update.php` to run without exception.

And that's a wrap.  Until next time...
