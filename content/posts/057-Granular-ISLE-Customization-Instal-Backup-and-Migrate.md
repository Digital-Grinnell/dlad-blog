---
title: "Granular ISLE Customization: Install 'Backup and Migrate'"
publishdate: 2019-11-25
lastmod: 2019-11-25T15:50:54-05:00
draft: false
tags:
  - granular
  - customization
  - ISLE
  - Backup
  - Migrate
---

| Granular ISLE Customization |
| --- |
| This post is part of a series describing [Digital.Grinnell](https://digital.grinnell.edu/) customizations to [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE/), in a "granular" format... one small customization at a time. |
| An index of all documents in this series is included at the end of [Granular ISLE Customization: Series Guidelines](https://static.grinnell.edu/blogs/McFateM/posts/047-granular-isle-customization-series-guidelines/). |

## Goal Statement
In this "granular" post we will install *_Backup and Migrate_*, a tremendous _Drupal_ module that I use extensively for backup, restoration, migration and maintenance of _Digital.Grinnell_.

## Install and Enable the _Backup and Migrate_ Module using _Drush_
_DG7_ is installed and enabled in the same manner as most _Drupal_ or _Islandora_ contrib modules, like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/contrib <br/> drush dl backup_migrate <br/> drush -y en backup_migrate |

And that's a wrap.  Until next time...
