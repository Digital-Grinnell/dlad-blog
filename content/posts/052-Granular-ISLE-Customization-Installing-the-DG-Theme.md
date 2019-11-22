---
title: "Granular ISLE Customization: Installing the DG Theme"
publishdate: 2019-11-07
lastmod: 2019-11-21T20:02:22-05:00
draft: false
tags:
  - granular
  - customization
  - ISLE
  - DG
  - theme
---

| Granular ISLE Customization |
| --- |
| This post is part of a series describing [Digital.Grinnell](https://digital.grinnell.edu) customizations to [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE), in a "granular" format... one small customization at a time. |
| An index of all documents in this series is included at the end of [Granular ISLE Customization: Series Guidelines](https://static.grinnell.edu/blogs/McFateM/posts/047-granular-isle-customizations-the-series/). |

## Goal Statement
In this "granular" post we will install _Digital.Grinnell_'s custom-built theme, namely  [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap). The experience documented here involves an existing ISLE instance created using [Building ISLE 1.3.0 (ld) for Local Development](https://static.grinnell.edu/blogs/McFateM/posts/034-building-isle-1.3.0-ld/).

## Commands
The install and config process was simply this stream of commands entered directly into the running _Apache_ container:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/themes <br/> git clone https://github.com/drupalprojects/bootstrap.git <br/> chown -R islandora:www-data * <br/> cd bootstrap <br/> git checkout 7.x-3.x <br/> drush -y en bootstrap <br/> mkdir -p /var/www/html/sites/default/themes <br/> cd /var/www/html/sites/default/themes <br/> git clone https://github.com/DigitalGrinnell/digital_grinnell_bootstrap.git <br/> chown -R islandora:www-data * <br/> cd digital_grinnell_bootstrap <br/> drush -y pm-enable digital_grinnell_bootstrap <br/> drush vset theme_default digital_grinnell_bootstrap |

## Using `git submodule` Rather Than `git clone`
If the `git clone...` commands here report errors consider changing them to `git submodule add...` commands.  Using `git clone` inside of a _Git_ repo can lead to problems down-the-line.

## Tweaking the Local Site
Success! The theme is in place and active on my [dg.localdomain](https://dg.localdomain) local site.  Just a couple more tweaks here...

I visited https://dg.localdomain/#overlay=admin/appearance/settings/digital_grinnell_bootstrap and made sure ONLY the following boxes are checked:

  - Logo
  - Shortcut Icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

The other tweak... visit https://dg.localdomain/#overlay=admin/structure/block and turn the `Search form` OFF by setting its block region to `-None-`.  Make sure you save these changes.

## It Works!
A visit to [the site](https://dg.localdomain) with a refresh showed that this worked!

And that's a wrap.  Until next time...
