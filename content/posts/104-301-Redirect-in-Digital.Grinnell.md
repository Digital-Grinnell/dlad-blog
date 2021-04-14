---
title: "301 Redirect in Digital.Grinnell"
date: 2021-04-14T10:28:31-05:00
publishdate: 2021-04-14
draft: false
emoji: true
tags:
    - "301"
    - Redirect
    - Apache
    - .htaccess
---

A colleague and I were recently sifting through the [Digital.Grinnell](https://digital.grinnell.edu) logs and came across some recurring 404, "page not found", status messages.  404's are not uncommon in _DG_, but these were particularly troubling because they were requests of the form `drupal/fedora/repository/grinnell:162` and `drupal/fedora/repository/grinnell:86`. That's the old, and by that I mean VERY OLD, like _Drupal v6_ vintage from 2012 or 2013, form for an object address. All such references were to some of _DG_'s oldest digital objects, too.  

We tried to figure out where such old address references might be coming from, but we struck out.  I wonder if it's even possible to back-track a request like that given today's [GDPR](https://www.privacypolicies.com/blog/gdpr-privacy-policy/) environment and related privacy practices?

So, in lieu of finding the source of these requests, I did a little research and found [
Redirecting specific pages to new URLs (301 redirects in Drupal)
](https://www.drupal.org/node/38960). It didn't take long to implement an _Apache_ redirect rule based on this document, so that's what I did.  I first implemented a new rule in the `/var/www/html/.htaccess` file on our staging server, `https://dg-staging.grinnell.edu`, and tested it there. It works nicely, so I pushed the change to production and tested again.  Works well there too!

## The 301 Redirect Rule

The addition I made, per the aforementioned document are currently lines 115-124 in https://github.com/Digital-Grinnell/dg-islandora/blob/main/.htaccess.  Like so:

```
RewriteBase /

  ## The following rule lifted from https://www.drupal.org/node/38960
  ## Implemented in April 2021 in order to redirect old object addresses of the form
  ##   drupal/fedora/repository/grinnell:182, to a proper equivalent form like
  ##   islandora/object/grinnell:182
  ##
  # custom redirects
  RewriteRule ^drupal/fedora/repository/(.+)$ https://digital.grinnell.edu/islandora/object/$1 [R=301,L]
  # end custom redirects
```

I used an [Apache mod_rewrite Introduction](https://httpd.apache.org/docs/2.4/rewrite/intro.html) document to refresh my memory regarding _Apache_ rewrite rules and syntax.

Note that the `RewriteBase /` statement was already in the `.htaccess` file, but it was previously commented out.  I saw no harm in activating it, and the document somewhat suggests it should be turned on, so I removed the comment and added the 9 lines that follow it.

## A Definite Plus

One of the things I like most about this solution is reflected in a statement lifted from [301 redirects in Drupal)](https://www.drupal.org/node/38960), specifically:

{{% original %}}
...301 redirects are considered the best way to handle redirected pages, for they inform search engines to update their databases with the new paths. This way, you should not risk your search engine pagerank or lose site visitors with 404 "not found" errors.
{{% /original %}}

## Not Great, But It Works

I say it's not a "great" rule because it assumes anything passed to _DG_ with `drupal/fedora/repository/...` in the address should be redirected to `https://digital.grinnell.edu/islandora/object/...` and that's not explicitly true when I'm working with our staging server, but the intent is to fix a condition that should only exist in production, so it will do.  I did try some more advanced substitution (see below), but it didn't work, so I returned to a simple substitution that does work in production.

### Advanced Rule Fails

This rule, `RewriteRule ^(.+)/drupal/fedora/repository/(.+)$ $1/islandora/object/$2 [R=301,L]`, seemed like a better rule since it doesn't assume the host is `https://digital.grinnell.edu`, but it doesn't work properly. I'm betting some more `RewriteCond` rules would be required to make it so.

## Test It?

If you'd care to test the new rule, just take any of these URLs for a spin in your browser:

  - [https://digital.grinnell.edu/drupal/fedora/repository/grinnell:86](https://digital.grinnell.edu/drupal/fedora/repository/grinnell:86)
  - [https://digital.grinnell.edu/drupal/fedora/repository/grinnell:182](https://digital.grinnell.edu/drupal/fedora/repository/grinnell:182)


And that's a wrap.  Until next time, happy redirecting!
