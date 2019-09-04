---
title: "Configuring DGDocker2"
publishdate: 2019-09-03
lastmod: 2019-09-04T15:35:08-05:00
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

Since nearly all of the containers/services running on _dgdocker2_ are broken or obsolete, I'm going to remove them all and clean up the node using this sequence as a copy/paste one-liner...
```
docker stop $(docker ps -q); docker rm -v $(docker ps -qa); docker image rm -f $(docker image ls -q); docker system prune --force;
```

## Deploying a Stand-Alone _Traefik_ Reverse-Proxy
There are at least a dozen ways to do this, and I really don't want to reinvent the wheel here, so I searched the web for some of the latest info and settled on [this post from DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-use-traefik-as-a-reverse-proxy-for-docker-containers-on-centos-7).  It's current, I like _DigitalOcean's_ approach in general, and it appears to be well-documented.

Perhaps the best of _Traefik_'s qualities is its ability to support additional services/containers using labels.  Let's roll with that.  The plan here is to turn _dgdocker2_ into the home for many _Omeka-S_ instances with the server answering to https://omeka-s.grinnell.edu.

I'm starting now with a "clean", Docker-ready node in _dgdocker2_.  From a terminal/shell opened as _root_ on _dgdocker2_ we need some preliminary stuff:

```
# Create a home on dgdocker2 for the project
mkdir -p /opt/traefik
cd /opt/traefik
nano traefik.toml
```

The _traefik.toml_ file should look like this:

```
defaultEntryPoints = ["http", "https"]

[entryPoints]
  [entryPoints.dashboard]
    address = ":8080"
    [entryPoints.dashboard.auth]
      [entryPoints.dashboard.auth.basic]
        users = ["admin:$2y$05$pJEzHJBzfoYYS7/hGAedcOP8XdsqNXE7j.LHFBVjueASOqOvvjGOy"]
  [entryPoints.http]
    address = ":80"
      [entryPoints.http.redirect]
        entryPoint = "https"
  [entryPoints.https]
    address = ":443"
      [entryPoints.https.tls]
        minVersion = "VersionTLS12"
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
          "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305",
          "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305",
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
          "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
          "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
          "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256"
         ]

[api]
entrypoint="dashboard"

[acme]
### email = "your_email@your_domain"
email = "digital@grinnell.edu"
storage = "acme.json"
entryPoint = "https"
onHostRule = true
  [acme.httpChallenge]
  entryPoint = "http"

[docker]
### domain = "your_domain"
domain = "omeka-s.grinnell.edu"
watch = true
network = "web"
```

Note:  The 11 lines, including "minVerson" and "cipherSuites" definitions, which appear in the "[entryPoints.https.tls]" section above were lifted from ["Removing Traefik's Weak Cipher Suites"](https://static.grinnell.edu/blogs/McFateM/posts/005-removing-traefik-weak-ciphers/).

```
# Clean up first!
docker stop $(docker ps -q); docker rm -v $(docker ps -qa); # docker image rm -f $(docker image ls -q); docker system prune --force;
# rm -f /opt/traefik/acme.json    # probably not necessary?
# Create the "web" network
docker network create web
# Create a home on dgdocker2 for the project... if one does not already exist
mkdir -p /opt/traefik
cd /opt/traefik
# Setup for Let's Encrypt certs
touch acme.json
chmod 600 acme.json
# Launch Traefik
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $PWD/acme.json:/acme.json \
  -p 80:80 \
  -p 443:443 \
  -l traefik.frontend.rule=Host:traefik2.grinnell.edu \
  -l traefik.port=8080 \
  --network web \
  --name traefik \
  traefik:1.7.14-alpine

```

Ok, let's see what we've got...

**Eureka!**  https://traefik2.grinnell.edu returns an _admin_ login prompt for my new _Traefik_ instance at https://traefik2.grinnell.edu/dashboard/, as promised, and it's complete with a green lock icon indicating that we have a valid TLS cert for it. Presumably this _Traefik_ will have NO weak ciphers or vulnerabilities.  _Note to self: **Test this!**_

<!--

## One More Baby Step

Now I'm going to try adding a _WhoAmI_ container to see if I can get it to respond properly at the server's canonical address, https://dgdocker2.grinnell.edu.  I'm using the guidance posted at https://docs.traefik.io/v2.0/getting-started/quick-start/ and the [Traefik Detects New Services and Creates the Route for You](https://docs.traefik.io/v2.0/getting-started/quick-start#traefik-detects-new-services-and-creates-the-route-for-you) section in particular.  Edits to _docker-compose.yml_ leave us with:

```
version: '3.2'

services:
  traefik:
    restart: unless-stopped
    image: traefik
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./traefik/traefik.toml:/etc/traefik/traefik.toml:ro
      - ./traefik/acme:/etc/traefik/acme
    ports:
     - "80:80"
     - "443:443"
     - "8080:8080"

  app:
    restart: unless-stopped
    image: nginx:latest
    labels:
      - "traefik.enable=true"
      - "traefik.port=80"
      ### - "traefik.frontend.rule=Host:127.0.0.1,my-awesome-site.dev"
      - "traefik.frontend.rule=Host:omeka-s.grinnell.edu"

  whoami:
    # A container that exposes an API to show its IP address
    image: containous/whoami
    labels:
      ### - "traefik.http.routers.whoami.rule=Host(`whoami.docker.localhost`)"
      - traefik.frontend.rule=Host:dgdocker2.grinnell.edu
```
-->

And that's a ~~wrap~~ good place for a break!  More to come, after the break, of course.  :smile:
