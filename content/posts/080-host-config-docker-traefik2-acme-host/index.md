---
title: "Host Config: docker-traefik2-acme-host"
publishdate: 2020-06-10
draft: false
tags:
  - Docker
  - Traefik
  - ACME
  - DNS-01
  - docker-traefik2-acme-host
  - docker-compose
  - CNAME
  - NXDOMAIN
---

This post is celebrating the completion (really, is anything ever complete?) of a new server/host/stack deployment project: [docker-traefik2-acme-host](https://github.com/McFateM/docker-traefik2-acme-host). In order to make this post really easy to read, I'm going to wrap it up in one bullet...

  - [README.md](https://github.com/McFateM/docker-traefik2-acme-host/blob/master/README.md)

## Troubleshooting

Should you ever encounter an error like the one below, be sure to ask your IT provider if they created the proper `CNAME` record when creating your DNS entry.

```
[Tue Jun 30 20:53:50 UTC 2020] ohscribe.grinnell.edu:Verify error:DNS problem: NXDOMAIN looking up TXT for _acme-challenge.ohscribe.grinnell.edu - check that a DNS record exists for this domain
```

That turned out to be the source of this error for me when I tried to obtain a cert for `ohscribe.grinnell.edu` on node `DGDocker3`.


And that's a wrap. I am so pleased that this works (and it's not even Friday!)  :smile:
