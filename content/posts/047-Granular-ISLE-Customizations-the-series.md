---
title: "Granular ISLE Customization: Series Guidelines"
publishdate: 2019-09-27
lastmod: 2019-11-07T22:34:28-05:00
draft: false
tags:
  - granular
  - customization
  - ISLE
  - guidelines
  - gists
---

| Granular ISLE Customization |
| --- |
| This post provides guidelines for a series of posts describing [Digital.Grinnell](https://digital.grinnell.edu) customizations to [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE), in a "granular" format... one small customization at a time. |

# Using the _Granular ISLE Customization_ Posts
There are just a couple of notes regarding the subject posts that I'd like to pass along to make them more useful.

  - **Gists** - You will find a few places in this series where I generated a [gist](https://help.github.com/en/articles/creating-gists) to take the place of lengthy command output.  Instead of a long stream of text you'll find a simple [link to a gist](https://gist.github.com/McFateM/98d09fdcc29f88ac88bf7b3cbfb8324d) like this.

  - **Workstation Commands** - There are lots of places in this series where I've captured a sequence of commands  along with output from those commands in block text.  Generally speaking, after each such block you will find a **Workstation Commands** table that can be used to conveniently copy and paste the necessary commands directly into your workstation. The tables look something like this:

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/DigitalGrinnell/ISLE <br/> cd ISLE <br/> git checkout -b ld |

  - **Apache Container Commands** - Similar to `Workstation Commands`, a tabulated list of commands may appear with a heading of **Apache Container Commands**. \*Commands in such tables can be copied and pasted into your command line terminal, but ONLY after you have opened a shell into the _Apache_ container. The asterisk (\*) at the end of the table heading is there to remind you of this! See the [next section](#opening-a-shell-in-the-apache-container) of this document for additional details. These tables looks something like this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/contrib <br/> drush dl backup_migrate <br/> drush -y en backup_migrate |

## Opening a Shell in the Apache Container
This is something I find myself doing quite often during ISLE configuration, so here's a reminder of how I generally do this...
```
╭─markmcfate@ma8660 ~/Projects/public-isle ‹ruby-2.3.0› ‹ld*›
╰─$ docker exec -it isle-apache-ld bash
root@9bec4edd3964:/# cd /var/www/html
root@9bec4edd3964:/var/www/html#
```
| Workstation Commands |
| --- |
| cd ~/Projects/public-isle <br/> docker exec -it isle-apache-ld bash |

# The _Granular ISLE Customization_ Series

That's all we need in terms of guidelines.  I hope you find the series useful!  

Posts in the _Granular ISLE Customization_ series include:

| Title | Synopsis |
| --- | --- |
| [Granular ISLE Customization: Series Guidelines](https://static.grinnell.edu/blogs/McFateM/posts/047-granular-isle-customization-series-guidelines) | This document. |
| [Granular ISLE Customization: Installing IMI](https://static.grinnell.edu/blogs/McFateM/posts/048-granular-isle-customization-installing-imi) | Instructions for installing IMI, the Islandora Multi-Importer module, and a robust sample of TWIG templating. |
| [Granular ISLE Customization: Implementing IMI Hooks](https://static.grinnell.edu/blogs/McFateM/posts/049-granular-isle-customization-implementing-imi-hooks/) | Guidance to build your own IMI hook implementations to improve the Islandora Multi-
| [Granular ISLE Customization: Installing the DG Theme](https://static.grinnell.edu/blogs/McFateM/posts/052-granular-isle-customization-installing-the-dg-theme/) | Guidance to install and configure the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap) theme. |
