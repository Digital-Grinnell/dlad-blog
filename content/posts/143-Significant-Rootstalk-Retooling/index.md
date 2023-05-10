---
title: Significant Rootstalk Retooling 
publishDate: 2023-05-08T09:44:16-05:00
last_modified_at: 2023-05-08T15:48:34
draft: false
description: Major changes to the _Rootstalk_ theme and its responsive behavior.
tags:
  - Rootstalk
  - Azure
  - Lightbi
azure:
  dir: 
  subdir: 
---  

# Critical Info

The changes outlined in this post introduce a new theme, [Lightbi](https://themes.gohugo.io/themes/lightbi-hugo/), for _Rootstalk_, as well as a new project repository and dev deployment of the site as an _Azure Static Web App_.   Those critical details are:  

  - Project Repository - https://github.com/Digital-Grinnell/rootstalk-with-lightbi.  This new repo effectively replaces https://github.com/Digital-Grinnell/rootstalk which is being archived.  
  - Development Deployment - https://victorious-ground-0e1427110.3.azurestaticapps.net/ is the new deployment from the `main` branch of https://github.com/Digital-Grinnell/rootstalk-with-lightbi.  

## Also...

To reduce costs I've already eliminated the old deployment of the [old `main` branch](https://github.com/Digital-Grinnell/rootstalk) to [https://icy-tree-020380010.azurestaticapps.net/](https://icy-tree-020380010.azurestaticapps.net/). With these changes the test and evaluation (staging) deployment of the project's `develop` branch as an _Azure App Service_ at [https://thankful-flower-0a2308810.1.azurestaticapps.net/](https://thankful-flower-0a2308810.1.azurestaticapps.net/) is also going away.    

All of these _Azure_ development changes are reflected in the [new project's README.md](https://github.com/Digital-Grinnell/rootstalk-with-lightbi#readme) file.  

# RootstalkZen is No Longer Responsive

The theme that was originally created for _Rootstalk_, namely _RootstalkZen_, was intended to be responsive, and it probably was at one time. Unfortuantely, _RootstalkZen_ was created and implemented just as the COVID 19 pandemic was advancing around the world, and that forced the student who created it to leave the Grinnell College campus (along with everyone else) much earlier than planned.  Subsequently, the theme became part of _Rootstalk_ without a lot of documentation or collaboration.  Before long the theme got modified to the point where it was no longer properly responsive.  Steps were taken to try and mitigate that "bad" behavior, but the issue was never adequately addressed, until now (May, 2023). 

# Matomo Analytics

Matomo analytics collected for https://rootstalk.grinnell.edu, the production instance of _Rootstalk_, during the month of April 2023 (see https://analytics.summittservices.com/index.php?module=CoreHome&action=index&date=last7&period=range&idSite=15#?period=range&date=2023-04-01,2023-04-30&category=Dashboard_Dashboard&subcategory=1) show that about 37% (77) of the 206 site visits were made from a smartphone or similar, small device.  That percentage was deemed high enough to warrant taking steps to correct the errant responsive behavior.  

# The _Lightbi_ Theme

I used the _Command-Option-M_ hotkey in Firefox to toggle Responsive Design Mode controls allowing me to evaluate differnt web pages in various media formats.  I browsed through demos of the [complete list of Hugo themes](https://themes.gohugo.io/) looking for a responsive theme that included the 3-column layout that is feature of _Rootstalk_ we wish to keep.  I tested several themes including [Mediumish](https://themes.gohugo.io/themes/mediumish-gohugo-theme/), [Blist](https://themes.gohugo.io/themes/blist-hugo-theme/), and [Hugo W3 Simple](https://themes.gohugo.io/themes/hugo-w3-simple/) before settling on [Lightbi](https://themes.gohugo.io/themes/lightbi-hugo/) and its live demo at https://lightbi-hugo-theme.netlify.app/.  

_Lightbi_ is relatively simple utilizing `.css` rather than `.scss` and it provides a single point of customization in its `./static/css/main.css` file.  I started by overriding a number of the theme's example site (`./themes/lightbi/exampleSite`) template files.  The overrides are in subdirectories of `./layouts` and I tried to be generous with comments included in those files.  

# Search is Also Broken

In addtion to poor responsive behavior _Rootstalk_ using the _RootstalkZen_ search feature also appeared to be broken.  It was also noted that having "Search" hidden away in the menu was not conducive to making it easily accessible.

## Implementing Pagefind

Not long ago I took steps to add [Pagefind](https://pagefind.app/) search to my [personal blog](https://blog.summittdweller.com/glad-i-found-pagefind/) and it works nicely!  So, I'm going to try and implement the same for _Rootstalk_ beginning the process with the guidance shared by [Bryce Wray](https://www.brycewray.com/about/) in his [Pagefind is quite a find for site search](https://www.brycewray.com/posts/2022/07/pagefind-quite-find-site-search/) post.  

---

That's all folks... for now.  


