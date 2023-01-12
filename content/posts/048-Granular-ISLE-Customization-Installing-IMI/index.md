---
title: "Granular ISLE Customization: Installing IMI"
publishdate: 2019-09-27
lastmod: 2019-10-04T12:26:27-05:00
draft: false
tags:
  - granular
  - customization
  - ISLE
  - Islandora Multi-Importer
  - IMI
  - Twig
---

| Granular ISLE Customization |
| --- |
| This post is part of a series describing [Digital.Grinnell](https://digital.grinnell.edu/) customizations to [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE/), in a "granular" format... one small customization at a time. |
| An index of all documents in this series is included at the end of [Granular ISLE Customization: Series Guidelines](/posts/047-granular-isle-customization-series-guidelines/). |

## Goal Statement
In this "granular" post we will install *_IMI_*, the [Islandora Multi-Importer](https://github.com/mnylc/islandora_multi_importer.git) module, into an existing ISLE instance, for example: https://dg.localdomain/.

## Install the Islandora Multi-Importer (IMI)
It's important that we take this step BEFORE other customizations, otherwise the module may not install properly. The result is captured in [this gist](https://gist.github.com/McFateM/d8e7694032298e0518a88b3370872db8/).

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/mnylc/islandora_multi_importer.git <br/> chown -R islandora:www-data * <br/> cd islandora_multi_importer <br/> composer install <br/> drush -y en islandora_multi_importer <br/> |

## An Alternative IMI Installation
The commands documented above will pull the "master" branch of the canonical _IMI_ from _mnylc_, but if you'd like to take another of my features for a spin, try installing my fork (sync'd with the _mnylc_ master on 04-Oct-2019), like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git clone https://github.com/DigitalGrinnell/islandora_multi_importer.git <br/> chown -R islandora:www-data * <br/> cd islandora_multi_importer <br/>  git checkout Issue-15 <br/> composer install <br/> drush -y en islandora_multi_importer <br/> |

The feature that's unique to this fork and branch is mentioned briefly in [project "Issue" number 15](https://github.com/mnylc/islandora_multi_importer/issues/15#issuecomment-318190438/).

## Bonus: A Robust _Twig_ Template for _MODS_
In my opinion, _IMI_'s greatest strength is the way it leverages [Twig](https://twig.symfony.com/) templates to translate CSV (comma-separated value) data into viable [MODS](http://www.loc.gov/standards/mods/) metadata.  And the real beauty in _Twig_ is what you can do with it once you understand how it works.

While an exhaustive explanation of _Twig_ is beyond the scope of this post, I can provide what I believe is a very robust _Twig_ example, created specifically for _MODS_ and _IMI_ at _Grinnell College_.  This is the template that currently drives ingest into [Digital.Grinnell.edu](https://digital.grinnell.edu/).  The template includes extensive comments up-front, and the current, revision 14, version is included [in this Gist](https://gist.github.com/c88a37f116dcb71564fe4639e10af73f/).

## Installing the Template
This part is easy. To install the aforementioned _Twig_ template, or any _IMI_ template follow these simple steps:

  - Copy the entire contents of [this Gist](https://gist.github.com/c88a37f116dcb71564fe4639e10af73f/), or any suitable _Twig_ template, to your paste buffer.
  - In your web browser, visit the `/multi_importer#overlay=admin/islandora` address of your _Islandora_ instance, for example: https://dg.localdomain/multi_importer#overlay=admin/islandora/.
  - Choose `Multi Importer Twig templates` or `/multi_importer#overlay=admin/islandora/twigtemplates` in your _Islandora_ instance.
  - Choose `New Twig template` or `/multi_importer#overlay=admin/islandora/twigtemplates/create`.
  - Paste the text of your _Twig_ template into the available `Twig Template Input` window pane.
  - At the bottom of the form, enter a descriptive name for your template.  In my case the name is `Digital_Grinnell_MODS_Master.twig Revision 14`.
  - Click `Save Template`.

Your _Twig_ template is now ready for use.  Enjoy!

And that's a wrap.  Until next time...
