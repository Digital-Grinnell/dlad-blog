---
title: "Configuring DGDocker2"
publishdate: 2019-09-03
lastmod: 2019-09-03T16:20:05-05:00
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
╭─root@dgdocker2 ~
╰─# docker ps
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                                                              NAMES
ef20d71ffea8        mcfatem/ohscribe               "./boot.sh"              6 days ago          Up 6 days           5000/tcp                                                           ohscribe
b525f4670cd2        mariadb:latest                 "docker-entrypoint.s…"   2 weeks ago         Up 2 weeks          3306/tcp                                                           omekasdocker_mariadb_1
7f107a24c204        traefik:latest                 "/traefik --docker -…"   2 weeks ago         Up 2 weeks          0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:8080->8080/tcp   traefik_proxy
9282ab53ecc4        portainer/portainer:latest     "/portainer --admin-…"   5 weeks ago         Up 5 weeks          0.0.0.0:9000->9000/tcp                                             portainer
60ce06301101        dodeeric/omeka-s:latest        "docker-php-entrypoi…"   7 weeks ago         Up 7 weeks          80/tcp                                                             omekasdocker_omeka_1
54bd82694f3c        phpmyadmin/phpmyadmin:latest   "/docker-entrypoint.…"   2 months ago        Up 2 months         80/tcp                                                             omekasdocker_pma_1
0cd019c5456e        emilevauge/whoami              "/whoamI"                2 months ago        Up 2 months         80/tcp                                                             omekasdocker_whoami_1
7b3d4961ec21        v2tec/watchtower               "/watchtower"            2 months ago        Up 2 months                                                                            watchtower
```
<!--
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
-->

Grinnell's DNS is configured with the following addresses pointed to _dgdocker2_:

  - https://textline.grinnell.edu - 404 page not found
  - https://portainer2.grinnell.edu - 404 page not found
  - https://omeka-s.grinnell.edu - Multi-Cultural Reunion 2019 home page
  - https://traefik2.grinnell.edu - 404 page not found
  - https://rootstalkx.grinnell.edu - 404 page not found
  - https://ohscribe.grinnell.edu - OHScribe home page
  - https://dgdocker2.grinnell.edu - 404 page not found

The information following each address is the status or page returned when I tried opening each on 3-September-2019.

The https://omeka-s.grinnell.edu target is experimental, and soon-to-be-replaced with our new _Omeka-S_.  Consequently, the only properly configured service on this node is _OHScribe_, and the _Traefik_ container is properly configured to serve it as well as the experimental _Omeka-S_ instance.  All of the other containers/services should be removed, and the new _Omeka-S_ with _WMI_ configured to work with the existing _Traefik_.

Since nearly all of the containers/services running on _dgdocker2_ are broken or obsolete, I'm going to remove them all and clean up the node using this sequence:
```
docker stop $(docker ps -q)
docker rm -v $(docker ps -qa)
docker image rm $(docker image ls -q)
docker system prune --force
```
## Deploying a Stand-Alone _Traefik_ Reverse-Proxy
There are at least a dozen ways to do this, and I really don't want to reinvent the wheel here, so I searched the web for some of the latest info and settled on [this post](https://jonnev.se/traefik-with-docker-and-lets-encrypt/).  It's current, I like the approach, and it appears to be well-documented.  

Perhaps the best of _Traefik_'s qualities is its ability to support additional services/containers using labels.  Let's roll with that.

I'm starting now with a "clean", Docker-ready node in _dgdocker2_.  From a terminal/shell opened as _root_ on _dgdocker2_, I follow [Jon Neverland's](https://jonnev.se/) advice like so:

```
docker network create web
mkdir -p /opt/traefik
touch /opt/traefik/docker-compose.yml
touch /opt/traefik/acme.json && chmod 600 /opt/traefik/acme.json
touch /opt/traefik/traefik.toml
nano /opt/traefik/docker-compose.yml

```

In the _nano_ editor opened above, I created a _docker-compose.yml_ that matches what Jon specified, with a couple of notable exceptions that appear on lines immediately following `###` comments below...

```
version: '2'

services:
  proxy:
    ### image: traefik:v1.7.12-alpine
    image: traefik:alpine
    command: --configFile=/traefik.toml
    restart: unless-stopped
    networks:
      - web
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/traefik/traefik.toml:/traefik.toml
      - /opt/traefik/acme.json:/acme.json
    # REMOVE this section if you don't want the dashboard/API
    labels:
      - "traefik.enable=true"
      ### - "traefik.frontend.rule=Host:example.com"
      - "traefik.frontend.rule=Host:traefik2.grinnell.edu"
      - "traefik.port=8080"

networks:
  web:
    external: true
```

Likewise, I used `nano /opt/traefik/traefik.toml` to create a new _/opt/traefik/traefik.toml_ configuration file using Jon's guidance, again with just a couple of changes...

```
# Change this if needed
logLevel = "ERROR"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
    address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
    address = ":443"
  [entryPoints.https.tls]

# REMOVE this section if you don't want the dashboard/API
[api]
entryPoint = "api"
dashboard = true

[retry]

[docker]
endpoint = "unix:///var/run/docker.sock"
### domain = "mydomain"
domain = "grinnell.edu"
watch = true
# I prefer to expose my containers explicitly
exposedbydefault = false

[acme]
### email = "myemail"
email = "digital@grinnell.edu"
storage = "acme.json"
entryPoint = "https"
OnHostRule = true
[acme.httpChallenge]
entryPoint = "http"
```

Ok, let's spin it up and see what we've got...

```
cd /opt/traefik/
docker-compose up -d
```

And that's a ~~wrap~~ good place for a break!  More to come, after the break, of course.  :smile:
