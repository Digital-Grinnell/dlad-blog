---
title: Mounting //STORAGE for IMI Ingest in Digital.Grinnell
publishDate: 2019-07-22
lastmod: 2020-11-12T08:30:43-06:00
draft: false
emoji: true
tags:
    - Islandora Multi-Importer
    - IMI
    - Digital.Grinnell
    - CIFS Mount
    - ISLE
    - DG7
---

Claiming another small victory today! Why? Well, the _Digital.Grinnell_ instance of [IMI (Islandora Multi-Importer) module](https://github.com/DigitalGrinnell/islandora_multi_importer) is customized so that choosing "\*local" as an object ingest source invokes a hook function I created in our [DG7](https://github.com/DigitalGrinnell/dg7) module.  That hook enables _IMI_ to "find" named files/content (things like PDFs, images, etc.) in the _Grinnell College_ `//STORAGE` server.  `//STORAGE` can be mounted as a [CIFS (Common Internet File System)](https://www.techopedia.com/definition/1867/common-internet-file-system-cifs) and used to drive ingest **if** the right package/drivers are made available to _Islandora_. That can be a little tricky in _ISLE_, but it's manageable.

My process for providing CIFS access to `//STORAGE` and for mounting the objects went like this:

  1. Some time ago my colleagues and I created a directory on the server named `//STORAGE/MEDIADB/DGIngest`.  It is password protected, as is all of `//STORAGE`, and URL-accessible.
  2. The aforementioned _IMI_ 'hook' in `DG7` is programmed to find content in a "local" directory named `/mnt/storage`.  The code is such that it can find a named file within ANY path subordinate to this directory. So...
  3. Today I opened a terminal to my _ISLE_ production host, `DGDocker1.Grinnell.edu`, and subsequently opened a terminal into its _Apache_ container like so: `docker exec -it isle-apache-dg bash`.
  4. Inside the _Aapache_ container terminal I executed the following, as "root", to install a `CIFS` package: `apt-get update; apt install -y cifs-utils`.  This was a success and need not be repeated unless I ever have to recreate the _Apache_ container.
  5. Still in the _Apache_ container terminal I mounted the target share using: `mount -t cifs -o username=mcfatem //storage.grinnell.edu/MEDIADB/DGIngest /mnt/storage`.  I was subsequently prompted for my password and provided it.
  6. Eureka! It worked. My subsequent _IMI_ ingests were able to successfully find content stored in the aforementioned directory and its subordinates.

And that's a wrap.  Until next time...
