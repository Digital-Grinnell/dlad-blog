---
title: CanonifyURLs in Hugo
publishdate: 2019-08-06
lastmod: 2019-08-06T21:25:23-05:00
draft: false
tags:
  - Hugo
  - canonifyURLs
---

I've been seeing a lot of `.URL will be deprecated...` warnings in my Hugo compilations lately, and just now figured out a slick replacement for it: `canonifyURLs = true`. The documentation for this parameter says...

{{% original %}}
By default, all relative URLs encountered in the input are left unmodified, e.g. /css/foo.css would stay as /css/foo.css. The canonifyURLs field in your site config has a default value of false.

By setting canonifyURLs to true, all relative URLs would instead be canonicalized using baseURL. For example, assuming you have baseURL = https://example.com/, the relative URL /css/foo.css would be turned into the absolute URL https://example.com/css/foo.css.
{{% /original %}}

Turning this parameter on in my personal blog allowed me to make the following code change work:

  - Old code: `<a href="{{ .URL }}index.xml"><img src="{{ .URL }}/img/rss.png" class="rss-icon" /></a>`
  - New code: `<a href="index.xml"><img src="/img/rss.png" class="rss-icon" /></a>`

Note that the to-be-deprecated `{{ .URL }}` references are gone!

And that's a wrap.  Until next time...
