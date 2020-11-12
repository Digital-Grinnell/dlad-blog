---
title: "Collaborating on Hugo Site Development"
publishDate: 2020-11-12
lastmod: 2020-11-12T15:39:56-06:00
draft: false
tags:
  - Hugo
  - local development
  - git
  - Atom
  - Rootstalk
---

This post will instruct the reader to install necessary tools and engage the workflow I now use to develop and maintain a handful of _Hugo_ static websites. The list of sites now includes both professional, those owned and operated by [Grinnell College](https://grinnell.edu), as well as "personal" sites that I develop, maintain and host myself.

## Professional Sites
These include:

  - [Rootstalk](https://rootstalk.grinnell.edu),
  - [This Blog](https://static.grinnell.edu/blogs/McFateM),
  - [The Static.Grinnell.edu Landing Page](https://static.grinnell.edu), and
  - [VAF](https://vaf.grinnell.edu)

{{% box %}}
The detailed information provided in this blog post involves _Rootstalk_, but the concepts apply equally to all of the professional and personal sites I've listed.
{{% /box %}}

## Personal Sites
These include:

  - [The SummittDweller.com Landing Page](https://summittdweller.com),
  - [My Personal Blog](https://summittdweller.com/blogs/mark), and
  - [The Compass Rose Band](https://compassroseband.net/)

## Local Development
This section briefly describes all that is necessary to collaborate effectively on the development and maintenance of [Rootstalk](https://rootstalk.grinnell.edu) from your OS X workstation, presumably a Mac desktop or laptop.

### Required Software
The workflow which follows will require you to install, or update, the following software packages:

| Software | How to Install |
| --- | --- |
| git | Follow the `Homebrew` instructions found at [https://git-scm.com/download/mac](https://git-scm.com/download/mac) |
| atom | See [https://flight-manual.atom.io/getting-started/sections/installing-atom/](https://flight-manual.atom.io/getting-started/sections/installing-atom/) |
| hugo | Assuming you used `Homebrew` to install `git`, follow [https://gohugo.io/getting-started/installing/#homebrew-macos](https://gohugo.io/getting-started/installing/#homebrew-macos) to install _Hugo_. |

### Usual Workflow
It is recommended that you clone this repository to an OS X workstation where [git](https://git-scm.com), [Atom](https://atom.io), and [Hugo](https://gohugo.io) are installed and running in an up-to-date versions.

My typical workflow for local development is:

```
cd ~/GitHub/
git clone https://github.com/McFateM/rootstalk-static --recursive
cd rootstalk-static
git checkout -b <new-branch-name>
atom .
hugo server
```

### atom .
The `atom .` command opens the project in my [Atom](https://atom.io) editor which provides many tools and shortcuts to speed development and maintenance. [Atom Basics](https://flight-manual.atom.io/getting-started/sections/atom-basics/) is well worth reading to get you up-to-speed with the powerful editor you now have at your disposal.

### hugo server
The `hugo server` command compiles and launches a local instance of the site and provides a link, usually [http://localhost:1313](http://localhost:1313/), to that site if there are no errors.  This local site will respond immediately to any changes made and saved in _Atom_.

<hr/>

And that's a wrap.  Until next time...
