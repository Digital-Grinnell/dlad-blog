---
title: Awesome Hugo Resource - Config Variables Summary
publishdate: 2019-07-08
lastmod: 2019-11-07T22:34:28-05:00
draft: false
tags:
  - Hugo
  - config
  - BlackFriday
---

I'm working remotely from a desk on the 3rd floor of the MSOE (Milwaukee School of Engineering) this morning and just ran into a problem with this blog... some of my single and double quotes are rendered as "curly quotes" so I can't effectively copy and paste them into a command line.  While searching for a fix I found an [awesome Hugo resource](https://gohugobrasil.netlify.com/getting-started/configuration/).  It lists, among other things, ALL of Hugo's standard configuration variables!

The settings I'm most interested in right now are part of _BlackFriday_, Hugo's markdown rendering engine.  I'm setting them in `config.toml` with a section like this:

```
[blackfriday]
  smartypants = false
  hrefTargetBlank = true
```  

And that's a wrap.  Until next time...
