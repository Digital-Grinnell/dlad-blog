---
title: "Traefik and Acme.sh Instead of DNS-01"
publishdate: 2020-06-02
draft: false
tags:
  - Docker
  - Traefik
  - ACME
  - DNS-01
  - docker-traefik2-host
  - docker-compose
---

This post is a follow-up to [Dockerized Traefik Host Using ACME DNS-01 Challenge](/en/posts/071-dockerized-traefik-using-acme-dns-01).  It introduces an alternative to the failed process that was proposed in that earlier post.

> Note that the following config-specific elements have been replaced below:
>   - 6 occurances of `?.grinnell.edu` now say `example-1.grinnell.edu`, and
>   - 2 occurances of `?.info` now say `example-2.info`.

## New Proposal

On June 1 my colleage, Matt, suggested the following...

> As much as I would like to resolve the DNS-01 challenge using Traefik alone, I don't believe it will support what we're trying to do here.  I'm a bit disappointed by that as Nginx makes this process very easy, and my reading through the Traefik documentation and my own tests lead me to believe that CNAME following is not currently supported in Traefik, and is basically impossible.  Until the they allow for the verification domain to be specified as a provider option (in this case, specifying example-2.info as the domain for the Azure DNS provider), using the built-in ACME functionality in Traefik won't work, no matter which DNS provider is in use.
>
> However, I believe I have a solution.  Acme.sh is another tool that is commonly used to generate certificates using Let's Encrypt and the ACME protocol, and it does support domain aliasing.  There is a containerized version of this, and I was able to build a docker-compose file that launches Traefik, a simple Whoami app, and the acme.sh container for creating certificates using the DNS-01 challenge.  It's not fully automated in that you have to run a docker exec command after the first run, but I think automating that part of it should be possible.  The acme.sh container will renew certificates every 60 days as long as the acme.sh container is running.  Traefik is configured to watch the certificate directory for changes and will reload when the certificate is renewed.

> It's a fairly simple set up and I hope it can work for your use case.


```yaml
version: "3.3"

services:

  acme:
    image: neilpang/acme.sh:latest
    volumes:
      - ./certs:/certs
    environment:
      # Azure
      - AZUREDNS_SUBSCRIPTIONID=
      - AZUREDNS_TENANTID=
      - AZUREDNS_APPID=
      - AZUREDNS_CLIENTSECRET=

    command: daemon
    container_name: acme


  traefik:
    image: "traefik:v2.2.1"
    container_name: "traefik"
    command:
      # --log.level=DEBUG
      --api.insecure=true
      --providers.docker=true
      --providers.docker.exposedbydefault=false
      --providers.file.directory=/certs/
      --providers.file.watch=true
      --entrypoints.web.address=:80
      --entrypoints.websecure.address=:443

    ports:
      - 80:80
      - 443:443
      - 8080:8080

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./letsencrypt:/letsencrypt
      - ./certs/:/certs/

  whoami:
    image: containous/whoami
    container_name: simple-service
    labels:
      traefik.enable: "true"
      traefik.http.routers.whoami.rule: "Host(`example-1.grinnell.edu`)"
      traefik.http.routers.whoami.entrypoints: "websecure"
      traefik.http.routers.whoami.tls: "true"
```

> In my 'certs' directory, I have a certs.toml file with this:

```toml
[[tls.certificates]]
    certFile = "/certs/example-1.grinnell.edu.cert"
    keyFile = "/certs/example-1.grinnell.edu.key"
```
>
> Just add an additional [[tls.certificates]] section for every additional certificate you will want generated.

> Netcentos is the name of my test machine, so just change that where you see it.
>
> You will also want to move your Azure environment variables from the Traefik section to the Acme.sh container section (without quotes).
>
> After running docker-compose up -d, you will need to run the acme.sh command within the container once, changing the hostname for your own.  If you want an additional hostname include another -d flag and then the FQDN.

