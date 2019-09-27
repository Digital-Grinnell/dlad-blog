---
title: "Granular ISLE Customization: Installing IMI"
publishdate: 2019-09-27
lastmod: 2019-09-27T09:44:06-05:00
draft: false
tags:
  - granular
  - customization
  - ISLE
  - Islandora Multi-Importer
  - IMI
---

| Granular ISLE Customization |
| --- |
| This post is part of a series describing [Digital.Grinnell](https://digital.grinnell.edu) customizations to [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE), in a "granular" format... one small customization at a time. |

Posts in the _Granular ISLE Customiazation_ series include:

| Title | Synopsis |
| --- | --- |
| [Granular ISLE Customization: Series Guidelines](https://static.grinnell.edu/blogs/McFateM/posts/047-granular-isle-customization-series-guidelines) | This document. |
| [Granular ISLE Customization: Installing IMI](https://static.grinnell.edu/blogs/McFateM/posts/048-granular-isle-customization-installing-imi) | Instructions for installing IMI, the Islandora Multi-Importer module. |

## Goal Statement
In this "granular" post we will install *_IMI_*, the [Islandora Multi-Importer](https://github.com/mnylc/islandora_multi_importer.git) module, into an existing ISLE instance created using the [DigitalGrinnell/public-isle](https://github.com/DigitalGrinnell/public-isle) project.

## Install the Islandora Multi-Importer (IMI)
It's important that we take this step BEFORE other customizations, otherwise the module may not install properly. The result is captured in [this gist](https://gist.github.com/McFateM/d8e7694032298e0518a88b3370872db8).

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/mnylc/islandora_multi_importer.git <br/> chown -R islandora:www-data * <br/> cd islandora_multi_importer <br/> composer install <br/> drush -y en islandora_multi_importer <br/> |

And that's a wrap.  Until next time...
