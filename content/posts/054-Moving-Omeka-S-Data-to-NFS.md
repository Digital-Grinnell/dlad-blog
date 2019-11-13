---
title: Moving Omeka-S Data to NFS
publishDate: 2019-11-13
lastmod: 2019-11-12T11:54:00-05:00
draft: false
emojiEnable: true
tags:
  - Omeka-S
  - NFS
---

Grinnell's dockerized version of _Omeka-S_ has been running for several weeks now, and we recently ran out of disk space for object data on the host, a _CentOS_ node we named _DGDocker2_. My posts 041, [Configuring DGDocker2](https://static.grinnell.edu/blogs/McFateM/posts/041-configuring-dgdocker2/) and 042, [My dockerized-server Config](https://static.grinnell.edu/blogs/McFateM/posts/042-my-dockerized-server-config/) address the original configuration of _DGDocker2_ in detail.

_Omeka-S_ is configured on _DGDocker2_ to reside in `/opt/omeka-s-docker`, and inside that directory is a subdirectory named `volume`.  The portions of the application stack that deliver _Omeka-S_ are configured largely in `/opt/omeka-s-docker/docker-compose.yml`, and portions of that file related to this discussion include:

```
services:
  ...
  omeka:
    ...
    volumes:
      - omeka:/var/www/html/volume
volumes:
  ...
  omeka:

```

So, there's a Docker-managed volume named `omeka` that maps into the _omeka_ container as `/var/www/html/volume`.  This `../volume` directory contains two subdirectories, `./config` and `./files`.  We are really only interested in `./files`, but because of the way things are mapped I found it prudent to deal with `/opt/omeka-s-docker/volume` itself, rather than trying to separate `./config` from `./files`.

The quick and easy solution to the necessary change in mapping involved these steps:

  - Set proper ownership and permission on `/omeka-digital` like so: `chown -R mcfatem:mcfatem /omeka-digital; chmod 755 /omeka-digital`.  
  - Copy the live data from `/opt/omeka-s-docker/volume` to a new NFS share mounted as `/omeka-digital` like so: `rsync -aruvi /opt/omeka-s-docker/volume/ /omeka-digital/ --progress`.
  - Bring the stack down using `cd /opt/omeka-s-docker; docker-compose down`.
  - Move the old directory out of the way like so: `cd /opt/omeka-s-docker; mv -f volume .out-of-the-way.volume`.
  - Create a symbolic link, as "root", using `cd /opt/omeka-s-docker; ln -s /omeka-digital/volume volume`.
  - Bring the stack back up using `cd /opt/omeka-s-docker; docker-compose up -d`.

A brief visit to https://omeka-s.grinnell.edu/s/MusicalInstruments/page/welcome and some of the associated pages seems to indicate that things are working as they should.  Once this has been confirmed it should be safe to remove `/opt/omeka-s-docker/.out-of-the-way.volume` to free up significant disk space.

And that's a wrap.  Until next time...
