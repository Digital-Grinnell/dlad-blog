---
title: "Traefik and Acme.sh for DG-STAGING"
publishDate: 2020-09-15
lastmod: 2020-09-28T15:15:56-05:00
draft: false
tags:
  - ISLE
  - migrate
  - staging
  - Docker
  - Traefik
  - ACME
  - DNS-01
  - docker-traefik2-host
  - docker-compose
---

This post is a follow-up to [Dockerized Traefik Host Using ACME DNS-01 Challenge](/posts/079-traefik-and-acme.sh-instead-of-dns-01/) and [Staging ISLE Installation: Migrate Existing Islandora Site - with Annotations](/posts/092-staging-isle/), specifically _Step 11_ in the later document.  It introduces a _Digital.Grinnell_-specific implementation of the _Traefik_ with _Acme.sh_.

## Testing with McFateM/docker-traefik2-acme-host

I started work on this implementation with a test, by cloning [https://github.com/McFateM/docker-traefik2-acme-host](https://github.com/McFateM/docker-traefik2-acme-host) and proceeding as directed in the repository's [README.md](https://github.com/McFateM/docker-traefik2-acme-host/blob/master/README.md) document, as user `islandora` on node _DGDockerX_, like so:

| DGDockerX Host Commands |
| --- |
| `cd ~` <br/> `git clone https://github.com/McFateM/docker-traefik2-acme-host host --recursive` <br/> `cd host` |

### Working in `~/host/acme`

As suggested, I made a copy of the `.env` file from the corresponding `acme` directory on Grinnell's `dgdocker3.grinnell.edu` server, something like this:

```
╭─islandora@dgdockerx ~/host/acme ‹master*›
╰─$ rsync -aruvi islandora@dgdocker3.grinnell.edu:/home/islandora/host/acme/.env . --progress
The authenticity of host 'dgdocker3.grinnell.edu (132.161.151.***)' can't be established.
ECDSA key fingerprint is SHA256:************************************************.
ECDSA key fingerprint is MD5:****************************************.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'dgdocker3.grinnell.edu,132.161.151.***' (ECDSA) to the list of known hosts.
islandora@dgdocker3.grinnell.edu's password:
receiving incremental file list
>f+++++++++ .env            896 100%  875.00kB/s    0:00:00 (xfr#1, to-chk=0/1)

sent 43 bytes  received 1,011 bytes  39.77 bytes/sec
total size is 896  speedup is 0.85
```

I made the following edits/changes on the _DGDocker3_ host as suggested in the project repository [README.md](https://github.com/McFateM/docker-traefik2-acme-host/blob/master/README.md) file, using _nano_.

| File | Edits |
| --- | --- |
| `~/host/certs/certs.toml` | Changed initial `tls.certificates` entry to reference `dgdockerx.grinnell.edu.<extension>` |
| `~/host/acme/DGDOCKERX.md` | Copied file `DGDOCKER3.md` and changed all `dgdocker3.grinnell.edu` references to `dgdockerx.grinnell.edu` |
| `~/host/acme/.env` | Changed the `HOST` and added/activated a new `DNS_LIST` variable appropriate for `dgdockerx.grinnell.edu` |

### Working in `~/host/traefik`

As suggested in the documentation, I moved into the `traefik` directory and had a look at the `README.md` file there.  Following it's advice, like so:

```
╭─islandora@dgdockerx ~/host/acme ‹master*›
╰─$ cd ../traefik
╭─islandora@dgdockerx ~/host/traefik ‹master*›
╰─$ ll
total 12K
-rw-rw-r--. 1 islandora islandora 1.9K Sep 15 14:29 docker-compose.yml
-rw-rw-r--. 1 islandora islandora  673 Sep 15 14:29 README.md
-rw-rw-r--. 1 islandora islandora  442 Sep 15 14:29 traefik-tls.toml
╭─islandora@dgdockerx ~/host/traefik ‹master*›
╰─$ cat README.md
---
Host: Defined as ${HOST} in .env
Service: traefik
URL: https://${HOST}/dashboard/
---

This document should be used to launch the `traefik` service on ANY host as part of a `docker-traefik2-acme-host` stack.

> Note that this process should be started only AFTER the `acme` service!

## Preparation

Before entering the prescribed "Command Sequence", below, the user should take steps to copy any pertinent `.env` files from an existing deployment. Try something like this:

  - `rsync -aruvi administrator@static.grinnell.edu:/home/administrator/host/traefik/.env . --progress`

## Command Sequence

  - cd ~/host/traefik
  - docker-compose up -d; docker-compose logs
╭─islandora@dgdockerx /opt/containers/host/traefik ‹master*›
╰─$ rsync -aruvi administrator@static.grinnell.edu:/home/administrator/host/traefik/.env . --progress
administrator@static.grinnell.edu's password:
receiving incremental file list
>f+++++++++ .env
             25 100%   24.41kB/s    0:00:00 (xfr#1, to-chk=0/1)

sent 43 bytes  received 140 bytes  11.09 bytes/sec
total size is 25  speedup is 0.14
╭─islandora@dgdockerx /opt/containers/host/traefik ‹master*›
╰─$ nano .env
```

| File | Edits |
| --- | --- |
| `~/host/traefik/.env` | Changed the `HOST` to `dgdockerx.grinnell.edu` |

### Working in the Remaining Directories

I did the same as above in each of the remaining directories: `portainer`, `watchtower`, and `whoami`.  Afterward, I returned to the `~/host` directory and made necessary changes to `restart.sh`.

Ultimately the changes I made were intended to create the following services and addresses for testing purposes only:

| Service | Address |
| --- | --- |
| traefik | https://dgdockerx.grinnell.edu/dashboard/ |
| portainer | https://dgdockerx.grinnell.edu/portainer/ |
| whoami | https://dgdockerx.grinnell.edu/whoami/ |

## Test Launching the Stack

With my test configured I should be able to launch the Traefik/Portainer/WhoAmI stack for testing by simply running the `~/host/destroy.sh` script followed by `~/host/restart.sh`. Initially when I did this I had configured `restart.sh` with an `acme.sh` command like this:

```
docker exec -it acme --issue --dns dns_azure --server https://acme-staging-v02.api.letsencrypt.org/directory -d dgdockerx.grinnell.edu -d isle-staging.grinnell.edu -d dg-staging.grinnell.edu --domain-alias _acme-challenge.leverify.info --key-file /certs/dgdockerx.grinnell.edu.key --cert-file /certs/dgdockerx.grinnell.edu.cert --standalone --force --log --debug 2
```

That `acme` command failed because it tried to create and validate a cert for three different subdomains, `dgdockerx.grinnell.edu`, `isle-staging.grinnell.edu`, and `dg-staging.grinnell.edu`. Validation like this requires that each target subdomain has three things in place:

  - A valid `A` record in the Grinnell College external and/or internal DNS tables directing the subdomain to an appropriate service endpoint.
  - A corresponding `CNAME` record in the college's _Azure_ DNS.  `acme` uses this to generate `TXT` records that are subsequently used for validation.
  - A working service endpoint capable of returning a valid response.

When I initiated that first test by running `~/host/restart.sh`, none of my three subdomains had the necessary `CNAME` records and only `dgdockerx.grinnell.edu` had a working service endpoint. Naturally, that test failed, and I learned from subsequent tests that **any error in the running of the `acme` script apparently negates the entire command**.  So, with that in mind, I am taking steps to limit each `acme` command I run to a single subdomain.  For example:

```
docker exec -it acme --issue --dns dns_azure --server https://acme-staging-v02.api.letsencrypt.org/directory -d dgdockerx.grinnell.edu --domain-alias _acme-challenge.leverify.info --key-file /certs/dgdockerx.grinnell.edu.key --cert-file /certs/dgdockerx.grinnell.edu.cert --standalone --force --log --debug 2

docker exec -it acme --issue --dns dns_azure --server https://acme-staging-v02.api.letsencrypt.org/directory -d isle-staging.grinnell.edu --domain-alias _acme-challenge.leverify.info --key-file /certs/isle-staging.grinnell.edu.key --cert-file /certs/isle-staging.grinnell.edu.cert --standalone --force --log --debug 2

docker exec -it acme --issue --dns dns_azure --server https://acme-staging-v02.api.letsencrypt.org/directory -d dg-staging.grinnell.edu --domain-alias _acme-challenge.leverify.info --key-file /certs/dg-staging.grinnell.edu.key --cert-file /certs/dg-staging.grinnell.edu.cert --standalone --force --log --debug 2
```

## Another Test Launch

Before attempting to engage the `acme.sh` validation scheme with my staging instance of _ISLE_, I elected to run another test with my `whoami` service and a new `dgdockerx-landing-page` service as well.  I would do so using the one-subdomain-per-command approach mentioned above. This new test needs to introduce a new service and URL as well, so I elected to add a static site "landing page" to this server. The services and addresses I intend to create will include:

| Service | Address |
| --- | --- |
| landing page/site | https://dgdockerx.grinnell.edu/ |
| traefik | https://dgdockerx.grinnell.edu/dashboard/ |
| portainer | https://dgdockerx.grinnell.edu/portainer/ |
| whoami (permanent) | https://dgdockerx.grinnell.edu/whoami/ |
| whoami (test) | https://dg-staging.grinnell.edu/ |

**I am exceptionally pleased to report that...** `IT` `JUST` `WORKS`.  :exclamation: :grinning: :exclamation: :grinning: :exclamation:

All of the updated files, `sans any .env files needed for complete configuration`, have been pushed back into the [docker-traefik2-acme-host](https://github.com/McFateM/docker-traefik2-acme-host) public repository. On September 28, 2020, I also took the liberty of upgrading the aforementioned project to use _Portainer v2.0.0_ as well as _Traefik:latest_ (currently equates to 2.3.0) and _docker-compose 3.3_.  All of those changes have also been pushed back and merged into _master_.  Enjoy.

# Next: Repeat with DG-STAGING (ISLE v1.5.1) at https://dg-staging.grinnell.edu

This could be a real challenge because [docker-traefik2-acme-host](https://github.com/McFateM/docker-traefik2-acme-host) uses _Traefik v2_ while _ISLE_ still employ _Traefik v1_. Fortunately, the key component to making this work is the _acme.sh_ script and service, and that should work with any version of _Traefik_. So let's take some baby steps...

## Introduce _acme.sh_ Into ISLE

All that's necessary to introduce _acme.sh_ into _ISLE_ is copying the current `~/host/acme` directory to `/opt/dg-isle/acme`, changing a litte of the configuration there, and invoking the _acme_ service to obtain our certs before we bring up the _ISLE_ stack.  Working on _DGDockerX_ as user _islandora_ I made the copy and edits like so:

```
cp -f ~/host/destroy.sh /opt/dg-isle/destroy.sh
cp -f ~/host/restart.sh /opt/dg-isle/restart.sh
cp -fr ~/host/acme /opt/dg-isle/acme
cd /opt/dg-isle
nano /opt/dg-isle/acme/docker-compose.yml
# In nano I changed all instances of the external network name from 'proxy' to 'isle-external', and our host '../certs:' directory to '../config/proxy/ssl-certs' in order to match ISLE conventions.
nano /opt/dg-isle/restart.sh
# In nano I changed the external network name from 'proxy' to 'isle-external' and modified directory names for other portions from `~/host` to `/opt/dg-isle`
# The next command will use the new `restart.sh` script to launch ISLE
./restart.sh
```

<!--
created the new file, `/opt/dg-isle/docker-compose.TRAEFIK2.yml`, and it reads like this -- complete with comments to explain what's intended to happen:


Since the _ISLE_ stack is controlled from a single `docker-compose.staging.yml` file, plus my custom _FEDORA_ repository additions which appear in `docker-compose.DG-STAGING.yml`, I believe the key to this portion of the process will be introducing a new `docker-compose.ACME.yml` file to introduce the  _acme.sh_ service to replace the project's standard _DNS-01_ validation with our new approach. That should be simple enough, but the _acme.sh_ approach uses _Traefik v2_, not _v1_, so we should probably introduce that change first.

## Upgrading `docker-compose.staging.yml` to Traefik v2.0

To do this I'm going to introduce a new `docker-compose.TRAEFIK2.yml` file with override configuration designed to transition our `docker-compose.staging.yml` file to the new version of _Traefik_.  Working on _DGDockerX_ as user _islandora_ I created the new file, `/opt/dg-isle/docker-compose.TRAEFIK2.yml`, and it reads like this -- complete with comments to explain what's intended to happen:

-->

And that's a wrap for this episode. Until next time...
