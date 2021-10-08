---
title: Searching This Blog Using Fuse
publishDate: 2021-09-27
lastmod: 2021-09-27T14:06:51-05:00
draft: false
tags:
  - static
  - search
  - Fuse
  - fuse.js
superseded_by: posts/113-blog-migration-details
---

A short time ago I moved this blog from _DigitalOcean_ to _Azure_, and along the way I discovered that my `search` feature wasn't working properly.  That old search mechanism used [Fuse](https://fusejs.io/), which has NO dependencies, but that old scheme used a _Hugo_ theme component that I found difficult to properly maintain.  So, as this blog was moving to _Azure_ I elected to try something a little different with _Fuse_ and found [this gist](https://gist.github.com/gtrevg/a34e0c736d358771437be05c6401e86c) to help get it done.

As of this writing, the new search is limited to just finding `tag` references, and sometimes a search will return a 404 error because of a bad path reference.  If you try to search and get the 404 error have a look at the returned URL and if it reads like `.../search/search?search-query...` then you've got one too many instances of the term `search`.  Remove that first `/search` term, including the slash in front of it, and hit return.  The search should now return valid results.

Even if it appears that `search` is working, know that I'm still working on the feature and hope to make some improvements soon, like full-text search instead of just the `tags` or keyword search you now see.  

That's all... for now.
