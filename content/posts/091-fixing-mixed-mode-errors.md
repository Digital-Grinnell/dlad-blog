---
title: Fixing 'Mixed Content' Errors
publishDate: 2020-09-11
lastmod: 2020-10-05T09:22:52-05:00
draft: false
tags:
  - mixed content
  - mixed mode
  - error
  - JavaScript
  - .htaccess
---

Last evening, just before the [World Champion Kansas City Chiefs](https://en.wikipedia.org/wiki/Kansas_City_Chiefs) kicked off the NFL's 2020-21 season (I hope the season is healthy all the way into 2021), I attempted to update all the _Drupal_ contrib modules, and core, in my new [local instance of ISLE](https://dg.localdomain) as chronicled in the `Next Steps` chapter of [ISLE Local Migration Customization](https://static.grinnell.edu/blogs/McFateM/posts/090-isle-local-migration-customization/). Ultimately that update process left me with a host of incorrect owner/group/permissions issues in the _Drupal_ code, and I was able to remedy those in short order. But that left me with lots of remaining '[mixed content](https://developers.google.com/web/fundamentals/security/prevent-mixed-content/what-is-mixed-content)', or 'mixed mode', errors.

## What's a 'Mixed Content' Error?

ISLE, and virtually everything I do on the web these days is run in `https`, that is to say that all my web sites and apps are accessible via `https://subdomain.domain` style references, where the `s` in `https` stands for "secure". It is vitally important! So a "mixed content" error is one that generally is exposed in a message like this:

```
Blocked loading mixed active content "http://dg.localdomain/sites/default/files/css/css_lQaZfjVpwP_oGNqdtWCSpJT1EMqXdMiU84ekLLxQnc4.css"
```

Note that there's NO `s` at the end of `http` in that message. Essentially, this means that the offending CSS, in this particular case, is coded to use an `http://` reference to a resource, but our process and browser are expecting "secure" communications and use of `https` throughout.  That condition is what I have come to call a "mixed mode" error, also commonly referred to as a "mixed content" condition.

## Not My First Rodeo

I have encountered and corrected "mixed content" errors like this before, but only in some of my [Hugo](https://gohugo.io) web sites, until now. The rather clumsy corrections I made in the _Hugo_ instances didn't seem likely to work with ISLE and _Drupal_, so I was at a loss and getting frustrated that such a seemingly simple thing had brought my new ISLE instance to its knees.

## My Heroes: Noah Smith, Born-Digital, and the ICG

Fortunately, when I get frustrated by such things I commonly turn to my esteemed colleagues in the [Islandora Collaboration Group (ICG)](https://islandora-collaboration-group.github.io/icg_information/). In this instance I posted a question to the group's _Slack_ workspace and the [#isle-support](https://icg-chat.slack.com/archives/CG6HZRWQM) channel. My dear friend [Noah Smith](https://www.linkedin.com/in/noahwsmith/), from [Born-Digital (BD)](https://born-digital.com/), saved the day with a very quick, concise, and elegant solution!

It seems my update to _Drupal_ core included changes to my main `.htaccess` file, and apparently those changes removed one critical statement. The wisdom that Noah shared with me was this:

{{% original %}}
this should be in there to force HTTPS

  `SetEnvIf X-Forwarded-Proto https HTTPS=on`
{{% /original %}}

I added that line to the end of `/var/www/html/.htaccess` in my _Apache_ container and revisited [https://dg.localdomain](https://dg.localdomain)... and it worked perfectly!  Kudos and eternal gratitude to Noah and all my heroes at BD and the ICG!

## Born Digital's Script

Noah related to me that at Born Digital they routinely run the following script.

```
grep -ri 'SetEnvIf X-Forwarded-Proto https HTTPS=on' web/.htaccess || echo \"SetEnvIf X-Forwarded-Proto https HTTPS=on\" | tee -a web/.htaccess
```

And that's a :smiley: wrap.  Until next time...
