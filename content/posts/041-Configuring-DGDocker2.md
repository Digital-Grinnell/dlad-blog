---
title: "Configuring DGDocker2"
publishdate: 2019-09-03
lastmod: 2019-09-04T09:35:08-05:00
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

Since nearly all of the containers/services running on _dgdocker2_ are broken or obsolete, I'm going to remove them all and clean up the node using this sequence:

```
docker stop $(docker ps -q)
docker rm -v $(docker ps -qa)
docker image rm $(docker image ls -q)
docker system prune --force
```

## Deploying a Stand-Alone _Traefik_ Reverse-Proxy
There are at least a dozen ways to do this, and I really don't want to reinvent the wheel here, so I searched the web for some of the latest info and settled on [this post](https://jasonraimondi.com/posts/docker-compose-traefik-lets-encrypt/).  It's current, I like the approach, and it appears to be well-documented... complete with a working example in [this GitHub repo](https://github.com/jasonraimondi/docker-compose-traefik-example/tree/master/lets-encrypt-example).

Perhaps the best of _Traefik_'s qualities is its ability to support additional services/containers using labels.  Let's roll with that.  The plan here is to turn _dgdocker2_ into the home for many _Omeka-S_ instances with the server answering to https://omeka-s.grinnell.edu.

I'm starting now with a "clean", Docker-ready node in _dgdocker2_.  From a terminal/shell opened as _root_ on _dgdocker2_, I'll fork and clone [Jason Raimondi's example](https://github.com/jasonraimondi/docker-compose-traefik-example/tree/master/lets-encrypt-example) and make some necessary modifications.  So I forked the aforementioned repository to create https://github.com/DigitalGrinnell/docker-compose-traefik-example.  Now to clone it and get started on _dgdocker2_ as _root_, like so:

```
╭─root@dgdocker2 ~
╰─# cd /opt
╭─root@dgdocker2 /opt
╰─# git clone https://github.com/DigitalGrinnell/docker-compose-traefik-example.git
Cloning into 'docker-compose-traefik-example'...
remote: Enumerating objects: 26, done.
remote: Total 26 (delta 0), reused 0 (delta 0), pack-reused 26
Unpacking objects: 100% (26/26), done.
╭─root@dgdocker2 /opt
╰─# cd docker-compose-traefik-example
╭─root@dgdocker2 /opt/docker-compose-traefik-example ‹master›
╰─# ll
total 8.0K
drwxr-xr-x 3 root root   61 Sep  4 11:10 lets-encrypt-example
-rw-r--r-- 1 root root 1.1K Sep  4 11:10 LICENSE
-rw-r--r-- 1 root root   31 Sep  4 11:10 README.md
drwxr-xr-x 3 root root   61 Sep  4 11:10 simple-example
╭─root@dgdocker2 /opt/docker-compose-traefik-example ‹master›
╰─# cd lets-encrypt-example
╭─root@dgdocker2 /opt/docker-compose-traefik-example/lets-encrypt-example ‹master›
╰─# nano traefik/traefik.toml
```

In the _nano_ editor opened above, I modified Jason's _traefik.toml_ with new lines immediately following `###` comments as follows:

```
# traefik.toml
#
# Search this file for "YOUR_" to find the two locations you need to edit.
#
################################################################
# Global configuration
################################################################
# Log level
#
# Optional
# Default: "ERROR"
# Accepted values, in order of severity: "DEBUG", "INFO", "WARN", "ERROR", "FATAL", "PANIC"
# Messages at and above the selected level will be logged.
#
logLevel = "ERROR"

# Entrypoints to be used by frontends that do not specify any entrypoint.
# Each frontend can specify its own entrypoints.
defaultEntryPoints = ["http", "https"]
# Entrypoints, http and https
[entryPoints]
  # http should be redirected to https
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  # https is the default
  [entryPoints.https]
  address = ":443"
    [entryPoints.https.tls]

# Enable ACME (Let's Encrypt): automatic SSL
[acme]
# Email address used for registration
### email = "YOUR_EMAIL_ADDRESS"
email = "digital@grinnell.edu"
# File or key used for certificates storage.
# WARNING, if you use Traefik in Docker, you have 2 options:
#  - create a file on your host and mount it as a volume
#      storageFile = "acme.json"
#      $ docker run -v "/my/host/acme.json:acme.json" traefik
#  - mount the folder containing the file as a volume
#      storageFile = "/etc/traefik/acme/acme.json"
#      $ docker run -v "/my/host/acme:/etc/traefik/acme" traefik
storageFile = "/etc/traefik/acme/acme.json"
# Entrypoint to proxy acme challenge/apply certificates to.
# WARNING, must point to an entrypoint on port 443
entryPoint = "https"
# CA server to use
# Uncomment the line to run on the staging let's encrypt server
# Leave comment to go to prod
#caServer = "https://acme-staging.api.letsencrypt.org/directory"
# Enable on demand certificate. This will request a certificate from Let's Encrypt during the first TLS handshake for a hostname that does not yet have a certificate.
# WARNING, TLS handshakes will be slow when requesting a hostname certificate for the first time, this can leads to DoS attacks.
# WARNING, Take note that Let's Encrypt have rate limiting: https://letsencrypt.org/docs/rate-limits
onDemand = false
# Enable certificate generation on frontends Host rules. This will request a certificate from Let's Encrypt for each frontend with a Host rule.
# For example, a rule Host:test1.traefik.io,test2.traefik.io will request a certificate with main domain test1.traefik.io and SAN test2.traefik.io.
OnHostRule = true
# Use a HTTP-01 acme challenge rather than TLS-SNI-01 challenge
# Optional but recommend
  [acme.httpChallenge]
  # EntryPoint to use for the challenges.
  # Required
  entryPoint = "http"

# Enable Docker configuration backend
[docker]
# Docker server endpoint. Can be a tcp or a unix socket endpoint.
endpoint = "unix:///var/run/docker.sock"
# Default domain used.
# Can be overridden by setting the "traefik.domain" label on a container.
### domain = "YOUR_DEFAULT_DOMAIN"
domain = "omeka-s.grinnell.edu"
# Enable watch docker changes
watch = true
# Expose containers by default in traefik
# If set to false, containers that don't have `traefik.enable=true` will be ignored
exposedbydefault = false
```

Likewise, I used `nano docker-compose.yml` to edit Jason's _docker-compose.yml_ configuration file like so:

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
```

Ok, let's spin it up and see what we've got...

```
╭─root@dgdocker2 /opt/docker-compose-traefik-example/lets-encrypt-example ‹master*›
╰─# cd /opt/docker-compose-traefik-example/lets-encrypt-example
╭─root@dgdocker2 /opt/docker-compose-traefik-example/lets-encrypt-example ‹master*›
╰─# docker-compose up -d
```

And that's a ~~wrap~~ good place for a break!  More to come, after the break, of course.  :smile:
