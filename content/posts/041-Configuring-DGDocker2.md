---
title: "Configuring DGDocker2"
publishdate: 2019-09-03
lastmod: 2019-09-03T15:13:10-05:00
draft: false
tags:
  - Digital.Grinnell
  - Docker
  - Traefik
  - configuration
  - Omeka-S
---

My mission today is to successfully migrate the images/containers/services chronicled in [post 030, "Dockerized Omeka-S: Starting Over"](https://static.grinnell.edu/blogs/McFateM/posts/030-dockerized-omeka-s-starting-over/) to Docker-ready node _dgdocker2_ without compromising any of the services that already run there.

## Pushing WMI Omeka-S to Production on _dgdocker2_

Grinnell's _dgdocker2_ server, specifically _dgdocker2.grinnell.edu_ with an IP address of 132.161.132.143, is a Docker-ready CentOS 7 node that's currently supporting the following containers and configuration:

```
CONTAINER ID   IMAGE                          COMMAND                  CREATED        STATUS        PORTS                    NAMES
ef20d71ffea8   mcfatem/ohscribe               "./boot.sh"              6 days ago     Up 6 days     5000/tcp                 ohscribe
b525f4670cd2   mariadb:latest                 "docker-entrypoint.s…"   2 weeks ago    Up 2 weeks    3306/tcp                 omekasdocker_mariadb_1
7f107a24c204   traefik:latest                 "/traefik --docker -…"   2 weeks ago    Up 2 weeks    0.0.0.0:80->80/tcp,
                                                                                                    0.0.0.0:443->443/tcp,
                                                                                                    0.0.0.0:8080->8080/tcp   traefik_proxy
9282ab53ecc4   portainer/portainer:latest     "/portainer --admin-…"   5 weeks ago    Up 5 weeks    0.0.0.0:9000->9000/tcp   portainer
60ce06301101   dodeeric/omeka-s:latest        "docker-php-entrypoi…"   7 weeks ago    Up 7 weeks    80/tcp                   omekasdocker_omeka_1
54bd82694f3c   phpmyadmin/phpmyadmin:latest   "/docker-entrypoint.…"   2 months ago   Up 2 months   80/tcp                   omekasdocker_pma_1
0cd019c5456e   emilevauge/whoami              "/whoamI"                2 months ago   Up 2 months   80/tcp                   omekasdocker_whoami_1
7b3d4961ec21   v2tec/watchtower               "/watchtower"            2 months ago   Up 2 months                            watchtower
```

Grinnell's DNS is configured with the following addresses, and their return status as of 3-September-2019, pointed to _dgdocker2_:

  - https://textline.grinnell.edu - 404 page not found
  - https://portainer2.grinnell.edu - 404 page not found
  - https://omeka-s.grinnell.edu - Multi-Cultural Reunion 2019 home page
  - https://traefik2.grinnell.edu - 404 page not found
  - https://rootstalkx.grinnell.edu - 404 page not found
  - https://ohscribe.grinnell.edu - OHScribe home page
  - https://dgdocker2.grinnell.edu - 404 page not found

The https://omeka-s.grinnell.edu target is experimental, and soon-to-be-replaced.  Consequently, the only properly configured service on this node is _OHScribe_, and the _Traefik_ container is properly configured to serve it as well as the experimental _Omeka-S_ instance.  All of the other containers/services should be removed, and the new _Omeka-S_ of _WMI_ configured to work with the existing _Traefik_.

To stop and remove all unnecessary containers...

And that's a ~~wrap~~ good place for a break!  More to come, after the break, of course.  :smile:
