---
title: Developing This Blog
draft: false


date: 2019-05-20T07:25:32-06:00
---

I realized today that I previously documented how to "begin" a blog like this using [Docksal](https://docksal.io) to assist, but I failed to remind myself how to make structural/programming changes to it now that it is well-established.  Since I'd like to add [BleveSearch](https://blevesearch.com/) to this blog, and similar sites, I need to make some "structural" changes, and I want to do so locally before pushing them to production.  

The process of making updates like this is basically:

  1. Open a local terminal and navigate to this project.  In my case that means `cd ~/Projects/blogs-McFateM`.
  2. If there's no `./themes` folder here I need to add one and populate it like so: `mkdir themes && cd $_; git clone https://github.com/digitalcraftsman/hugo-minimalist-theme.git`.
  3. Now, do a `fin up` to get _Docksal_ restarted.  This will provide a local address where you can access the project in a browser, but it *WILL NOT WORK!*
  4. So do `fin develop` to get it re-started properly in our _Hugo_ environment.  Just remember that your terminal/shell is running the local development copy, so you have to execute a `CTRL-c` in the terminal to terminate it.

And that’s a wrap. Until next time…
