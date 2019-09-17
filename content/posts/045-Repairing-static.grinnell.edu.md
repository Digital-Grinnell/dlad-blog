---
title: Repairing Static.Grinnell.edu
publishdate: 2019-09-17
lastmod: 2019-09-17T11:54:52-05:00
draft: false
tags:
  - static
  - Traefik
  - docker-compose
---

This morning, Tuesday, September 17, 2019, I awoke to find our https://static.grinnell.edu server, and all of the services on it, unreachable via the web.  I managed to open a shell on the host and found that the server was up-and-running as expected, but a quick `docker ps` command indicated that one of the key services on the server, namely _Traefik_, had stopped and then failed to restart, repeatedly.  _Traefik_ is the service that's responsible for routing web traffic on the _static_ host. No wonder the web sites were not responding!  

The confusing part of this mystery was the stream of messages that appeared in the _Traefik_ logs. When I did a `docker logs traefik` command I got nothing back, presumably because _Traefik_ was not running, it couldn't "start" at all.  So I logged in as _root_ (using `sudo su`) then cleared away all _Docker_ config and restarted the stack using:

```
docker stop $(docker ps -q); docker rm -v $(docker ps -qa); docker image rm $(docker image ls -q); docker system prune --force
cd /opt
docker-compose up
```

Note the omission of the usual "-d" flag on the `docker-compose up` command, that bypasses the usual "detached" mode and makes the _docker-compose_ command run interactively, with log data returning directly to the console.  Well, that didn't show me much, except for the same, repeated error message (with different timestamps, of course):

```
2019/09/17 13:36:34 command traefik error: invalid node traefik: no child
```

In response to this I assumed that maybe something on the server was outdated, so I did:

```
apt-get update
apt-get upgrade
reboot
```

This did indeed update most of the packages running on the server, not a bad thing, but it did not solve the problem.  So, I started to tear into the _/opt/docker-compose.yml_ file.  I replaced a couple of variables there with safe but hard-coded strings and started it again.  No change.  I did a search for any wisdom/guidance on the web and found none, so I focused on the _Traefik_ command itself, and saw nothing obvious there.

It was then that I remembered reading a couple of weeks ago that _Traefik_ was about to release a new major version, moving from v1.x to v2.0.  Hmmmm, I wondered then in maybe I was pulling a new image version, one in which the command syntax had changed?  Yep, that seems to have been the case!  So, my old _/opt/docker-compose.yml_ file included this specification:

```yaml
services:

  proxy:
    container_name: traefik_proxy
    image: traefik
    command: >-
      --docker --logLevel=INFO \ ...
```

I took a look at all of the current _Traefik_ image tags in [Docker Hub](https://hub.docker.com/_/traefik) and sure enough, it looked like a "default" image specification like `image: traefik` would now pull a v2.x copy, but my process was written for v1.x.  So I changed this bit of _/opt/docker-compose.yml_ to read as follows:

```yaml
services:

  proxy:
    container_name: traefik_proxy
    image: traefik:alpine
    command: >-
      --docker --logLevel=INFO \ ...
```

I cleaned up the existing stack and restarted it with:

```
docker stop $(docker ps -q); docker rm -v $(docker ps -qa); docker image rm $(docker image ls -q); docker system prune --force; docker network prune --force
cd /opt
docker-compose up -d
```

It worked!  The addition of the `:alpine` version specification for the image did the trick, forcing the command to pull a v1.x copy of _Traefik_.

This change did alter the network config a bit though. After the restart the bridge network created here was named _opt\_webgateway_, not _traefik\_webgateway_, as it was before. Consequently, to restart the supported services on this host I ran these command sequences.

To restart the _static.grinnell.edu_ landing page site (https://static.grinnell.edu):

```bash
NAME=static-landing-page
HOST=static.grinnell.edu
IMAGE="mcfatem/static-landing"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=opt_webgateway \
    --label "traefik.frontend.rule=Host:${HOST}" \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network opt_webgateway \
    --restart always \
    ${IMAGE}
```

To restart the _VAF_ site (https://vaf.grinnell.edu):

```bash
NAME=vaf
HOST=vaf.grinnell.edu
IMAGE="mcfatem/vaf"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=opt_webgateway \
    --label "traefik.frontend.rule=Host:${HOST}" \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network opt_webgateway \
    --restart always \
    ${IMAGE}
```

To restart the _VAF-Kiosk_ site (https://vaf-kiosk.grinnell.edu):

```bash
╰─$ NAME=vaf-kiosk
HOST=vaf-kiosk.grinnell.edu
IMAGE="mcfatem/vaf-kiosk"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=opt_webgateway \
    --label "traefik.frontend.rule=Host:${HOST}" \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network opt_webgateway \
    --restart always \
    ${IMAGE}
```

To restart this blog, site (https://static.grinnell.edu/blogs/McFateM):

```bash
NAME=blogs-mcfatem
HOST=static.grinnell.edu
IMAGE="mcfatem/blogs-mcfatem"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=opt_webgateway \
    --label "traefik.frontend.rule=Host:${HOST};PathPrefixStrip:/blogs/McFateM" \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network opt_webgateway \
    --restart always \
    ${IMAGE}
```

And all is as it should be now at [static.grinnell.edu](https://static.grinnell.edu), so that's a wrap... until next time.  :smile:
