---
title: "Adding `.htaccess` to Apache Container `/tmp` Directory"
date: 2021-04-14T15:23:45-05:00
publishdate: 2021-04-14
draft: false
emoji: true
tags:
    - tmp
    - temporary
    - Apache
    - .htaccess
---

For some time now we've had a problem lurking in [Digital.Grinnell](https://digital.grinnell.edu), when large files are opened for viewing or download one of the _DG_ services makes a temporary copy of the file in the _Apache_ container's `/tmp` directory.  Locally, and in staging I've debugged the code that is responsible for removing the temporary file once the operation is complete. Running locally or in staging the process does its job, the temporary files get deleted soon after creation, but this never happens in production.  The result, our root disk on the production server fills up after a few days of use, and the server stops serving content.  Even more sinister, the server doesn't crash and restart -- a condition that would also clear the offending `/tmp` files -- it doesn't even report a fatal error, it just refuses to serve content, which is really its only function. Very frustrating indeed!

So I've set a reminder to bring the _DG_ stack down, gracefully, every few days, and immediately restart it. This works nicely becuase stopping and restarting the stack clears out all temporary files.

## What's Different About Staging?

This afternoon I was poking around in my staging server, [https://dg-staging.grinnell.edu](https://dg-staging.grinnell.edu), and noticed something different in the _Apache_ container's `/tmp` directory there.  The folder contains a `.htaccess` file, one that does NOT exist in production.  Hmmm.

The other **glaring** difference is that in staging the _Apache_ `/tmp` directory is owned by UID `islandora`, as is most everything in staging.  In production, however, that directory is owned by `root`. Hmmmm, very interesting indeed.

## First Attempt, a New .htaccess File

So my first move was to duplicate the `.htaccess` file I found in staging and add it to production's _Apache_ `/tmp` directory.  After watching _DG_ performance for a bit I could see this was having no effect, almost immediately some very large, temporary files started to accumulate.  Rats.

## Changing `/tmp` Ownership

Since the permissions on the `/tmp` directory looked right my next move was to change the ownership of `/tmp`.  I did that after shelling in to the running _Apache_ container, like so:

```
docker exec -it isle-apache-dg bash
cd /
ls -alh
chown -R www-data:www-data tmp
```

## Did That Work?

Only :clock: will tell!  After about 10 minutes time there's no evidence of any temporary files accumulating.  :smile:
