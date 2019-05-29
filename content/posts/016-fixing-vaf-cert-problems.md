---
date: 2019-05-29T10:45:11-06:00
title: Fixing the VAF Cert Problem
---

True to form, **just after** posting my [lengthy description of VAF cert problems](posts/working-with-lets-encrypt) I figured out what was wrong and how to fix it.  Naturally, **just after**.

So, the root of my _VAF_ woes stemmed from the fact that _Let's Encrypt_, upon my request, had previously issued an untrusted cert for https://vaf.grinnell.edu (because I used the staging environment during development of this blog), and I was unable to find it or override it with a trusted cert.  I was under the impression that in my workflow the cert was being stored inside one of my Docker containers... and it was.  But I couldn't fathom why the untrusted cert seemed to "persist", even though I had deleted and regenerated those containers many times. Hmmm...

All of this was compounded by the fact that in my configuration the _Traefik_ container is built from "scratch" so that it is very "lean".  That essentially means there's no shell in the container, so I can't just do `docker exec -it traefik_proxy sh` to open a terminal and look inside.

Finally, this morning, I took a hard look at the `files/docker-compose.yml` in my [docker-bootstrap](https://github.com/McFateM/docker-bootstrap) project and it dawned on me... that workflow explicitly saves certs into a protected `/root/acme.json` file as part of the `traefik_proxy` service configuration, like so:

```
proxy:
  container_name: traefik_proxy
  image: traefik
  command: >-
    --docker --logLevel=INFO \
    ...
    --acme.storage="/root/acme.json" \
    ...
```

That's common enough.  **But why would that data persist even when I rebuild `traefik_proxy`?**   

What I didn't realize, until this morning, was that elsewhere in `files/docker-compose.yml` there's this:

```
proxy:
  ...
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /dev/null:/traefik.toml
    - /root/acme.json:/root/acme.json   
```

That last line is the **key**!  It's telling the configuration that `/root/acme.json` **should persist on the SERVER** and map to `/root/acme.json` inside the `traefik_proxy` container.  Duh, that's where the certs live...and **persist**.

The steps I took to fix this, from a terminal on `static.grinnell.edu`, were:

```
root@static:~# cp -f acme.json acme.json.bak
root@static:~# rm -f acme.json
root@static:~# touch acme.json
root@static:~# chmod 500 acme.json
root@static:~# docker stop $(docker ps -q); docker rm -v $(docker ps -qa); docker system prune
```

The first four lines above made a backup of `acme.json`, just in case, then removed and replaced it with a pristine, empty file with proper permissions.  The last line stopped all of the Docker containers running on the server, removed them and their associated volumes, then pruned away all remnants (images, networks, etc.) of those containers.

After this I started rebuilding the server and services using the process documented in [docker-bootstrap Workflow](posts/docker-bootstrap-workflow).  Problem solved!  Woot!  Along the way I watched the process create fresh, new, **trusted** certs in the server's new `/root/acme.json` file.

And that's a wrap.  Until next time...
