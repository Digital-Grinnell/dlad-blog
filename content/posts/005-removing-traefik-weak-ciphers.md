---
date: 2019-05-10
title: Removing Traefik's Weak Cipher Suites
---

Most of the servers I deploy to and manage here at Grinnell College are now "Dockerized", and all of those use [Traefik](https://traefik.io/) to manage traffic, of course.  Before a web app or server can be opened for access to the world here, it has to pass a vulnerability scan, and I'm not privy to the specifics of that scan. However, I do know that "weak cipher suites" are a common source of failure among my newest servers.  It took a couple of weeks of searching, and trial/error solution attempts to identify the nature and specific source of these weaknesses, and to eradicate them.  In my case [Traefik](https://traefik.io/) was the "source" and the solution was/is to add the following configuration in the applicable `traefik.toml`  or `docker-compose.yml` files, or Docker command:

```
      --entrypoints="Name:http Address::80 Redirect.EntryPoint:https" \
      --entryPoints="Name:https Address::443 TLS TLS.MinVersion:VersionTLS12 TLS.CipherSuites:TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256" \
      --defaultentrypoints="http,https"
```

In this code snippet, pulled from https://github.com/McFateM/docker-bootstrap/blob/master/files/docker-compose.yml, the second `--entryPoints` line holds the key.  That line specifies a `TLS.MinVersion` that excludes most of the older, weak default ciphers.  It also overrides the default suites with a short list of stronger suites.

And that's a wrap.  Until next time...
