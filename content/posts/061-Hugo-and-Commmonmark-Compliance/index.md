---
title: Hugo, Goldmark and CommonMark Compliance
publishDate: 2020-02-11
lastmod: 2020-02-11T08:34:57-06:00
draft: false
tags:
  - Hugo
  - Goldmark
  - CommonMark
---

Just making a note here that [Hugo](https://gohugo.io), as of version `0.60.0`, is now using the [Goldmark](https://github.com/yuin/goldmark/) markdown rendering library, and that library is [CommonMark](https://spec.commonmark.org/) compliant. The official word, from [this document](https://gohugo.io/getting-started/configuration-markup/#goldmark) states that:

{{% original %}}
Goldmark is from Hugo 0.60 the default library used for Markdown. It’s fast, it’s CommonMark compliant and it’s very flexible. Note that the feature set of Goldmark vs Blackfriday isn’t the same; you gain a lot but also lose some, but we will work to bridge any gap in the upcoming Hugo versions.
{{% /original %}}

The immediate impact of this change, in this blog and similar sites, is that line-break tags like `<br/>` inside table cells are no longer rendered as line breaks.  The quick fix, bypassing [Goldmark](https://github.com/yuin/goldmark/), is to add the following to the blog's `config.toml` file:

```
## Override default markdown engine to preserve BlackFriday handling.
## See https://gohugo.io/getting-started/configuration-markup/#goldmark
[markup]
  defaultMarkdownHandler = "blackfriday"
```
