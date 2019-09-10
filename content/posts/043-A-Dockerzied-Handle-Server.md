---
title: "A Dockerized 'Handle' Server"
publishdate: 2019-09-10
lastmod: 2019-09-10T13:59:54-05:00
draft: false
tags:
  - Docker
  - HANDLE.NET
---

Today's quest... to build a new [Handle.net](http://www.handle.net) server for _Digital.Grinnell_, preferably one that is "Dockerized".  I'm going to start by forking [datacite/docker-handle](https://github.com/datacite/docker-handle), a project that looks promising, and following it along with the documentation in chapter 3 of the [HANDLE.NET (version 9) Technical Manual](http://www.handle.net/tech_manual/HN_Tech_Manual_9.pdf).  The aforementioned fork can now be found in [DigitalGrinnell/docker-handle](https://github.com/DigitalGrinnell/docker-handle).

## The _digital7_ Saga

My old friend and server (or should that be servant?), _digital7_, used to be the home of [Digital.Grinnell](https://digital.grinnell.edu) in [Islandora v7](https://islandora.ca), before [Docker](https://en.wikipedia.org/wiki/Docker_(software)) and [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) came along. It's an [Ubuntu 14.04.5 LTS](https://ubuntu.com/) server, and in addition to hosting _Digital.Grinnell_, it also used to host our _HANDLE.NET_ server.  Hmmm...

Opening server ports around here is not too difficult, but sometimes it can take ...forever. Presumably, good ol' _digital7_ already has all the right ports open for _HANDLE.NET_.  Hmmm...  I wonder if I can do an in-place upgrade of _digital7_ to _Ubuntu 18.04 LTS_, add _Docker_, and make it a home for _HANDLE.NET_ again?  Worth a shot I suppose; I hate to see ANYTHING go to waste!

## Port Status

The next step in my quest was to check some ports on ol' _digital7_, so I found [**you** get signal's Port Forwarding Tester](https://www.yougetsignal.com/tools/open-ports/), entered the IP address assigned to _digital7_, and then tested the two ports that _HANDLE.NET_ demands. Woot! The necessary ports are OPEN!  Note that I also checked these ports on a couple other servers and confirmed that they are NOT open. _digital7_'s destiny is at-hand!


And that's a ~~wrap~~ good place for a break... until I return, shortly.  :smile:

<!---
This post picks up from where [Configuring DGDocker2](https://static.grinnell.edu/blogs/McFateM/posts/041-configuring-dgdocker2) left off. In it I will establish a workflow to setup a "Dockerized" server complete with _Traefik_, _Portainer_, and _Who Am I_. It should be relatively easy to add additional non-static services to any server that is initially configured using this package.  For "static" servers have a look at post [008 docker-bootstrap Workflow ](https://static.grinnell.edu/blogs/McFateM/posts/008-docker-bootstrap-workflow/).

## Capture As a Project

Picking up from the end of [Configuring DGDocker2](https://static.grinnell.edu/blogs/McFateM/posts/041-configuring-dgdocker2), my first step on the _dgdocker2_ server was to move everything into a single subdirectory of _/opt_; I called the new directory _dockerized-server_, like so:

```
mkdir -p /opt/dockerized-server
mv -f /opt/traefik /opt/dockerized-server/traefik
mv -f /opt/portainer /opt/dockerized-server/portainer
mv -f /opt/whoami /opt/dockerized-server/whoami
```

Then, I built a new _/opt/dockerized-server/docker-compose.yml_ file to launch _Traefik_, _Portainer_, and _WhoAmI_.

```
version: "3"

#### docker-compose up -d

services:

  traefik:
    image: traefik:1.7.14-alpine
    command: --configFile=/traefik.toml
    container_name: traefik
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /opt/dockerized-server/data/traefik.toml:/traefik.toml
      - /opt/dockerized-server/data/acme.json:/acme.json
    networks:
      - web
    labels:
      - traefik.enable=true
      - "traefik.frontend.rule=Host:traefik2.grinnell.edu"
#      - "traefik.frontend.rule=PathPrefixStrip:/traefik"
#      - "traefik.frontend.redirect.regex=^(.*)/traefik$$"
#      - "traefik.frontend.redirect.replacement=$$1/traefik/"
#      - "traefik.frontend.rule=PathPrefix:/traefik;ReplacePathRegex: ^/traefik/(.*) /$$1"
      - traefik.port=8080

  portainer:
    image: portainer/portainer
    container_name: portainer
    command: --admin-password "$$2y$$05$$pJEzHJBzfoYYS7/hGAedcOP8XdsqNXE7j.LHFBVjueASOqOvvjGOy" -H unix:///var/run/docker.sock
    # command: -H unix:///var/run/docker.sock --no-auth
    networks:
      - web
      - internal
    ports:
      - "9010:9000"     ## Remapped to avoid conflicts on systems/servers with portainer already running.
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer-data:/data
    labels:
      - traefik.port=9000
      - traefik.docker.network=web
      - traefik.enable=true
      - "traefik.frontend.rule=PathPrefixStrip:/portainer"
      - "traefik.frontend.redirect.regex=^(.*)/portainer$$"
      - "traefik.frontend.redirect.replacement=$$1/portainer/"
      - "traefik.frontend.rule=PathPrefix:/portainer;ReplacePathRegex: ^/portainer/(.*) /$$1"

  whoami:
    image: emilevauge/whoami
    labels:
      - "traefik.enable=true"
      - "traefik.frontend.rule=Host:omeka-s.grinnell.edu"
      - "traefik.frontend.passHostHeader=true"
      - "traefik.frontend.headers.SSLRedirect=true"
    networks:
      - web
      - internal

networks:
  web:
    external: true
  internal:
    external: false

volumes:
  portainer-data:

```

### Use the _Let's Encrypt_ Staging Server

To avoid additional rate-limit issues with _Let's Encrypt_, I'm going to switch to using their "staging" server.  That requires the addition of this snippet to our _/opt/dockerized-server/traefik/traefik.toml_ file:

```
# CA server to use
# Uncomment the line to run on the staging Let's Encrypt server
# Leave comment to go to prod
#
# Optional
#
caServer = "https://acme-staging.api.letsencrypt.org/directory"
```

## A Fresh Start

Now, all that's required to spin up the new server with the aforementioned parts, in this case on _dgdocker2_, is a command sequence like this:

```
# Clean up first!
docker stop $(docker ps -q); docker rm -v $(docker ps -qa); docker image rm -f $(docker image ls -q); docker system prune --force;
# Navigate into the project
cd /opt/dockerized-server
# Launch
docker network create web
docker-compose --log-level DEBUG up -d

```

## A Quick Test

Since the above command sequence produced no errors, it's time to test what we have. The expectation is that our three services should now be running on _dgdocker2_, and they should respond in any web browser at the addresses shown here:

  - _Traefik_ dashboard - https://traefik2.grinnell.edu
  - _Portainer_ dashboard - https://omeka-s.grinnell.edu/portainer
  - _Who Am I_ info dump - https://omeka-s.grinnell.edu

**Confirmed!**  All of the above are working properly, albeit with invalid/temporary certs (due to _Let's Encrypt_ rate limiting).

## Pushing to GitHub

No project is complete these days without a _GitHub_ component (or something very similar).  So, my next step was to create a new _GitHub_ repository at https://github.com/DigitalGrinnell/dockerized-server, and push the contents of my _dgdocker2:/opt/dockerized-server_ directory to it, like so:

```
git init
git add -A
git commit -m "Initial commit"
git remote add origin https://github.com/McFateM/dockerized-server.git
git push -u origin master
```

## Back to [Configuring DGDocker2](https://static.grinnell.edu/blogs/McFateM/posts/041-configuring-dgdocker2)

At this point you might return to [Configuring DGDocker2](https://static.grinnell.edu/blogs/McFateM/posts/041-configuring-dgdocker2#back-to-omeka-s-configuration) where I'll finally add _Omeka-S_ to _dgdocker2_.

And that's a wrap... until next time.  :smile:
-->
