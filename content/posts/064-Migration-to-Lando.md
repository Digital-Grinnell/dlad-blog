---
title: Migration to Lando
publishdate: 2020-02-17
lastmod: 2020-02-17T08:59:43-06:00
draft: false
tags:
  - Docksal
  - Lando
---

I have ITS tickets, for seemingly simple DNS changes, that are now more than a month old, and because of that I've taken steps to try and do some _ISLE_ staging work on one of my _DigitalOcean_ droplets, namely _summitt-services-droplet-01_. In order to accommodate that I've moved nearly all of the sites and services from that droplet to my other, _summitt-dweller-DO-docker_.  The site migration was a smooth process except for [https://Wieting.TamaToledo.com](https://wieting.tamatoledo.com). That _Drupal 8_ site has been difficult to upgrade and migrate largely because it was deployed using my old _Port-Ability_ scripts, and about a year ago I scrapped _Port-Ability_ in favor of [Docksal](https://docksal.io), but I never got around to moving that particular site to a _Docksal_ environment.  Well, now I'm finding it almost impossible to complete that migration to _Docksal_.

# The Problem with Docksal

_Docksal_ is a wonderful development environment, but I can't find an effective path from development to production when using it. _Docksal_ provides system services including a `SSH Agent`, `DNS`, and `Reverse Proxy` as documented [here](https://docs.docksal.io/core/overview/).  Those services are all manifest in a `cli` container/service which is also responsible for providing a robust set of `fin` commands.  In addition to `cli`, a typical _Docksal_ stack also provides containers for `web` and `db`, and those look a lot like what I like to deploy for _Drupal_ in production.  However, the `cli` container looks nothing like what I deploy in production, and therein lies the rub.

# The Promise of Lando

Hindsight is 20/20, so this must be the year to look back and make course corrections, right?  Had I not fallen so quickly for the speed and glitz of _Docksal_ I would have given some of its alternatives, like [Lando](https://lando.dev), a closer look.  The immediate promise of _Lando_ is that it builds, in development, a stack that looks much more like what I wish to deploy in production, and it does so by not integrating as tightly as _Docksal_ does.

# Migrating the Wieting Theatre Web Site to Lando

Another thing that I like about _Lando_ is the fact that [Jeff Geerling](https://www.jeffgeerling.com) has taken it for a spin and documented some of his experience with it in his blogs. So I have elected to begin my adventures in _Lando_ with [this post](https://www.jeffgeerling.com/blog/2018/getting-started-lando-testing-fresh-drupal-8-umami-site).

First step, on my iMac workstation, `MA8660`, is to clone the _Docksal_ work that I've done thus far:

```
╭─markmcfate@ma8660 ~/GitHub ‹ruby-2.3.0›
╰─$ git clone https://github.com/SummittDweller/wieting-docksal.git wieting-lando
Cloning into 'wieting-lando'...
remote: Enumerating objects: 1150, done.
remote: Counting objects: 100% (1150/1150), done.
remote: Compressing objects: 100% (666/666), done.
remote: Total 1150 (delta 486), reused 1132 (delta 468), pack-reused 0
Receiving objects: 100% (1150/1150), 7.24 MiB | 8.51 MiB/s, done.
Resolving deltas: 100% (486/486), done.
╭─markmcfate@ma8660 ~/GitHub ‹ruby-2.3.0›
╰─$ cd wieting-lando
╭─markmcfate@ma8660 ~/GitHub/wieting-lando ‹ruby-2.3.0› ‹master›
╰─$ lando init
[1]    6483 killed     lando init
```

Whoa, what happened there? `Traps` happened.  The software that GC employs to protect endpoints is blocking execution of `lando`.  So I've filed another ticket to get that resolved...soon, I hope.  :frowning:

And that's...frustrating.  I'll be back.  :smile:
