---
title: Moving Omeka-S Data to NFS
publishDate: 2019-11-13
lastmod: 2019-11-15T16:38:20-05:00
draft: false
emojiEnable: true
tags:
  - Omeka-S
  - NFS
  - backup
---

Grinnell's dockerized version of _Omeka-S_ has been running for several weeks now, and we recently ran out of disk space for object data on the host, a _CentOS_ node we named _DGDocker2_. My posts 041, [Configuring DGDocker2](/posts/041-configuring-dgdocker2/) and 042, [My dockerized-server Config](/posts/042-my-dockerized-server-config/) address the original configuration of _DGDocker2_ in detail.

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

The quick and easy solution to change this configuration **did NOT work!**  Consequently, I'm hiding that work from public view...until a long-term solution is found.  

<!--
The necessary change in mapping involved these steps:

  - Set proper ownership and permission on `/omeka-digital` like so: `chown -R mcfatem:mcfatem /omeka-digital; chmod 755 /omeka-digital`.  
  - Copy the live data from `/opt/omeka-s-docker/volume` to a new NFS share mounted as `/omeka-digital` like so: `rsync -aruvi /opt/omeka-s-docker/volume/ /omeka-digital/ --progress`.
  - Bring the stack down using `cd /opt/omeka-s-docker; docker-compose down`.
  - Move the old directory out of the way like so: `cd /opt/omeka-s-docker; mv -f volume .out-of-the-way.volume`.
  - Create a symbolic link, as "root", using `cd /opt/omeka-s-docker; ln -s /omeka-digital/volume volume`.
  - Bring the stack back up using `cd /opt/omeka-s-docker; docker-compose up -d`.
-->

Since the quick-fix didn't work, we are going to extend the original system, or "root", disk and supplement the stack with some automated "backup" operations to capture any changes made so that we can eventually roll those into a properly configured and dockerized  _Omeka-S_.  The backup operations involve the following:

In the _mariadb_ container, a new script at `/daily-script.sh` with the following contents:

```
#!/bin/bash
## This is daily-script.sh for the Omeka-S "mariadb" container.
/usr/bin/mysqldump -u root --password=${MYSQL_ROOT_PASSWORD} omeka > omeka-database-backup.sql
```

On the _DGDocker2_ host, there's a new script at `/opt/omeka-s-docker/daily-backup.sh` with contents of:

```
#!/bin/bash
mkdir -p /omeka-digital/temporary
docker exec mariadb ./daily-script.sh       
docker cp mariadb:/omeka-database-backup.sql /omeka-digital/temporary/omeka-database-backup.sql
docker cp omeka:/var/www/html/modules /omeka-digital/temporary
docker cp omeka:/var/www/html/themes /omeka-digital/temporary
tar -zcvPf "/omeka-digital/backups/$(date '+%Y-%m-%d').tar.gz" /omeka-digital/temporary --remove-files
```

And finally, there's a new "root" _crontab_ entry on _DGDocker2_ of:

```
0 18 * * * /opt/omeka-s-docker/daily-backup.sh
```

The result of all this should be a daily backup of about 17MB saved on the NFS share at `/omeka-digital/backups/<today>.tar.gz`, where `<today>` is the current date in a format like `2019-11-15`.  For example, a test backup run earlier today produced:

```
╭─root@dgdocker2 /omeka-digital/backups
╰─# ll
total 17M
-rw-r--r--. 1 root root 17M Nov 15 14:44 2019-11-15.tar.gz
```

<!--
A brief visit to https://omeka-s.grinnell.edu/s/MusicalInstruments/page/welcome and some of the associated pages seems to indicate that things are working as they should.  Once this has been confirmed it should be safe to remove `/opt/omeka-s-docker/.out-of-the-way.volume` to free up significant disk space.
-->

And that's a wrap.  Until next time...
