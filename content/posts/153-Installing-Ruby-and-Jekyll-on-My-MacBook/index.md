---
title: "Installing Ruby and Jekyll on My MacBook" 
publishDate: 2025-02-12T19:38:20-06:00
last_modified_at: 2025-02-12T20:20:04
draft: false
description: "Spent the evening installing Ruby and Jekyll on my MacBook and don't want to forget how."
supersedes: 
tags:
  - Ruby
  - Jekyll
  - CollectionBuilder
azure:
  dir: 
  subdir: 
---  

What I like most about [Hugo](gohugo.io) over [Jekyll](https://jekyllrb.com/) is the simple install process that Hugo provides.  It's just an executable package and available in [Homebrew](https://brew.sh/).  Jekyll, on the other hand, is based on Ruby so it requires a working Ruby environment to function, and that can be a real pain in the @$$.  

My Intel MacBook, like all Macs, comes with a pre-installed and insufficent Ruby that must be kept, but also overridden with a newer version.  This is an all too common problem with Macs and built-in tools.  

Fortunately, I found my Ruby and Jekyll install solution documented at [Jekyll on macOS](https://jekyllrb.com/docs/installation/macos/).  

After the Ruby and Jekyll install I had to `bundle install --path vendor/bundle` in order to resume my quest to get Jekyll working.  Yup, this is way too involved.  Time for a Hugo version of `CollectionBuilder`?  Perhaps.  
