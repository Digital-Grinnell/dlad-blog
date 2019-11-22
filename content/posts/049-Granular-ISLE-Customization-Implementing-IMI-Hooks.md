---
title: "Granular ISLE Customization: Implementing IMI Hooks"
publishdate: 2019-09-29
lastmod: 2019-11-21T20:38:30-05:00
draft: false
tags:
  - granular
  - customization
  - ISLE
  - Islandora Multi-Importer
  - IMI
  - hook_form_alter
  - islandora_multi_importer_form
  - hook_islandora_multi_importer_remote_file_get
---

| Granular ISLE Customization |
| --- |
| This post is part of a series describing [Digital.Grinnell](https://digital.grinnell.edu) customizations to [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE), in a "granular" format... one small customization at a time. |
| An index of all documents in this series is included at the end of [Granular ISLE Customization: Series Guidelines](https://static.grinnell.edu/blogs/McFateM/posts/047-granular-isle-customization-series-guidelines). |

## Goal Statement

In this "granular" post I'll introduce two customizations to IMI that implement and engage _Drupal_ "hook" functions, namely:

  - hook_islandora_multi_importer_remote_file_get(), and
  - hook_form_islandora_multi_importer_form_alter().

## Drupal 7 Hooks

See [Understanding the hook system for Drupal modules](https://www.drupal.org/docs/7/creating-custom-modules/understanding-the-hook-system-for-drupal-modules) to better understand what _Drupal v7_ hook functions are, and how they work. If you would like additional assistance with "hooks" do not hesitate to contact the author of this post using [this email link](mailto:digital@grinnell.edu?subject=Implementing IMI Hooks).

## My Implementation Details

Both of these hook implementations reside in my [dg7 custom module](https://github.com/DigitalGrinnell/dg7), a module designed exclusively to hold custom code, mostly hook implementations, for _Digital.Grinnell_ in _Islandora v7_.

### hook_islandora_multi_importer_remote_file_get

The code I've built for this hook implementation can be seen in [this gist](https://gist.github.com/SummittDweller/22c85f834380ce4794cb5caa200f6408).

### hook_form_islandora_multi_importer_form_alter

The code I've built for this hook implementation can be seen in [this gist](https://gist.github.com/SummittDweller/f9e623c3638be03d4ccf3ab881840a53).

And that's a wrap.  Until next time...