```
docker exec -it acme --issue --dns dns_azure -d example-1.grinnell.edu --domain-alias _acme-challenge.example-2.info --key-file /certs/example-1.grinnell.edu.key --cert-file /certs/example-1.grinnell.edu.cert --standalone
```
>
> Here's the documentation that I followed to get here, but feel free to send me questions if you have any.
>
> - https://containo.us/blog/traefik-2-tls-101-23b4fbee81f1/
> - https://github.com/acmesh-official/acme.sh/wiki/DNS-alias-mode
> - https://hub.docker.com/r/neilpang/acme.sh

## McFateM/docker-traefik2-acme-host

I started work on this proposal by cloning [https://github.com/DigitalGrinnell/docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host), reinitializing it, and pushing back an unmodified new copy to [https://github.com/McFateM/docker-traefik2-acme-host](https://github.com/McFateM/docker-traefik2-acme-host).

## First Experience

Yesterday I created cloned the above repository to the `/opt/containers` directory on my development and testing host, `dgdocker3`. In the `docker-traefik2-acme-host` directory there I created a new `traefik` subdirectory to work from.

After introducing as few changes as possible, I navigated into the aforementioned `traefik` subdirectory and did this, with the following log results:

```bash
docker-compose up -d
traefik    | time="2020-06-03T21:03:31Z" level=info msg="Configuration loaded from flags."
traefik    | time="2020-06-03T21:03:31Z" level=error msg="Unable to append certificate /certs/dgdocker3.grinnell.edu.cert to store: unable to generate TLS certificate : tls: failed to find any PEM data in certificate input" tlsStoreName=default
```

The error here caused me to panic for a bit, but realizing that the process wasn't complete I eventually moved on to the necessary next step.

## Invoking Acme.sh

In spite of the errors reported by `docker-compose up -d`, the command did indeed create three healthy containers: `traefik`, `acme`, and `simple-service`. That last container just provides a [WhoAmI](https://en.wikipedia.org/wiki/Whoami) app that I've configured to respond to [https://dgdocker3.grinnell.edu](https://dgdocker3.grinnell.edu). It works, but the cert is reported to be invalid/insecure.

Matt's instructions do say that after `docker-compose up -d` there is one remaining command required to configure `acme.sh` to provision and keep watch on the certs to be created.  This command is to be run only one time in order to create a cert.  So I did this with the following obfuscated results:

```
[root@dgdocker3 traefik]# docker exec -it acme --issue --dns dns_azure -d dgdocker3.grinnell.edu --domain-alias _acme-challenge.obfuscated.info --key-file /certs/dgdocker3.grinnell.edu --cert-file /cernts/dgdocker3.grinnell.edu.cert --standalone
[Wed Jun  3 22:13:45 UTC 2020] Create account key ok.
[Wed Jun  3 22:13:45 UTC 2020] Registering account
[Wed Jun  3 22:13:46 UTC 2020] Registered
[Wed Jun  3 22:13:46 UTC 2020] ACCOUNT_THUMBPRINT='EOC57YZgSg-D6S1dAREUNxGArecjpDRizh_Tyo85kN8'
[Wed Jun  3 22:13:46 UTC 2020] Creating domain key
[Wed Jun  3 22:13:46 UTC 2020] The domain key is here: /acme.sh/dgdocker3.grinnell.edu/dgdocker3.grinnell.edu.key
[Wed Jun  3 22:13:46 UTC 2020] Single domain='dgdocker3.grinnell.edu'
[Wed Jun  3 22:13:46 UTC 2020] Getting domain auth token for each domain
[Wed Jun  3 22:13:47 UTC 2020] Getting webroot for domain='dgdocker3.grinnell.edu'
[Wed Jun  3 22:13:47 UTC 2020] Adding txt value: eMxRFkWK...mWAX4 for domain:  _acme-challenge.obfuscated.info
[Wed Jun  3 22:13:49 UTC 2020] validation value added
[Wed Jun  3 22:13:49 UTC 2020] The txt record is added: Success.
[Wed Jun  3 22:13:49 UTC 2020] Let's check each dns records now. Sleep 20 seconds first.
[Wed Jun  3 22:14:10 UTC 2020] Checking dgdocker3.grinnell.edu for _acme-challenge.obfuscated.info
[Wed Jun  3 22:14:10 UTC 2020] Domain dgdocker3.grinnell.edu '_acme-challenge.obfuscated.info' success.
[Wed Jun  3 22:14:10 UTC 2020] All success, let's return
[Wed Jun  3 22:14:10 UTC 2020] Verifying: dgdocker3.grinnell.edu
[Wed Jun  3 22:14:12 UTC 2020] Success
[Wed Jun  3 22:14:12 UTC 2020] Removing DNS records.
[Wed Jun  3 22:14:12 UTC 2020] Removing txt: eMxRFkWK...WAX4 for domain: _acme-challenge.obfuscated.info
[Wed Jun  3 22:14:14 UTC 2020] validation record removed
[Wed Jun  3 22:14:14 UTC 2020] Removed: Success
[Wed Jun  3 22:14:14 UTC 2020] Verify finished, start to sign.
[Wed Jun  3 22:14:14 UTC 2020] Lets finalize the order, Le_OrderFinalize: https://acme-v02.api.letsencrypt.org/acme/finalize/87890647/3622372972
[Wed Jun  3 22:14:15 UTC 2020] Download cert, Le_LinkCert: https://acme-v02.api.letsencrypt.org/acme/cert/04591be468a971eb756bf08bc626c5905321
[Wed Jun  3 22:14:15 UTC 2020] Cert success.
-----BEGIN CERTIFICATE-----
MIIFZDCCBE...waHNHdLOQrtg==
-----END CERTIFICATE-----
[Wed Jun  3 22:14:15 UTC 2020] Your cert is in  /acme.sh/dgdocker3.grinnell.edu/dgdocker3.grinnell.edu.cer
[Wed Jun  3 22:14:15 UTC 2020] Your cert key is in  /acme.sh/dgdocker3.grinnell.edu/dgdocker3.grinnell.edu.key
[Wed Jun  3 22:14:15 UTC 2020] The intermediate CA cert is in  /acme.sh/dgdocker3.grinnell.edu/ca.cer
[Wed Jun  3 22:14:15 UTC 2020] And the full chain certs is there:  /acme.sh/dgdocker3.grinnell.edu/fullchain.cer
[Wed Jun  3 22:14:15 UTC 2020] Installing cert to:/cernts/dgdocker3.grinnell.edu.cert
/root/.acme.sh/acme.sh: line 5246: can't create /cernts/dgdocker3.grinnell.edu.cert: nonexistent directory
[root@dgdocker3 traefik]# docker exec -it acme --issue --dns dns_azure -d dgdocker3.grinnell.edu --domain-alias _acme-challenge.obfuscated.info --key-file /certs/dgdocker3.grinnell.edu --cert-file /certs/dgdocker3.grinnell.edu.cert --standalone
[Wed Jun  3 22:16:31 UTC 2020] Domains not changed.
[Wed Jun  3 22:16:31 UTC 2020] Skip, Next renewal time is: Sun Aug  2 22:14:15 UTC 2020
[Wed Jun  3 22:16:31 UTC 2020] Add '--force' to force to renew.
[root@dgdocker3 traefik]# docker exec -it acme --issue --dns dns_azure -d dgdocker3.grinnell.edu --domain-alias _acme-challenge.obfuscated.info --key-file /certs/dgdocker3.grinnell.edu --cert-file /certs/dgdocker3.grinnell.edu.cert --standalone --force
[Wed Jun  3 22:16:42 UTC 2020] Single domain='dgdocker3.grinnell.edu'
[Wed Jun  3 22:16:42 UTC 2020] Getting domain auth token for each domain
[Wed Jun  3 22:16:43 UTC 2020] Getting webroot for domain='dgdocker3.grinnell.edu'
[Wed Jun  3 22:16:43 UTC 2020] dgdocker3.grinnell.edu is already verified, skip dns-01.
[Wed Jun  3 22:16:43 UTC 2020] Verify finished, start to sign.
[Wed Jun  3 22:16:43 UTC 2020] Lets finalize the order, Le_OrderFinalize: https://acme-v02.api.letsencrypt.org/acme/finalize/87890647/3622403221
[Wed Jun  3 22:16:44 UTC 2020] Download cert, Le_LinkCert: https://acme-v02.api.letsencrypt.org/acme/cert/0342ac4b3f8619949070cce67d48b998ea8c
[Wed Jun  3 22:16:44 UTC 2020] Cert success.
-----BEGIN CERTIFICATE-----
MIIFZjCCBE6...uZDIZq1GMQ7xM
-----END CERTIFICATE-----
[Wed Jun  3 22:16:44 UTC 2020] Your cert is in  /acme.sh/dgdocker3.grinnell.edu/dgdocker3.grinnell.edu.cer
[Wed Jun  3 22:16:44 UTC 2020] Your cert key is in  /acme.sh/dgdocker3.grinnell.edu/dgdocker3.grinnell.edu.key
[Wed Jun  3 22:16:44 UTC 2020] The intermediate CA cert is in  /acme.sh/dgdocker3.grinnell.edu/ca.cer
[Wed Jun  3 22:16:44 UTC 2020] And the full chain certs is there:  /acme.sh/dgdocker3.grinnell.edu/fullchain.cer
[Wed Jun  3 22:16:44 UTC 2020] Installing cert to:/certs/dgdocker3.grinnell.edu.cert
[Wed Jun  3 22:16:44 UTC 2020] Installing key to:/certs/dgdocker3.grinnell.edu
[root@dgdocker3 traefik]#
```

## Oops

If you look closely above you'll see that I ran the command twice because of a typo the first time around.  As suggested in the output, I corrected the syntax and ran the command a second time with an appended `--force` option.  That seemed to work since it looks like the second command ran without incident.  However, when I visit [https://dgdocker3.grinnell.edu](https://dgdocker3.grinnell.edu) the site comes up, but still with an invalid/insecure cert.

**The cert appears to have been generated correctly, and against the _Let's Encrypt_ production server, so why is it invalid?**

## A Hunch

I've received confirmation that certs are generated only when this critical command, `docker exec -it acme --issue --dns dns_azure -d dgdocker3.grinnell.edu --domain-alias _acme-challenge.obfuscated.info --key-file /certs/dgdocker3.grinnell.edu --cert-file /certs/dgdocker3.grinnell.edu.cert --standalone --force`, is run.  Also, the order in which the containers are created isn't critical, so in the future it probably makes better sense to create the `acme` container first, and run it before `traefik` and the others are created.

Now I need to confirm that the generated certs are visible to the _traefik_ container, and that they have proper permissions. Looking at that now...

I set _Traefik_'s debugging level to `DEBUG`, and removed all of the trailing slashes from `/certs` references in `docker-compose.yml`. When I did a new `docker-compose up -d` this is what I got, with some obfuscation:

```
╭─mcfatem@dgdocker3 /opt/containers/docker-traefik2-acme-host/traefik ‹master*›
╰─$ docker-compose up -d
Recreating traefik ...
simple-service is up-to-date
Recreating traefik ... done
╭─mcfatem@dgdocker3 /opt/containers/docker-traefik2-acme-host/traefik ‹master*›
╰─$ docker-compose logs
Attaching to traefik, simple-service, acme
simple-service | Starting up on port 80
traefik    | time="2020-06-04T16:36:15Z" level=info msg="Configuration loaded from flags."
traefik    | time="2020-06-04T16:36:15Z" level=info msg="Traefik version 2.2.1 built on 2020-04-29T18:02:09Z"
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Static configuration loaded {\"global\":{\"checkNewVersion\":true},\"serversTransport\":{\"maxIdleConnsPerHost\":200},\"entryPoints\":{\"traefik\":{\"address\":\":8080\",\"transport\":{\"lifeCycle\":{\"graceTimeOut\":10000000000},\"respondingTimeouts\":{\"idleTimeout\":180000000000}},\"forwardedHeaders\":{},\"http\":{}},\"web\":{\"address\":\":80\",\"transport\":{\"lifeCycle\":{\"graceTimeOut\":10000000000},\"respondingTimeouts\":{\"idleTimeout\":180000000000}},\"forwardedHeaders\":{},\"http\":{}},\"websecure\":{\"address\":\":443\",\"transport\":{\"lifeCycle\":{\"graceTimeOut\":10000000000},\"respondingTimeouts\":{\"idleTimeout\":180000000000}},\"forwardedHeaders\":{},\"http\":{}}},\"providers\":{\"providersThrottleDuration\":2000000000,\"docker\":{\"watch\":true,\"endpoint\":\"unix:///var/run/docker.sock\",\"defaultRule\":\"Host(`{{ normalize .Name }}`)\",\"swarmModeRefreshSeconds\":15000000000},\"file\":{\"directory\":\"/certs\",\"watch\":true}},\"api\":{\"insecure\":true,\"dashboard\":true},\"log\":{\"level\":\"DEBUG\",\"format\":\"common\"}}"
traefik    | time="2020-06-04T16:36:15Z" level=info msg="\nStats collection is disabled.\nHelp us improve Traefik by turning this feature on :)\nMore details on: https://docs.traefik.io/contributing/data-collection/\n"
traefik    | time="2020-06-04T16:36:15Z" level=info msg="Starting provider aggregator.ProviderAggregator {}"
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Start TCP Server" entryPointName=web
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Start TCP Server" entryPointName=websecure
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Start TCP Server" entryPointName=traefik
traefik    | time="2020-06-04T16:36:15Z" level=info msg="Starting provider *file.Provider {\"directory\":\"/certs\",\"watch\":true}"
traefik    | time="2020-06-04T16:36:15Z" level=info msg="Starting provider *traefik.Provider {}"
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Configuration received from provider file: {\"http\":{},\"tcp\":{},\"udp\":{},\"tls\":{}}" providerName=file
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Configuration received from provider internal: {\"http\":{\"routers\":{\"api\":{\"entryPoints\":[\"traefik\"],\"service\":\"api@internal\",\"rule\":\"PathPrefix(`/api`)\",\"priority\":2147483646},\"dashboard\":{\"entryPoints\":[\"traefik\"],\"middlewares\":[\"dashboard_redirect@internal\",\"dashboard_stripprefix@internal\"],\"service\":\"dashboard@internal\",\"rule\":\"PathPrefix(`/`)\",\"priority\":2147483645}},\"services\":{\"api\":{},\"dashboard\":{},\"noop\":{}},\"middlewares\":{\"dashboard_redirect\":{\"redirectRegex\":{\"regex\":\"^(http:\\\\/\\\\/[^:\\\\/]+(:\\\\d+)?)\\\\/$\",\"replacement\":\"${1}/dashboard/\",\"permanent\":true}},\"dashboard_stripprefix\":{\"stripPrefix\":{\"prefixes\":[\"/dashboard/\",\"/dashboard\"]}}}},\"tcp\":{},\"tls\":{}}" providerName=internal
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="No store is defined to add the certificate MIIFZjCCBE6gAwIBAgISA0KsSz+GGZSQcMzmfUi5mOqMMA0GCS, it will be added to the default store."
traefik    | time="2020-06-04T16:36:15Z" level=error msg="Unable to append certificate MIIFZjCCBE6gAwIBAgISA0KsSz+GGZSQcMzmfUi5mOqMMA0GCS to store: unable to generate TLS certificate : tls: failed to find any PEM data in key input" tlsStoreName=default
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="No default certificate, generating one"
traefik    | time="2020-06-04T16:36:15Z" level=info msg="Starting provider *docker.Provider {\"watch\":true,\"endpoint\":\"unix:///var/run/docker.sock\",\"defaultRule\":\"Host(`{{ normalize .Name }}`)\",\"swarmModeRefreshSeconds\":15000000000}"
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Provider connection established with docker 19.03.8 (API 1.40)" providerName=docker
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Filtering disabled container" container=traefik-traefik-afe2703051b474ea3e259e1fcc8699a925968ddca1132fb67265479c4e93c85b providerName=docker
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Filtering disabled container" providerName=docker container=acme-traefik-cda17bc48f61207b7c92c9d1760f7d428eccc4b413dd440bb97bdd84ee052df3
traefik    | time="2020-06-04T16:36:15Z" level=debug msg="Configuration received from provider docker: {\"http\":{\"routers\":{\"whoami\":{\"entryPoints\":[\"websecure\"],\"service\":\"whoami-traefik\",\"rule\":\"Host(`dgdocker3.grinnell.edu`)\",\"tls\":{}}},\"services\":{\"whoami-traefik\":{\"loadBalancer\":{\"servers\":[{\"url\":\"http://192.168.160.3:80\"}],\"passHostHeader\":true}}}},\"tcp\":{},\"udp\":{}}" providerName=docker
traefik    | time="2020-06-04T16:36:16Z" level=error msg="Unable to append certificate MIIFZjCCBE6gAwIBAgISA0KsSz+GGZSQcMzmfUi5mOqMMA0GCS to store: unable to generate TLS certificate : tls: failed to find any PEM data in key input" tlsStoreName=default
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Added outgoing tracing middleware api@internal" middlewareType=TracingForwarder entryPointName=traefik routerName=api@internal middlewareName=tracing
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Added outgoing tracing middleware dashboard@internal" entryPointName=traefik routerName=dashboard@internal middlewareName=tracing middlewareType=TracingForwarder
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" entryPointName=traefik routerName=dashboard@internal middlewareType=StripPrefix middlewareName=dashboard_stripprefix@internal
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Adding tracing to middleware" routerName=dashboard@internal middlewareName=dashboard_stripprefix@internal entryPointName=traefik
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" entryPointName=traefik routerName=dashboard@internal middlewareName=dashboard_redirect@internal middlewareType=RedirectRegex
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Setting up redirection from ^(http:\\/\\/[^:\\/]+(:\\d+)?)\\/$ to ${1}/dashboard/" middlewareType=RedirectRegex entryPointName=traefik routerName=dashboard@internal middlewareName=dashboard_redirect@internal
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Adding tracing to middleware" entryPointName=traefik routerName=dashboard@internal middlewareName=dashboard_redirect@internal
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" entryPointName=traefik middlewareName=traefik-internal-recovery middlewareType=Recovery
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="No default certificate, generating one"
traefik    | time="2020-06-04T16:36:16Z" level=error msg="Unable to append certificate MIIFZjCCBE6gAwIBAgISA0KsSz+GGZSQcMzmfUi5mOqMMA0GCS to store: unable to generate TLS certificate : tls: failed to find any PEM data in key input" tlsStoreName=default
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Added outgoing tracing middleware dashboard@internal" middlewareName=tracing middlewareType=TracingForwarder routerName=dashboard@internal entryPointName=traefik
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" middlewareType=StripPrefix entryPointName=traefik routerName=dashboard@internal middlewareName=dashboard_stripprefix@internal
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Adding tracing to middleware" routerName=dashboard@internal middlewareName=dashboard_stripprefix@internal entryPointName=traefik
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" middlewareName=dashboard_redirect@internal middlewareType=RedirectRegex entryPointName=traefik routerName=dashboard@internal
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Setting up redirection from ^(http:\\/\\/[^:\\/]+(:\\d+)?)\\/$ to ${1}/dashboard/" entryPointName=traefik routerName=dashboard@internal middlewareName=dashboard_redirect@internal middlewareType=RedirectRegex
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Adding tracing to middleware" middlewareName=dashboard_redirect@internal entryPointName=traefik routerName=dashboard@internal
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Added outgoing tracing middleware api@internal" middlewareName=tracing middlewareType=TracingForwarder entryPointName=traefik routerName=api@internal
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" entryPointName=traefik middlewareName=traefik-internal-recovery middlewareType=Recovery
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" entryPointName=websecure routerName=whoami@docker serviceName=whoami-traefik middlewareName=pipelining middlewareType=Pipelining
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating load-balancer" serviceName=whoami-traefik entryPointName=websecure routerName=whoami@docker
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating server 0 http://192.168.160.3:80" routerName=whoami@docker serviceName=whoami-traefik entryPointName=websecure serverName=0
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Added outgoing tracing middleware whoami-traefik" entryPointName=websecure routerName=whoami@docker middlewareName=tracing middlewareType=TracingForwarder
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="Creating middleware" entryPointName=websecure middlewareName=traefik-internal-recovery middlewareType=Recovery
traefik    | time="2020-06-04T16:36:16Z" level=debug msg="No default certificate, generating one"
traefik    | time="2020-06-04T16:36:26Z" level=debug msg="Serving default certificate for request: \"dgdocker3.grinnell.edu\""
traefik    | time="2020-06-04T16:36:26Z" level=debug msg="http: TLS handshake error from 132.161.249.186:55292: remote error: tls: bad certificate" |
```

## Aha!

I poured over the output above and to be honest, it wasn't all that helpful, but along the way I decided to double check something...

The unfortunate thing with this process is that we have to run a lengthy `docker exec...` command. Sure, you only run it once, but it's pretty long and therefore subject to human error.  I knew that I got it wrong twice, but in reality, there were three iterations of at least one error/omission.

The command I typed (can't even copy/paste since I have to be on VPN to run the command, and VPN effectively "blinds" my machine rendering the clipboard almost useless), four times now, looked like this the first time:

```
docker exec -it acme --issue --dns dns_azure -d dgdocker3.grinnell.edu --domain-alias _acme-challenge.{obfuscated}.info --key-file /cernts/dgdocker3.grinnell.edu --cert-file /certs/dgdocker3.grinnell.edu.cert --standalone
```

There's an obvious error there, an extra "n" in the `--key-file` path.  It read `/cernts/`, but should have been `/certs/`.  Fortunately that was pretty easy to catch and the error messages in the log helped me identify it.  However, in that same portion of the command there's another error, actually an omission, that's more sinister.  The clause `--key-file /cernts/dgdocker3.grinnell.edu` should actually be `--key-file /certs/dgdocker3.grinnell.edu.key`.  They "key" difference there is the `.key` extension at the very end, it was omitted the first THREE times I ran this command!

## One More Time...with Feeling

So, the correct `docker exec...` command at this point is:

```
docker exec -it acme --issue --dns dns_azure -d dgdocker3.grinnell.edu --domain-alias _acme-challenge.{obfuscated}.info --key-file /certs/dgdocker3.grinnell.edu.key --cert-file /certs/dgdocker3.grinnell.edu.cert --standalone --force
```

The `--force` option is required here to "force" _Acme_ to renew, or create, new certs since some already exist from previous iterations of the command.  This time we must need to renew/create them with the correct path and file names!

I've put a "copy" of that command, with obfuscated elements restored as needed, into the `.env` file that carries some necessary credentials.  Now to give it a go...

## The End Result

**I am exceptionally pleased to report that...** `IT` `JUST` `WORKS`.  :exclamation: :grinning: :exclamation: :grinning: :exclamation:

Next steps...I'm going to split the process into a more granluar form with additional containers/services, and repeat this test. If that works I'll take additional steps to automate everything to reduce the potential for future human-error, within reason.

Look for all of that in a follow-up blog post.


And that's a wrap. I am so pleased that this works (and it's not even Friday!)  :smile:
