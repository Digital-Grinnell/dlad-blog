---
title: "Configuring DGDocker2"
publishdate: 2019-09-03
lastmod: 2019-09-11T10:53:22-05:00
draft: false
tags:
  - Docker
  - Traefik
  - Portainer
  - Omeka-S
  - traefik.frontend.rule
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

The https://omeka-s.grinnell.edu on _dgdocker2_ is experimental (at least it was in August 2019) and soon-to-be-replaced with our new _Omeka-S_.  Consequently, the only properly configured service on this node is _OHScribe_, and the _Traefik_ container is properly configured to serve it as well as the experimental _Omeka-S_ instance.  All of the other containers/services should be removed, and the new _Omeka-S_ with _WMI_ configured to work with the existing _Traefik_.

Since nearly all of the containers/services running on _dgdocker2_ are broken or obsolete, I'm going to remove them all and clean up the node using this sequence as a copy/paste one-liner...
```
docker stop $(docker ps -q); docker rm -v $(docker ps -qa); docker image rm -f $(docker image ls -q); docker system prune --force;
```

## Deploying a Stand-Alone _Traefik_ Reverse-Proxy

There are at least a dozen ways to do this, and I really don't want to reinvent the wheel here, so I searched the web for some of the latest info and settled on [this post from DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-use-traefik-as-a-reverse-proxy-for-docker-containers-on-centos-7).  It's current, I like _DigitalOcean's_ approach in general, and it appears to be well-documented.

Perhaps the best of _Traefik_'s qualities is its ability to support additional services/containers using labels.  Let's roll with that.  The plan here is to turn _dgdocker2_ into the home for many _Omeka-S_ instances with the server answering to https://omeka-s.grinnell.edu.

## One-Time/Preliminary Stuff

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

# CA server to use
# Uncomment the line to run on the staging Let's Encrypt server
# Leave comment to go to prod
#
# Optional
#
caServer = "https://acme-staging.api.letsencrypt.org/directory"

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

The "preliminary" steps above, and the creation of the _traefik.toml_ file should NOT be repeated, they are good-to-go!

## Launching _Traefik_

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

**Eureka!**  https://traefik2.grinnell.edu returns an _admin_ login prompt for my new _Traefik_ instance at https://traefik2.grinnell.edu/dashboard/, as promised, and it's complete with a green lock icon indicating that we have a valid TLS cert for it. Presumably this _Traefik_ will have NO weak ciphers or vulnerabilities.  _Note to self: **Test this assumption!**_

## Let's Add _Portainer_

