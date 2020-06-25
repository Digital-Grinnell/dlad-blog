---
title: "Dockerized Traefik Host Using ACME DNS-01 Challenge"
publishdate: 2020-04-27
draft: false
tags:
  - Docker
  - Traefik
  - Portainer
  - Watchtower
  - dockerized-server
  - traefik.frontend.rule
  - ACME
  - DNS-01
  - HTTP-01
  - docker-traefik2-host
  - docker-compose
  - service-stack
---

This post builds on [My dockerized-server Config](https://dlad.summittdweller.com/en/posts/042-my-dockerized-server-config/) and attempts to change what was a problematic [ACME HTTP-01 or httpChallenge](https://docs.traefik.io/https/acme/#httpchallenge) in [Traefik](https://traefik.io) and [Let's Encrypt](https://letsencrypt.org) to an [ACME DNS-01 or dnsChallenge](https://docs.traefik.io/https/acme/#dnschallenge). The problem with the old _HTTP-01_ or _httpChallenge_ is that it requires the creation of a valid and widely accessible "A" record in our DNS _before_ the creation of a cert; the record has to be in place so that the _Let's Encrypt_ CA-server can find it to confirm that the request is valid.  However, doing this puts the cart-before-the-horse, so-to-speak, since we like to have a valid cert in place _before_ we add a new DNS record.

Just like my old [dockerized-server](https:/github.com/McFateM/dockerized-server) configuration, this project revolves around a workflow that will setup a "Dockerized" server complete with _Traefik_, _Portainer_, and _Who Am I_. Like its predecessor, it should be relatively easy to add additional services or application stacks to any server that is initially configured using this package.  For "static" servers have a look at my [docker-bootstrap Workflow ](https://dlad.summittdweller.com/en/posts/posts/008-docker-bootstrap-workflow/) for an example.

| All of my associated research and testing for this issue can be found in a _OneTab_ at https://www.one-tab.com/page/9E_29YLjSGa9iAeckxMbIQ |
| --- |

To overcome the _HTTP-01 challenge_ issue mentioned above, a colleague of mine at _Grinnell College_ suggested we move to a _DNS-01 challenge_, and formulated a propsal to do so.

## DNS-01 Proposal

My colleague's proposal reads like this:

```
The proposed design uses CNAME following so that TXT records can be created for the grinnell.edu domain in a custom (non-grinnell.edu) domain.  On your side, the initial steps will be similar to what we do now.  When you need a new host record, a ticket should be created requesting example.grinnell.edu, and with a note that you will need Let’s Encrypt verification.  In order for CNAME following to work, a CNAME in the college’s external DNS must first be created.  This record will follow the format of _acme-challenge.example.grinnell.edu, and will point to a custom domain (le-verify.info or something similar).  We will register this custom domain name with Azure DNS and utilize a service principal account in Azure that will have permission to create TXT records in that custom domain.  We will then give you a key to that service principal account so that you can configure Traefik to create the TXT records automatically as a part of the Let’s Encrypt verification process.  When Let’s Encrypt goes to find the _acme-challenge.example.grinnell.edu record, it will be forwarded to the custom domain, see the TXT record, and then approve and sign the certificate for example.grinnell.edu.
 
I have tested this using an NGINX ingress controller, but the documentation for Traefik shows that it supports the same kind of configuration.
...
Here is some documentation that may explain things better than I have:
 
CNAME Following
https://letsencrypt.org/2019/10/09/onboarding-your-customers-with-lets-encrypt-and-acme.html
 
An Example Ingress Controller’s Implementation of DNS verification:
https://docs.traefik.io/https/acme/#dnschallenge
```

## April: DNS-01 Troubles

When attempting to implement the proposal outlined above we got back some odd errors. My record of the result can be found [in this Gist](https://gist.github.com/McFateM/095eb6cd798f8c9807de7e0c0024cf62).

## May: Moving to Traefik v2

All of the above material was generated using [My dockerized-server Config](https://dlad.summittdweller.com/en/posts/042-my-dockerized-server-config/) running [Traefik](https://traefik.io) version 1.x. Since the Traefik community has moved on it seemed prudent to try upgrading the server to Traefik v2.x before posting a lot of debug info involving the previous version. So, that's what I did, upgrade to Traefik 2.2.1.

## docker-traefik2-host

Our move to _Traefik v2.2.1_ is captured in a new Dockerized-server configuration I call [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host). The key to obtaining certs in [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host) lies in the [./traefik/data/traefik.yml](https://github.com/DigitalGrinnell/docker-traefik2-host/blob/master/traefik/data/traefik.yml) file and corresponding _.env_ file which is NOT stored in GitHub. _traefik.yml_ inlcudes a section of configuration like this:

```
# ## for HTTP-01 challeng
# certificatesResolvers:
#   http:
#     acme:
#       # - Uncomment caServer line below to run on the staging let's encrypt server.  Leave comment to go to prod.
#       caServer: https://acme-staging-v02.api.letsencrypt.org/directory
#       email: digital@grinnell.edu
#       storage: acme.json
#       httpChallenge:
#         entryPoint: http

## for DNS-01 challenge
certificatesResolvers:
 http:
   acme:
     # - Uncomment caServer line below to run on the staging Let's Encrypt server.  Leave comment to go to prod.
     #caServer: https://acme-staging-v02.api.letsencrypt.org/directory
     email: digital@grinnell.edu
     storage: acme.json
     dnsChallenge:
       provider: azure
```

The above configuration is intended to implement either an _HTTP-01_ or _DNS-01_ challenge, but never both. In the above example the host is being configured to use a _DNS-01_ challenge, and it uses the _Let's Encrypt_ production server since the "caServer" declaration of "staging" is commented out.

## Failure on Static.Grinnell.edu

Unfortunately, the configuration shown above, when applied to the _static.grinnell.edu_ host, failed even after being tweaked and tested several times. Along the way I eventually ran into _Let's Encrypt's_ rate limit and got shut out of further testing for one week. During that week I attempted to implement this configuration on a different host, namely _dgdocker3.grinnell.edu_, where I encountered different failures.

## Testing on DGDocker3.Grinnell.edu

_DGDocker3.Grinnell.edu_ is a CentOS 7.8 host running Docker with my [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host) resident in `/opt/containers`. It sits behind the college firewall so VPN access is required, and it's configured to provide the following services:

| Stack and Service | Details | Address |
| ---               | ---     | ---     |
| landing-landing   | Dockerized Hugo static site | https://dgdocker3.grinnell.edu/ |
| traefik           | Traefik v2.2.1 with dashboard | https://dgdocker3.grinnell.edu/dashboard/ |
| portainer         | Portainer v1.23.2 dashboard | https://dgdocker3.grinnell.edu/portainer/ |

Each service has its own subdirectory and `docker-compose.yml` file located there. All can be found in [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host). The all-important [./traefik/data/traefik.yml](https://github.com/DigitalGrinnell/docker-traefik2-host/blob/master/traefik/data/traefik.yml) is also there.

### Scripts

The [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host) project also features a pair of scripts to help facilitate testing. They are:

| Script | Purpose |
| ---    | ---     |
| destroy.sh | Stops and removes all running containers, images and networks. Destroys the `./traefik/data/acme.json` file and restores it to pristine condition. |
| restart.sh | Restarts all the services with verbose (`--debug`) logs echoed from Traefik's `/var/log/traefik.log` file. |

### Test 1 - HTTP-01 Challenge Using LE's Staging Server

My first test will attempt a clean restart of all services using LE's **staging** CA-server and **HTTP-01 challenge**. The './traefik/data/traefik.yml' file for this test is reflected in [this gist](https://gist.github.com/McFateM/1d15b4e2bd992d1883de5f12e31dc6c3).

I initiated this test as _root_ using:

```
cd /opt/containers
./destroy.sh
./restart.sh
```

The result of this test shows all three services are working and are reachable via VPN at the addresses listed above, but **none have valid certs** so they all require an exception. This is to be expected when using LE's "staging" CA-server, but it seems there is more to this outcome since some errors are present.

The log and resulting _acme.json_ from this test can be seen in [this gist](https://gist.github.com/McFateM/dd5e7b016ccfd3d71b91f5c8602c3f33), and the first errors encountered state that:

```
time="2020-05-17T13:09:14-04:00" level=debug msg="http: TLS handshake error from 132.161.249.251:51447: remote error: tls: bad certificate"
time="2020-05-17T13:09:14-04:00" level=debug msg="http: TLS handshake error from 132.161.249.251:51448: remote error: tls: bad certificate"
```

| Since this test appears to have failed "unexpectedly", I'm going forego the next test that would attempt the same but using LE's "production" CA-server, and proceed straight to DNS-01 testing. |
| --- |

### Test 2 - DNS-01 Challenge Using LE's Staging Server

My next test will attempt a clean restart of all services using LE's **staging** CA-server and **DNS-01 challenge**. The './traefik/data/traefik.yml' file for this test is reflected in [this gist](https://gist.github.com/McFateM/4b093a4f7e0ba29723495f4a0458717f).


I initiated this test as _root_ using:

```
cd /opt/containers
./destroy.sh
./restart.sh
```

The result of this test shows all three services are working and are reachable via VPN at the addresses listed above, but **none have valid certs** so they all require an exception. This is to be expected when using LE's "staging" CA-server, but it seems there is more to this outcome since some errors are present.

The log from this test can be seen in [this gist](The result of this test shows all three services are working and are reachable via VPN at the addresses listed above, but **none have valid certs** so they all require an exception. This is to be expected when using LE's "staging" CA-server, but it seems there is more to this outcome since some errors are present.

The log from this test can be seen in [this gist](https://gist.github.com/McFateM/dd5e7b016ccfd3d71b91f5c8602c3f33), and the first error encountered states that:

```
time="2020-05-17T13:43:01-04:00" level=debug msg="No ACME certificate generation required for domains [\"dgdocker3.grinnell.edu\"]." providerName=http.acme routerName=traefik-secure@docker rule="Host(`dgdocker3.grinnell.edu`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
time="2020-05-17T13:43:01-04:00" level=debug msg="http: TLS handshake error from 132.161.249.251:52136: remote error: tls: bad certificate"
```

| Since this test appears to have failed in the same "unexpected" manner as Test 1, I'm going forego subsequent tests until this can be resolved. |
| --- |

## Returning to Static.Grinnell.edu

Since more than a week has passed since I hit LE's rate limit, I thought that this evening I'd try my luck with `static.grinnell.edu` again, this time with an HTTP-01 challenge and LE's production server. It worked, except that some of my stack_service names were incorrect. What I really wanted to learn from this is what an `acme.json` file should look like when valid certs have been created. The answer can be found in [this gist](https://gist.github.com/McFateM/4f1524627a5ebbcbeae299d43d002640).

Note that I was ultimately able to get all the services on `static.grinnell.edu` working properly, with valid certs, by stopping (see below) those containers that had incorrect names, fixing the router's service name in each corresponding `docker-compose.yml`, then doing a new `docker-compose up -d` to restart things. No additional cert validation or modification of _Traefik_ was needed.

  - Stopping containers... `docker stop [id]; docker rm -v [id]`
  - Correct `service-stack` names... the correct name convention is `service-stack` where _service_ is the name of the service, not the container name, and _stack_ is the name of the sub-directory

### Test 3 - Static to DNS-01 Production

This morning, May 18, 2020, I switched the configuration on `static.grinnell.edu` back to DNS-01 using LE's production CA-server, and tried again.  The log from this test as well as an obfuscated `acme.json` can be seen in [this gist](https://gist.github.com/McFateM/4ad29fa0a30e2a3fc5ef3b4b566a031a).

The sites all appear to work, except for the landing page at https://static.grinnell.edu/ which returns a 404, but none have valid certs and therefore require browser security exceptions again. I found the landing page problem in `restart.sh`, fixed it, and did a `docker-compose up -d` in `./landing` to get that page running.

The first error encountered in the log is at line 243 and it reads:

>time="2020-05-18T09:21:35-05:00" level=error msg="Unable to obtain ACME certificate for domains \"static.grinnell.edu\": cannot get ACME client azure: Get \"http://169.254.169.254/metadata/instance/compute/subscriptionId?api-version=2017-12-01&format=text\": dial tcp 169.254.169.254:80: i/o timeout" providerName=http.acme routerName=traefik-secure@docker rule="Host(`static.grinnell.edu`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"

### Test 4 - Replace Invalid Certs with Valid

This test is really a remediation step as in it I'll replace the now "broken" `./traefik/data/acme.json` file with the working copy (`./traefik/data/http-01-acme.json`) that was created in "Returning to Static.Grinnell.edu" above. I do this on the `static.grinnell.edu` host as _root_ like so:

```
cd /opt/containers/traefik/data
rm -f acme.json
cp -f http-01-acme.json acme.json
```

Unfortunately, the old certs don't match the new services so they are invalid and the sites all require browser security exceptions again.

### Test 5 - Static Returned to Staging with DNS-01

In this test I've moved the values of our Azure `.env` variables directly into `traefik.yml` and I have prudently switched the process back to using LE's staging server.  The complete log and obfuscated `acme.json` are in [this gist](https://gist.github.com/McFateM/3f4bc94a6d1031debcf2dfbec305093b).

The log contains a series of errors like the one below, and all seven sites are up and running but with browser security exceptions still required.

> time="2020-05-18T11:58:02-05:00" level=debug msg="Serving default certificate for request: \"static.grinnell.edu\""
> time="2020-05-18T11:58:02-05:00" level=debug msg="http: TLS handshake error from 132.161.249.72:57914: remote error: tls: bad certificate"

### Test 6 - Static Returned to Production with HTTP-01

I need to put `static.grinnell.edu` back to work and return to testing on `dgdocker3.grinnell.edu`, so this test will return _static_ to using the LE production server and HTTP-01 challenge. The complete log and obfuscated `acme.json` are in [this gist](https://gist.github.com/McFateM/d504088f8df79ebf28bb70eec03500d8).

All seven sites are working, and have valid certs. That's my cue to move back to `dgdocker3.grinnell.edu`.

Note that even with working sites and new, valid certs I still see a series of errors like this one:

> time="2020-05-18T12:52:18-05:00" level=debug msg="Serving default certificate for request: \"static.grinnell.edu\""
> time="2020-05-18T12:52:18-05:00" level=debug msg="http: TLS handshake error from 132.161.249.72:60953: remote error: tls: bad certificate"

So, apparently those errors have nothing to do with the challenge? The plot thickens.

## Back to DGDocker3

The debug messages (not errors) like `TLS handshake error from 132.161.249.72:60953: remote error: tls: bad certificate` seem to be present in every test I've run, even when valid certs are issued. So it seems safe to assume they are not critical.  To try and work around them I'm going to return my testing to `dgdocker3.grinnell.edu` and start anew there with Test 7.

### Test 7 - DGDocker3 Test with Staging and DNS-01

This test will reset `dgdocker3.grinnell.edu` using LE's staging server and our DNS-01 challenge just as it was configured in Test 6 above. The complete log and obfuscated `acme.json` are in [this gist](https://gist.github.com/McFateM/b525152c822cdb3dd85d5214c06b1d8e).

There were no errors or warnings in the log, and all three sites are working without valid certs, therefore all require browser security exceptions, but that is to be expected since the LE staging server was used. The mysterious "TLS handshake error" debug messages do still appear. In light of this, my next test will use the same configuration, but switched back to DNS-01.

### Test 8 - DGDocker3 Test with Production and DNS-01

This test will reset `dgdocker3.grinnell.edu` using LE's production server and our DNS-01 challenge just as it was configured in Test 7 above. The complete log and obfuscated `acme.json` are in [this gist](https://gist.github.com/McFateM/bcc9bfcd79ba5f54d569cad4aaf30457).

Again, there were no errors or warnings in the log, and all three sites are working, but they still have no valid certs, therefore all require browser security exceptions. Again, the "TLS handshake error" messages are still present.  **What are those meant to tell us?**

And that's a good place to break... because I'm exhausted and can't imagine what to try next.  Too many questions here, not enough answsers.  :frowning:
