---
title: "Debugging PHP in ISLE: a Kludge"
date: 2019-07-19
draft: false
---

In an earlier [post](https://static.grinnell.edu/blogs/McFateM/posts/021-rebuilding-isle-ld/) I chronicle the exhaustive steps taken to create a "debuggable" local/development instance of Digital.Grinnell that behaves exactly like the [real thing](https://digital.grinnell.edu), except with a much smaller, portable _FEDORA_ repository under it.  I'm claiming success on that front, but there is one glaring kludge in the process that I have yet to work out.

### The Kludge

So, my debugging of an _ISLE_ stack involves the coordinated configuration and engagement of [XDebug](https://xdebug.org/) inside the _Apache_ container, and [PHPStorm](https://www.jetbrains.com/phpstorm/), along with persistence of the stack's PHP codebase... and therein lies the rub.

The purpose of my local instance was to verify that all of the latest stack improvements work properly in the _Digital.Grinnell_ environment, so naturally I built a stack using all of the latest code; not at all difficult in _ISLE_. However, since the codebase is assembled, it can't easily be mapped or mounted for persistence, at least not initially since mounting it from the host suggests that it must exist BEFORE the stack is assembled. Just to be clear, a persistent mount of the code is __critical__ for _PHPStorm_, since the code on the host is used to edit, set breakpoints, and a slew of other typical "debug" activities.

For reference, the code I'm interested in debugging lies in the _Apache_ container on the `/var/www/html/sites/all/modules` path.  The "override" technique I'm using here is essentially what's suggested/documented in https://docs.docker.com/compose/extends/.

My approach to this so far is to:

  1. Build and launch the stack without mapping anything to `/var/www/html/...`.  This allows _ISLE_ to assemble the latest copy of each component.
  2. After verifying that the stack works, use `docker cp` on the host to copy the new code from the _Apache_ container back to the host, like so:

    - `cd ~/Projects/ISLE; docker cp isle-apache-ld:/var/www/html ./persistent/html`

  3. Now, alter the `docker-compose.override.yml` file to include all of the necessary debug configuration bits (see [this post](https://static.grinnell.edu/blogs/McFateM/posts/023-debugging-isle-ld-in-phpstorm/) for additional details).
  4. Build and launch _ISLE_ again using `docker-compose up -d`, just like before.  The difference is that with `./persistent/html` now mapped into the container, _PHPStorm_ debugging will work as it should.

In my opinion, `Step 2  +  Step 3  =  kludge`.  The question is...

  **How can I get around this and still build a pristine _ISLE_ for both evaluation AND debugging?**  

And that's a wrap.  Until next time...
