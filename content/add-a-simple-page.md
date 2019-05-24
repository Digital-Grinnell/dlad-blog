---
title: Help!
date: 2019-05-23T10:58:27-07:00
aliases:
  - help
  - add-this-page
  - add-a-page-to-the-site
type: page
layout: single
---

![hugo logo](/img/hugo-logo.png)

<hr/>
Looking to add a simple, single, new page to this site?  Have a look at this content in the site's `./content/add-a-simple-page.md` file.

Pay particular attention to the `front matter` where the `type` and `layout` are declared, as well as a list of `aliases:`:

```
aliases:
  - help
  - add-this-page
  - add-a-page-to-the-site
type: page
layout: single
```

But note that all of these `aliases` re-direct to the canonical URL which takes its name, `./add-a-simple-page`, from the name of this markdown document, `./content/add-a-simple-page.md`.

<hr/>