In addition to the _Treafik_ dashboard, I like having [Portainer](https://www.portainer.io) available to help with stack management too.  So, let's add that using _docker-compose_ and an appropriately modified version of the guidance provided in [Step 3 - Registering Containers with Traefik](https://www.digitalocean.com/community/tutorials/how-to-use-traefik-as-a-reverse-proxy-for-docker-containers-on-centos-7#step-3-registering-containers-with-traefik).

The aforementioned guidance wants us to create a new project directory (optional: we could use the _/opt/traefik_ directory we already have) and populate it with a _docker-compose.yml_ file with contents like this:

```
version: "3"

networks:            # This "networks" section is key.  "web" refers to our already-running Docker network
  web:
    external: true
  internal:
    external: false

services:
  blog:
    image: wordpress:4.9.8-apache
    environment:
      WORDPRESS_DB_PASSWORD:
    labels:
      - traefik.backend=blog
      - traefik.frontend.rule=Host:blog.your_domain
      - traefik.docker.network=web
      - traefik.port=80
    networks:
      - internal
      - web
    depends_on:
      - mysql
  mysql:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD:
    networks:
      - internal
    labels:
      - traefik.enable=false
  adminer:
    image: adminer:4.6.3-standalone
    labels:
      - traefik.backend=adminer
      - traefik.frontend.rule=Host:db-admin.your_domain
      - traefik.docker.network=web
      - traefik.port=8080
    networks:
      - internal
      - web
    depends_on:
      - mysql
```

The [Portainer](https://www.portainer.io) configuration that I like to use was derived from the _docker-compose.demo.yml_ file in the [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) project, and it typically looks something like this:

```
version: "3"

#### docker-compose up -d

networks:
  web:
    external: true    ## Connect to the existing "web" network!
  internal:
    external: false

services:
  portainer2:     ## Renamed to avoid conflicts on systems/servers with portainer already running.
    image: portainer/portainer
    container_name: portainer2
    command: -H unix:///var/run/docker.sock --no-auth   ## Swap this out with an auth challenge for security!
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
      - traefik.docker.network=web     ## Another critical reference to the "web" network
      - traefik.enable=true
      - "traefik.frontend.rule=Host:portainer2.grinnell.edu;"

volumes:
  portainer-data:
```

I built this content into a new _/opt/portainer/docker-compose.yml_ file and subsequently launched _Portainer_ like so:

```
cd /opt/portainer
docker-compose up -d
```

Visiting https://portainer2.grinnell.edu in my browser shows that it works and has a valid TLS cert too!

## Securing _Portainer_ Auth

The previous outcome is great, but there are at least 3 issues that need to be dealt with.  The first issue is _Portainer_ authentication.  My initial spin of _Portainer_, above, is an "unprotected" instance.  Anyone can currently visit https://portainer2.grinnell.edu and see what the stack looks like there.  Not good.  The culprit is the last line shown in this snippet from our _docker-compose.yml_ file:

```
services:
  portainer2:
    ...
    command: -H unix:///var/run/docker.sock --no-auth  
```

The remedy is to preserve the indentation, that's critical in a .yml file, but change that line to read:

```
    command: --admin-password "$$2y$$05$$pJEzHJBzfoYYS7/hGAedcOP8XdsqNXE7j.LHFBVjueASOqOvvjGOy" -H unix:///var/run/docker.sock
```

The hash following "--admin-password" is one I generated for my own use with a `htpasswd -nb admin...` command as documented in [Step 1 — Configuring and Running Traefik](https://www.digitalocean.com/community/tutorials/how-to-use-traefik-as-a-reverse-proxy-for-docker-containers-on-centos-7#step-1-configuring-and-running-traefik).  Important: Note that in this instance every single dollar sign ($) is DOUBLED and the hash appears in double quotes!

Visiting https://portainer2.grinnell.edu again and this time the _Portainer_ interface is behind an authentication login pop-up.  Nice!

## Switching to Subdirectory Addressing

Now we have https://traefik2.grinnell.edu and https://portainer2.grinnell.edu both working properly on _dgdocker2_ in what I call a "sub-second-top" domain name structure. I so named this structure because it follows the convention documented in [The Parts of a URL: A Short & Sweet Guide](https://blog.hubspot.com/marketing/parts-url).  That blog post identifies the parts of a URL as:

  `scheme`://`subdomain`.`second-level`.`top-level`/`subdirectory`

In case you didn't pick up on it, the "2" at the end of each subdomain reflects the fact that the server, or host, is named _dgdocker**2**_.

While these addresses are fine, they require considerable coordination with the folks who manage our DNS names; I enlisted their help months ago to "create" the two addresses we now have. To avoid having to coordinate every change I'd like to change things up and identify this server, and the services that run on it, to the world in a form like:

  - https://omeka-s.grinnell.edu/something

This implies that _Traefik_ should respond at https://omeka-s.grinnell.edu/traefik, and _Portainer_ at https://omeka-s.grinnell.edu/portainer.  Likewise, our first _Omeka-S_ site, _World Music Instruments_, or _WMI_, should respond at https://omeka-s.grinnell.edu/wmi.

I've already asked our DNS managers to make https://omeka-s.grinnell.edu resolve to our _dgdocker2_ host, so all that's necessary now is a change in some of our _Traefik_ labels to specify a different URL structure.  Specifically, we need to change the expression in our  _docker-compose.yml_ "traefik.frontend.rule" label from this:

    - "traefik.frontend.rule=Host:portainer2.grinnell.edu;"

...to this set of configuration labels:

    - "traefik.frontend.rule=PathPrefixStrip:/portainer"
    - "traefik.frontend.redirect.regex=^(.*)/portainer$$"
    - "traefik.frontend.redirect.replacement=$$1/portainer/"
    - "traefik.frontend.rule=PathPrefix:/portainer;ReplacePathRegex: ^/portainer/(.*) /$$1"

This nice example was taken verbatim from [Using labels in docker-compose.yml](https://docs.traefik.io/user-guide/examples#using-labels-in-docker-compose-yml).  After editing these changes into _/opt/portainer/docker-compose.yml_ I did a new `cd /opt/portainer; docker-compose up -d` and...

Now, visiting https://omeka-s.grinnell.edu/portainer brings my authentication-protected _Portainer_ interface up as planned.  However, my TLS cert for this domain is not valid yet.  Hmmm, wonder why that is?  In any case... this is progress!  

## Moving _Traefik_ to a Subdirectory

I'm going to make the same kind of changes for _Traefik_ now, but this time the modifications are to the `docker run...` command that I use to launch it.  Some trial, and lots of errors, lead me to this new `docker run...` command syntax:

```
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $PWD/acme.json:/acme.json \
  -p 80:80 \
  -p 443:443 \
  -l traefik.frontend.rule=PathPrefixStrip:/traefik \
  -l traefik.frontend.redirect.regex='^(.*)/traefik$' \
  -l traefik.frontend.redirect.replacement=$1/traefik/ \
  -l traefik.port=8080 \
  --network web \
  --name traefik \
  traefik:1.7.14-alpine
```

Unfortunately, just like _Portainer_, my new _Traefik_ address failed to get a valid TLS cert.  :frowning:  

## Who Am I

Everything on the _dgdocker2_ server responds to a "subdirectory" address now and there's nothing registered at https://omeka-s.grinnell.edu.  To help eliminate the possibility that this is a problem I'm going to try adding a [WhoAmI](https://en.wikipedia.org/wiki/Whoami) service, at the aforementioned address, using the configuration documented in [this simple and straightforward repo](https://github.com/lukasnellen/dc-whoami).

```
# Create a home on dgdocker2 for the project... if one does not already exist
cd /opt
git clone https://github.com/lukasnellen/dc-whoami.git whoami
cd /opt/whoami
# Edit the docker-compose.yml file as needed
nano docker-compose.yml    # see completed edits below
```

Continuing after edits to _/opt/whoami/docker-compose.yml_...

```
docker-compose --log-level DEBUG up -d
```

Now, if I visit https://omeka-s.grinnell.edu I can see that the _WhoAmI_ is working, but again, it does not have a valid cert.  :frowning:

## Investigating Invalid Certs

In an attempt to determine why my certs are not valid, I found [Debugging Let's Encrypt Errors, Sometimes It's Not Your Fault](https://nickjanetakis.com/blog/debugging-lets-encrypt-errors-sometimes-its-not-your-fault). From my workstation I tried some of the suggestions in the post and got these results:

```
╭─mark@Marks-Mac-Mini ~/Projects/blogs-McFateM ‹master*›
╰─$ host omeka-s.grinnell.edu
omeka-s.grinnell.edu has address 132.161.132.143
╭─mark@Marks-Mac-Mini ~/Projects/blogs-McFateM ‹master*›
╰─$ host omeka-s.grinnell.edu 8.8.8.8
Using domain server:
Name: 8.8.8.8
Address: 8.8.8.8#53
Aliases:

omeka-s.grinnell.edu has address 132.161.132.143
╭─mark@Marks-Mac-Mini ~/Projects/blogs-McFateM ‹master*›
╰─$ curl -k https://omeka-s.grinnell.edu
Hostname: 67c6f570dc5b
IP: 127.0.0.1
IP: 192.168.80.3
IP: 192.168.96.2
GET / HTTP/1.1
Host: omeka-s.grinnell.edu
User-Agent: curl/7.54.0
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 173.18.136.80
X-Forwarded-Host: omeka-s.grinnell.edu
X-Forwarded-Port: 443
X-Forwarded-Proto: https
X-Forwarded-Server: 34e5bc377410
X-Real-Ip: 173.18.136.80
```

These results make me believe that our DNS entries are NOT the problem.  That leaves me believing that I've probably hit a _Let's Encrypt_ rate limit.  :frowning:  So, moving on, I'm going to accept the invalid certs and just try to get _Omeka-S_ up and running.

## Who Am I

That didn't help with the invalid certs issue. So, now I'm thinking the problem here is that nothing is registered at https://omeka-s.grinnell.edu; everything lives in subdirectory paths "below" that subdomain.  Based on that hunch, I'm going to try adding a [WhoAmI](https://en.wikipedia.org/wiki/Whoami) service, at the aforementioned address, using the configuration documented in [this simple and straightforward repo](https://github.com/lukasnellen/dc-whoami).

```
# Create a home on dgdocker2 for the project... if one does not already exist
cd /opt
git clone https://github.com/lukasnellen/dc-whoami.git whoami
cd /opt/whoami
# Edit the docker-compose.yml file as needed
nano docker-compose.yml    # see completed edits below
```

Continuing after edits to _/opt/whoami/docker-compose.yml_...

```
docker-compose --log-level DEBUG up -d
```

Now, if I visit https://omeka-s.grinnell.edu I can see that the _WhoAmI_ is working, but again, it does not have a valid cert.

## Capture As a Project

I like the direction this server setup has taken, apart from the invalid certs issue :frowning:, so I'm taking steps to formally "capture" this setup. I will chronicle that process in [My dockerized-server Config](https://static.grinnell.edu/blogs/McFateM/posts/042-my-dockerized-server-config/).

## Back to _Omeka-S_ Configuration

Having wrapped up [My dockerized-server Config](https://static.grinnell.edu/blogs/McFateM/posts/042-my-dockerized-server-config/), I'm back to finally get _Omeka-S_ configured on _dgdocker2_.  Unfortunately, while configuring this final spin of _Omeka-S_ I ran short on time and failed to document every step.  However, the outcome is working nicely at _dgdocker2:/opt_ and is captured in a new _GitHub_ repo at [McFateM/omeka-s-dgdocker2](https://github.com/McFateM/omeka-s-dgdocker2).

This repo includes:

  - A _dockerized-server_ component where _Traefik_, _Portainer_ and _Who Am I_ are configured;
  - A _solr_ component _Solr_ is configured;
  - An _omeka-s-docker_ component where _Omeka-S_, _MariaDB_, and _PHPMyAdmin_ (PMA) are configured;
  - A _docker-reset.sh_ script that can be used to reset the host's _Docker_; and
  - A _launch-stack.sh_ script that can be used to reset _Docker_ and then re-start the entire stack.

## Persistence

As currently configured, the stack maintains persistent _Omeka_ site data in a _Docker_ volume (NOT a "bind mount", but a named volume managed by _Docker_). There is a comment line in the _docker-reset.sh_ that can be enabled to wipe the aforementioned volume clean; use it with extreme caution!  There's also a comment line in _omeka-s-docker/docker-compose.yml_ that can be enabled to re-initialize the _omeka_ database with a backup of the original _World Music Instruments_ site on server _omeka1_.  

## Launch and Addressing

I did a `git clone https://github.com/DigitalGrinnell/omeka-s-dgdocker2 /opt` and then `source /opt/launch-stack.sh` from a _root_ terminal/shell on _dgdocker2_. The result is this working set of services and addresses:

| Service | Address | Note |
| --- | --- | --- |
| _Traefik_ dashboard | https://traefik2.grinnell.edu | Requires authentication |
| _Portainer_ dashboard | https://omeka-s.grinnell.edu/portainer/  | Requires authentication |
| _Who Am I_ | https://omeka-s.grinnell.edu/who-am-i |   |
| _Solr_ administration | https://portainer2.grinnell.edu | Temporary. Requires authentication |
| _MariaDB_ administration | None | See ./pma/ below |
| _PHPMyAdmin_ | https://omeka-s.grinnell.edu/pma/ | Trailing slash is REQUIRED |
| _Omeka-S_ | https://omeka-s.grinnell.edu |   |

## Addressing Update

Today, 11-Sep-2019, I got word that my DNS requests for subdomain names _solr2.grinnell.edu_ and _pma2.grinnell.edu_ were completed.  So this morning I made necessary changes to _dgdocker2:/opt/omeka-s-docker/docker-compose.yml_ and did a new `docker-compose up -d` in that directory.  It worked, and I didn't even have to take the stack down and restart it!

So, we now have this updated, and final, addressing scheme:

| Service | Address | Note |
| --- | --- | --- |
| _Traefik_ dashboard | https://traefik2.grinnell.edu | Requires authentication |
| _Portainer_ dashboard | https://omeka-s.grinnell.edu/portainer/  | Requires authentication |
| _Who Am I_ | https://omeka-s.grinnell.edu/who-am-i |   |
| _Solr_ administration | https://solr2.grinnell.edu | No longer temporary |
| _MariaDB_ administration | None | See _pma2.grinnell.edu_ below |
| _PHPMyAdmin_ | https://pma2.grinnell.edu | No longer temporary.  Behaving properly |
| _Omeka-S_ | https://omeka-s.grinnell.edu |   |

## Now with Valid Certs!

Earlier in this process we learned that _Solr_ won't work properly without a **valid** TLS certificate, not a temporary one.  So I was forced to move our certificate authority server spec from _Let's Encrypt_ "stagging" back to "production" (see the _./dockerized-server/data/traefik.toml_ file for details).  Fortunately, when I ran our addressing update (see section above) the production certs obtained from _Let's Encrypt_ were valid this time.  Woot!  I guess that means that our recent rate-limit induced ban had expired?  It also means I can now close the books on this project.  Double woot!   

And that's a wrap... until next time.
