---
date: 2019-05-28T14:59:22-06:00
title: Working with Let's Encrypt to Generate Certs
---

The workflow I use to create, publish, and update this blog is discussed in three of my earlier posts, namely [docker-bootstrap-Workflow](/posts/docker-bootstrap-workflow), [Building This Blog](/posts/building-this-blog), and [Developing This Blog](/posts/developing-this-blog).  This workflow works nicely in the case of this blog, but my daughter and I created another site, [Visualizing Abolition and Freedom](https://vaf.grinnell.edu), frequently referred to as simply `VAF`, where the same workflow doesn't quite work.  The problem, I believe is with the manner in which I attempted to obtain TLS certs from _[Let's Encrypt](https://letsencrypt.org/)_.

In a nutshell, cyber security policy here at Grinnell College dictates that a site/server be scanned for vulnerabilities and deemed "safe" before we open the firewall to allow traffic from outside the campus network. Prudent practice indeed. However, _Let's Encrypt_ is one such agent and the [HTTP-01 Challenge](https:/letsencrypt.org/docs/challenge-types/) that I use needs access to a site in order to validate any certificate requests I make.  So we sort of have a chicken/egg, _Catch-22_ scenario... *I can't get a valid cert until the site/server is secure and open, and I can't secure or open the site until I have a valid cert*.  

The simple solution is to initially use _Let's Encrypt's_ "[ACME staging environment](https:/letsencrypt.org/docs/staging-environment/)" to obtain a temporary, un-trusted cert.  Once that cert is in place we run vulnerability scans and make changes until the only remaining vulnerability is the un-trusted cert itself.  When we arrive at that point the firewall is configured to accept traffic from off-campus, and we apply for a new, valid, and trusted cert from _Let's Encrypt's_ production environment.

Simple.  But in the case of _VAF_ it doesn't work, yet, with my workflow.

 

And that's a wrap.  Until next time...
