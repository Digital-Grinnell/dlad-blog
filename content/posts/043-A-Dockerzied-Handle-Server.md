---
title: "A Dockerized 'Handle' Server"
publishdate: 2019-09-10
lastmod: 2019-09-19T15:14:28-05:00
draft: false
tags:
  - Docker
  - HANDLE.NET
---

Today's quest... to build a new [Handle.net](http://www.handle.net) server for _Digital.Grinnell_, preferably one that is "Dockerized".  I'm going to start by forking [datacite/docker-handle](https://github.com/datacite/docker-handle), a project that looks promising, and following it along with the documentation in chapter 3 of the [HANDLE.NET (version 9) Technical Manual](http://www.handle.net/tech_manual/HN_Tech_Manual_9.pdf).  The aforementioned fork can now be found in [DigitalGrinnell/docker-handle](https://github.com/DigitalGrinnell/docker-handle).

## The _digital7_ Saga

My old friend and server (or should that be servant?), _digital7_, used to be the home of [Digital.Grinnell](https://digital.grinnell.edu) in [Islandora v7](https://islandora.ca), before [Docker](https://en.wikipedia.org/wiki/Docker_(software)) and [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) came along. It's an [Ubuntu 14.04.5 LTS](https://ubuntu.com/) server, and in addition to hosting _Digital.Grinnell_, it also used to host our _HANDLE.NET_ server.  Hmmm...

I tried valiantly to upgrade old _digital7_ from the OS on up, but failed.  In the end, _digital7_ was retired, and its IP address assigned to a new _CentOS 7_ server named _DGDocker3_.  So, I'll be making a new home for _HANDLE.NET_ services on _DGDocker1_, instead.

## Port Status

The next step in my quest was to check some ports on _DGDocker1_, so I found [**you** get signal's Port Forwarding Tester](https://www.yougetsignal.com/tools/open-ports/), entered the IP address assigned to the host and then tested the two ports that _HANDLE.NET_ demands. Rats! Neither was open, so I dispatched a help desk ticket to open them up.  About a week later... they're open.

## docker-handle

I took my fork of the aforementioned [datacite/docker-handle](https://github.com/datacite/docker-handle) for a spin on _DGDocker1_, but honestly, it looks like a train wreck. I could not fathom how to make it work since most of the _.env_ variables documented in the _README.md_ file don't seem to do anything in the configuration. :confused: I also found https://github.com/horizon-institute/handle.net-server-docker but it's a _Handle_ v8 instance, and I'm aiming for v9.

## A Quick Solution

So, on 18-Sep-2019 I set out to install a non-Dockerized _Handle_ server on _DGDocker1_. Installation followed the standard guidance found in [Technical Manual, Handle.Net Version 9](http://hdl.handle.net/20.1000/113) and my instance now lives in _/hs/handle-9.2.0_ and _/hs/svr_1_ on the _DGDocker1_ host. In order to make my _iduH_ tools work, I had to modify the _/opt/ISLE/docker-compose.yml_ file so that it contains the following additional volume bind-mount:

```
   # Next line added 19-Sep-2019 so that batch jobs for the HANDLE server at the host's /hs directory can run properly.
   - /hs:/hs
That line maps the host's /hs folder into the isle-apache-dg container as the same path, enabling Handle batch and other commands to run within the container itself.
```

After these additions I tweaked the _iduH_ command parameters found in [idu_constants.inc](https://github.com/DigitalGrinnell/idu/blob/master/idu_constants.inc), then I opened a shell into the _Apache_ container on _DGDocker1_ via `docker exec -it isle-apache-dg bash`, and did:

```
cd /var/www/html/sites/default
drush -u 1 iduH grinnell:2-5000 MODIFY; drush -u 1 iduF grinnell:2-5000 SelfTransform --reorder
# Repeat drush... for other PID ranges
```

It worked!  Note that in some instances a command of the form `drush -u 1 iduH grinnell:2-5000 CREATE` was necessary instead of "MODIFY".

And that's a ~~wrap~~ good place for a break... until I return to formally "Dockerize" this effort.  :smile:
