---
title: "Hugo: Attachments and Bundles"
publishdate: 2023-01-12
draft: false
tags:
  - Hugo
  - attachments
  - page bundles
  - VSCode
last_modified_at: 2023-01-12 09.25 CST
---

This post was written as follow-up to my [previous post](../135-migrating-catpaw-development-to-azure/) where I implemented a custom Hugo shortcode, `attachments.html`, documented in [attachments.html](#attachmentshtml) below.  The implementation of this shortcode required a Hugo [Page Bundles](https://gohugo.io/content-management/page-bundles/) content structure and the transition to such a structure is documented below in [Page Bundles Structure](#page-bundles-structure).  

## attachments.html

This shortcode, `attachments.html`, was lifted from [Hugo Attachment shortcode](http://oostens.me/posts/hugo-attachment-shortcode/), a blog post by [Nelis Oostens](http://oostens.me/).  Successfull implementation of this shortcode one minor modification (my theme did not have a referenced partial) and conversion of my `content/posts` from individual _Markdown_ (.md) files to a to [Page Bundles Structure](#page-bundles-structure), as described below.

## Page Bundles Structure

Transitioning this blog to a _page bundles_ organizational strucuture involved running the [https://discourse.gohugo.io/t/bash-script-to-convert-hugo-content-files-to-page-bundles/9776](https://discourse.gohugo.io/t/bash-script-to-convert-hugo-content-files-to-page-bundles/9776) script which I named `page-bundles.sh`.  I was only interested in transforming the `content/posts` portion of this blog so I ran the script like so:  

```sh
cd ~/GitHub/dlad-blog/content/posts
./page-bundles.sh
```

The fact that you are able to read this post is proof that the script worked.  

The `page-bundles.sh` script is listed here:

```page-bundles.sh
for FILE in *.md
do
  # remove the last dot and subsequent chars to name the folder from the .md
  DIR="${FILE%.*}"
  mkdir -p "$DIR"
  mv "$FILE" "$DIR"
done
find ./ -iname '*.md' -execdir mv -i '{}' index.md \;
```

## PDF Creation

Before wrapping this up, it's worth mentioning that the `.pdf` attachments you see in my [previous post](../135-migrating-catpaw-development-to-azure/#attachments) were created from _Markdown_ (`.md`) files using _VSCode_.  Specifically, I installed and used the [Markdown PDF](https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf) extension for _VSCode_.  It's really cool, so I suspect you'll be seeing more "attachments" in my posts now that I have it.  

---

There will probably be more before long, but for now... that's a wrap.
