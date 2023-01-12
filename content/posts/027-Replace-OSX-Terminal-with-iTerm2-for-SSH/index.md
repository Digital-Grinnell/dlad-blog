---
title: Replace OSX Terminal with iTerm2 for SSH
date: 2019-07-22
draft: false
emoji: true
tags:
    - iTerm2
    - ssh
---

My memory isn't what it used to be, but I have this blog. :smile: So when I realized that my primary work machine, an iMac, had not been configured with _iTerm2_ as its default terminal for `ssh`, I went looking for the solution...again.  Found it [here](https://www.iterm2.com/faq.html)!  

The trick is to open _iTerm2_ and follow these two simple steps...

{{% original %}}
Q: How do I set iTerm2 as the handler for ssh:// links?

A: Two steps:

  1. Create a new profile called "ssh". In the General tab, select the Command: button and enter $$ as the command.
  2. In Preferences->Profiles->General, select "ssh" for "Select URL Schemes...."
{{% /original %}}

And that's a wrap.  Until next time...
