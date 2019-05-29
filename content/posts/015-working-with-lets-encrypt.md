---
date: 2019-05-29T07:39:35-06:00
title: Working with Let's Encrypt to Generate Certs
---

The workflow I use to create, publish, and update this blog is discussed in three of my earlier posts, namely [docker-bootstrap Workflow](/posts/docker-bootstrap-workflow), [Building This Blog](/posts/building-this-blog), and [Developing This Blog](/posts/developing-this-blog).  This workflow works nicely in the case of this blog, but my daughter and I created another site, [Visualizing Abolition and Freedom](https://vaf.grinnell.edu), frequently referred to as simply `VAF`, where the same workflow doesn't quite work.  The problem, I believe is with the manner in which I attempted to obtain TLS certs from _[Let's Encrypt](https://letsencrypt.org/)_.

In a nutshell, information security policy here at Grinnell College dictates that a site/server be scanned for vulnerabilities and deemed "safe" before we open the firewall to allow traffic from outside the campus network. Prudent practice indeed. However, _Let's Encrypt_ is one such agent and their [HTTP-01 Challenge](https:/letsencrypt.org/docs/challenge-types/) that I use needs access to a site in order to validate any certificate requests I make.  So we sort of have a chicken/egg, _Catch-22_ scenario... *I can't get a trusted cert until the site/server is secure and open, and I can't secure or open the site until I have a trusted cert*.  

The simple solution is to initially use _Let's Encrypt's_ "[ACME staging environment](https:/letsencrypt.org/docs/staging-environment/)" to obtain a temporary, un-trusted cert.  Once that cert is in place we run vulnerability scans and make necessary changes until the only remaining vulnerability is the un-trusted cert itself.  When we arrive at that point the firewall is configured to accept traffic from off-campus, and we apply for a new, valid, and trusted cert from _Let's Encrypt's_ production environment.

Simple.  But in the case of _VAF_ it doesn't work, yet, with my workflow. If you examine the diagram I created for the [docker-bootstrap Workflow](/posts/docker-bootstrap-workflow) post on May 15, 2019, you'll see that deploying a site into production is really 2-step process:

  - First the server is prepared by "initializing" it via _docker-bootstrap's_ `./init` command.  This command creates services for _Traefik_, _Watchtower_, and _Portainer_.  This step is performed only once, no matter the number of sites  added to the server in each Step 2.  I believe all of the _ACME_ cert specifications are specified in this step as part of _Traefik's_ configuration; with the URL of each individual site added later in Step 2, as the sites themselves are added. Step 1 knows nothing of the individual sites, like _VAF_ and this blog, that may follow.

    Typical _ACME_ specifications included in Step 1 are:  

      ```yaml
      --acme \
      --acme.caserver="https://acme-v02.api.letsencrypt.org/directory" \
      --acme.acmelogging \
      --acme.dnschallenge=false \
      --acme.entrypoint="https" \
      --acme.httpchallenge \
      --acme.httpChallenge.entryPoint="http" \
      --acme.onhostrule=true \
      --acme.storage="/root/acme.json" \
      --acme.email="digital@grinnell.edu" \
      ```

  - The second step is repeated once for each site to be launched on the server, and it specifies a `docker container run...` command like this _VAF_ example:

      ```bash
      docker container run -d --name vaf \
        --label traefik.backend=vaf \
        --label traefik.docker.network=traefik_webgateway \
        --label "traefik.frontend.rule=Host:vaf.grinnell.edu" \
        --label traefik.port=80 \
        --label com.centurylinklabs.watchtower.enable=true \
        --network traefik_webgateway \
        --restart always \
        --label acme.caserver="https://acme-02.api.letsencrypt.org/directory" \
        mcfatem/vaf
      ```   

Part of the problem here, I believe, is that I'm using a _Traefik_ container built from "scratch", so there's no shell in the image, which means I can't open a terminal inside the container to see what's happening.  

### Exactly when is each cert generated?

That is the question I'm struggling with.  It would seem impossible for certs to be generated in Step 1 when we haven't even identified what an individual site's URL will be yet.  Still, all of the _ACME_ parameters that control cert creation, including the specification of `acme.caserver` are specified in Step 1 as part of the _Traefik_ configuration.  

### Are the _ACME_ parameters in Step 1 buffered for later use in Step 2?

If that is what's happening, how do I switch a site from using the "staging" CA environment to using the "production" CA?  

### Can I provide an `acme.caserver` label as part of Step 2 instead of Step 1?

Maybe the answer is specifying the "production" environment in an `acme.caserver` label during Step 2?  Something like this:

```bash
docker container run -d --name ${NAME} \  
  --label acme.caserver="https://acme-02.api.letsencrypt.org/directory" ...
```

I'm going to put this last notion to the test now.  Wish me luck, and I'll report back here in a few minutes.

### Nope.  Still don't have a trusted cert for _VAF_.  

Next step I believe is to wipe the server clean, pull an `:alpine` image of _Traefik_ (so I can shell in and see more detail), then try to rebuild it all piece-by-piece.

And that's a wrap.  Until next time...
