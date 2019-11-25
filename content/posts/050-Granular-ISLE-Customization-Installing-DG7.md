---
title: "Granular ISLE Customization: Installing DG7"
publishdate: 2019-10-09
lastmod: 2019-11-25T15:39:50-05:00
draft: false
tags:
  - granular
  - customization
  - ISLE
  - DG7
  - hooks
---

| Warning! |
| --- |
| The DG7 module contains code with numerous dependencies, and the most sinister of these is a Grinnell-specific version of the Solr schema. Do NOT attempt to use this module early in a stack-building process, nor outside the Digital.Grinnell environment. |


| Granular ISLE Customization |
| --- |
| This post is part of a series describing [Digital.Grinnell](https://digital.grinnell.edu) customizations to [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE), in a "granular" format... one small customization at a time. |
| An index of all documents in this series is included at the end of [Granular ISLE Customization: Series Guidelines](https://static.grinnell.edu/blogs/McFateM/posts/047-granular-isle-customization-series-guidelines). |

## Goal Statement
In this "granular" post we will install *_DG7_*, the [Digital Grinnell v7](https://github.com/DigitalGrinnell/dg7.git) module, into an existing ISLE instance created using the [DigitalGrinnell/public-isle](https://github.com/DigitalGrinnell/public-isle) project.

*_DG7_* is home to numerous custom _PHP_ functions and Drupal hook implementations designed specifically for [Digital.Grinnell](https://digital.grinnell.edu/).

## Install and Enable the DG7 Module
_DG7_ is installed and enabled in the same manner as most _Drupal_ or _Islandora_ contrib modules, like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/DigitalGrinnell/dg7.git <br/> chown -R islandora:www-data * <br/> drush -y en dg7 |

And that's a wrap.  Until next time...
