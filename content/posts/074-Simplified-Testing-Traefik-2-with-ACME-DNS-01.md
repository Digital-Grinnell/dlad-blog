---
title: "Simplified Testing of Traefik 2 with ACME DNS-01 Challenge"
publishdate: 2020-05-19
draft: false
tags:
  - Docker
  - Traefik
  - ACME
  - DNS-01
  - docker-traefik2-host
  - docker-compose
---

This post is a simplified and focused follow-up to [Dockerized Traefik Host Using ACME DNS-01 Challenge](/en/posts/071-dockerized-traefik-using-acme-dns-01/).

## Simplify

Today, 19-May-2020, I'm going to take a shot at simplifying my testing on `dgdocker3.grinnell.edu` by removing unnecessary things and consolidating as much as possible to reduce clutter in the logs and get right to the point. I'm also going to have a look to see if there are additional logs that can tell give me more detail.  **Everything** used here, and everything that takes place here, will be found in a new directory, `/opt/containers/test` on _DGDocker3_.

## Key Files

The key files involved in these tests are presented in subsections here.

### ./test/docker-compose.yml

```yaml
version: '3'

services:
  traefik:
    image: traefik:2.2.1
    container_name: traefik
    hostname: traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    networks:
      - proxy
    ports:
      - 80:80
      - 443:443
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
      - ./data/acme.json:/acme.json
    labels:
      - "traefik.enable=true"
      # next 4 lines...universal http --> https redirect per https://community.containo.us/t/a-global-http-https-redirection/864/3
      - "traefik.http.routers.http-catchall.rule=hostregexp(`{host:[a-z-.]+}`)"
      - "traefik.http.routers.http-catchall.entrypoints=http"
      - "traefik.http.routers.http-catchall.middlewares=redirect-to-https"
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
      # now the Traefik-specific dashboard stuff
      - "traefik.http.middlewares.traefik-auth.basicauth.users=admin:$$2y$$05$$pJEzHJBzfoYYS7/hGAedcOP8XdsqNXE7j.LHFBVjueASOqOvvjGOy"
      - "traefik.http.routers.traefik-secure.entrypoints=https"
      - "traefik.http.routers.traefik-secure.rule=Host(`${HOST}`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
      - "traefik.http.routers.traefik-secure.middlewares=traefik-auth"
      - "traefik.http.routers.traefik-secure.tls=true"
      - "traefik.http.routers.traefik-secure.tls.certresolver=http"
      - "traefik.http.routers.traefik-secure.service=api@internal"

  landing:
    image: mcfatem/dgdocker3-landing:latest
    container_name: landing-page
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    networks:
      - proxy
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data:/data
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=proxy"
      - "traefik.http.routers.landing-secure.entrypoints=https"
      - "traefik.http.routers.landing-secure.rule=Host(`${HOST}`)"
      - "traefik.http.routers.landing-secure.tls=true"
      - "traefik.http.routers.landing-secure.tls.certresolver=http"
      - "traefik.http.routers.landing-secure.service=landing-test"
      - "com.centurylinklabs.watchtower.enable=true"

networks:
  proxy:
    external: true
```

### ./test/destroy.sh

```bash
#!/bin/bash
#
rm -f /opt/containers/test/data/acme.json
#
docker stop $(docker ps -q);
docker rm -v $(docker ps -qa);
# docker image rm $(docker image ls -q)
docker system prune --force
#
touch /opt/containers/test/data/acme.json
chmod 600 /opt/containers/test/data/acme.json
```

### ./test/restart.sh

```bash
#!/bin/bash
#
docker network create proxy
cd /opt/containers/test
docker-compose up -d; docker-compose logs
#
echo "Dumping traefik.log..."
docker exec -it traefik cat /var/log/traefik.log
```

### ./test/data/traefik.yml (obfuscated)

```yaml
api:
  dashboard: true

entryPoints:
  http:
    address: ":80"
  https:
    address: ":443"

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false

### for HTTP-01 challenge
#certificatesResolvers:
#  http:
#    acme:
#      # - Uncomment caServer line below to run on the staging let's encrypt server.  Leave comment to go to prod.
#      #caServer: https://acme-staging-v02.api.letsencrypt.org/directory
#      email: digital@grinnell.edu
#      storage: acme.json
#      httpChallenge:
#        entryPoint: http

## for DNS-01 challenge
certificatesResolvers:
  http:
    acme:
      # - Uncomment caServer line below to run on the staging Let's Encrypt server.  Leave comment to go to prod.
      caServer: https://acme-staging-v02.api.letsencrypt.org/directory
      email: digital@grinnell.edu
      storage: acme.json
      dnsChallenge:
        provider: azure
        delayBeforeCheck: 0

environment:
  AZURE_CLIENT_ID: "c537...d99"
  AZURE_CLIENT_SECRET: "6a2...154"
  AZURE_SUBSCRIPTION_ID: "a55...c4f"
  AZURE_TENANT_ID: "524...807"
  AZURE_DNS_ZONE: "lev...nfo"
  AZURE_RESOURCE_GROUP: "Net...ces"
  #
  #AZURE_CLIENT_ID: "${AZURE_CLIENT_ID}"
  #AZURE_CLIENT_SECRET: "${AZURE_CLIENT_SECRET}"
  #AZURE_SUBSCRIPTION_ID: "${AZURE_SUBSCRIPTION_ID}"
  #AZURE_TENANT_ID: "${AZURE_TENANT_ID}"
  #AZURE_DNS_ZONE: "${AZURE_DNS_ZONE}"
  #AZURE_RESOURCE_GROUP: "${AZURE_RESOURCE_GROUP}"

log:
  level: DEBUG
  filePath: "/var/log/traefik.log"
```

### ./test/data/config.yml

```yaml
http:
  middlewares:
    https-redirect:
      redirectScheme:
        scheme: https
```


## Initial Test - Failed

My initial test was a simplified repeat of [Test 7](/en/posts/071-dockerized-traefik-using-acme-dns-01/#test-7---dgdocker3-test-with-staging-and-dns-01). The result was much like I documented in that previous test, with no certs, and no indication of problems other than the mysterious "TLS handshake error" that I reported before. So, time to make some changes and see what happens.

## Changing the Name of the CertResolver

In all my previous tests there are lots of instances of "http", and most notably, it's the name given to the _certresolver_ regardless if this is an HTTP-01 or DNS-01 challenge. Since my simplified tests all focus on DNS-01 I'm changing that _certresolver_ name to "dns".

This change was made in `./test/docker-compose.yml` lines 22 and 43, and line 30 of `./test/data/traefik.yml`. No other files or lines were modified.

### Test S1

The "S" in "S1" distinguishes this as a "Simplified" test. To run this test I executed the following, as _root_, on `dgdocker3.grinnell.edu`:

```
cd /opt/containers/test
./destroy.sh
./restart.sh
grep Certificates data/acme.json
```

The outcome is the same as before, both the _Traefik_ dashboard (https://dgdocker3.grinnell.edu/dashboard/) and landing page (https://dgdocker3.grinnell.edu/) are working, but without valid certs so browser security exceptions are required.  The output from this test can be found in [this gist](https://gist.github.com/McFateM/36ade6742e90922d8a484ce23f07998c).





And that's a good place to break, but I'll be baaaaak. :smile:
