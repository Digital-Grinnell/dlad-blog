 ---
title: "Creating a WARC from a Wordpress Clone"
publishdate: 2022-09-06
draft: false
tags:
  - Reclaim Hosting
  - Wordpress
  - WARC
  - web archive
  - comm.sites.grinnell.edu
  - //Storage
  - ReplayWeb.page
  - rootstalk-archive
supersedes: posts/082-here-there-be-warcs/
---

This blog post chronicles portions of a process used to restore and subsequently WARC (the creation of a web archive) a Communication Department website that had been retired.  The website content of interest included material describing plans for the recently-completed HSSC and Administration Building projects.

During the restoration and WARC process a `.md` document named `WARC-from-comm.sites.grinnell.edu-clone.md` was created and it's contents are presented here.

# Creating a WARC from a Clone of `comm.sites.grinnell.edu`

In July 2022 a new "clone" of the original `comm.sites.grinnell.edu` web site project -- a _Wordpress_ copy that contains posts and supporting information regarding campus construction projects including the HSSC and Adminissions Center -- was created.  That clone can be found, and administered, from [https://comm.sites.grinnell.edu/clone/wp-admin/index.php](https://comm.sites.grinnell.edu/clone/wp-admin/index.php). 

## Turning Redirection Off

At present, both the [comm.sites.grinnell.edu](https://comm.sites.grinnell.edu) and my clone at [comm.sites.grinnell.edu/clone](https://comm.sites.grinnell.edu/clone) are redirected to [https://www.grinnell.edu/about/leadership/offices-services/institutional-planning/campus-plan](https://www.grinnell.edu/about/leadership/offices-services/institutional-planning/campus-plan).  That's not the site that we want to WARC, so I need to turn redirection off in the `/clone` site so that it can be WARC'd, I hope.

### First Attempt

On the [https://comm.sites.grinnell.edu/clone/wp-admin/tools.php?page=redirection.php](https://comm.sites.grinnell.edu/clone/wp-admin/tools.php?page=redirection.php) page I will "disable" all redirects by selecting all of the listed URLs, then under `Bulk Actions` I'll choose `Disable` click the `Apply` button.  Done.

#### Outcome

Unfortunately, [comm.sites.grinnell.edu/clone](https://comm.sites.grinnell.edu/clone) still redirects to [https://www.grinnell.edu/about/leadership/offices-services/institutional-planning/campus-plan](https://www.grinnell.edu/about/leadership/offices-services/institutional-planning/campus-plan).  :frown:

### Second Attempt

So, now I'm going to delete the old redirection using the same process, but selecting `Delete` rather than `Disable`.  Done.

#### Outcome

Nope, still redirected.

### Third Attempt

I'm going to visit settings and try to point to a new address like `comm-clone.sites.grinnell.edu`.  So, I'll change the `Site Address (URL)` field from `http://comm.sites.grinnell.edu/clone` to `http://comm-clone.sites.grinnell.edu`.

#### Outcome

Nope, no longer redirected but I got a big `SORRY` message saying the site could not be found.

# Enlisting Help from DLAC

Clearly, my attempts to "clone" the old comm site in a form that could be successfully archived had failed, so I turned to the `Digital Liberal Arts Collaborative` (DLAC) and their `Reclaim Hosting` admin powers.

The next section of this document is a thread of emails captured as a PDF document and  subsequently converted to Markdown format for publication here.

## DLAC Email Thread

Thread elements are in reverse-chronological order.

---

**Subject:** Re: email  
**Date:** Friday, July 29, 2022 at 3:09:11 PM Central Daylight Time  
**From:** Pelzel, Morris  
**To:** Rodrigues, Elizabeth, McFate, Mark  

OK, should be ready to go ... https://dg-dev.sites.grinnell.edu.  

Mo  

Dr. Morris Pelzel  
 
---

**From:** Rodrigues, Elizabeth <rodrigue8@grinnell.edu>  
**Sent:** Friday, July 29, 2022 11:07 AM  
**To:** Pelzel, Morris <pelzelmo@grinnell.edu>; McFate, Mark <mcfatem@grinnell.edu>  
**Subject:** Re: email  

Thanks, Mo, and I'm sorry about the jargon. A WARC is a web archive file format created through a
process of crawling a site.  

If we could clone the site to dg-dev directly, I think that would be our best bet for a next thing to try.
Basically, we want to be able to crawl the site as it was originally published in wordpress.  

Elizabeth Rodrigues, PhD  

---

**From:** Pelzel, Morris <pelzelmo@grinnell.edu>  
**Sent:** Friday, July 29, 2022 11:04 AM  
**To:** Rodrigues, Elizabeth <rodrigue8@grinnell.edu>; McFate, Mark <mcfatem@grinnell.edu>  
**Subject:** Re: email  

Hi Mark and Liz,  

I'm back in town and taking a look at this. I'm trying to get clear for myself
exactly what it is that you want to do, so it may be best for us to meet in person
sometime next week to sort things out. When you refer to WP "modules" Mark,
I assume you mean plug-ins?  

In general, we handle redirects, backups, restorations, migrations, and the like,
in cPanel, and not in WordPress itself. It's just cleaner and simpler to do it that
way.  

Perhaps the issue is that we set up the clone as a subdirectory instead of a
subdomain. As a subdirectory, the clone remains part of the original domain, so
the redirect cannot be removed. If we instead created it as a subdomain, then it
would appear in the list of domains in the cPanel Domains module, and we
could then remove the redirects for that subdomain.  

But would it not be easier just to clone the site directly in dg-
dev.sites.grinnell.edu? We should be able to clone a WP site from one cPanel
account (comms) into another (dg-dev). Then we should be able to turn off any
redirects.  

Let me know if I am on the right track here.  

Also ... I do not know (and perhaps do not need to know) what WARC is.  

Thanks,  

Mo  

---
**From:** Rodrigues, Elizabeth <rodrigue8@grinnell.edu>  
**Sent:** Wednesday, July 27, 2022 4:50 PM  
**To:** McFate, Mark <mcfatem@grinnell.edu>; Pelzel, Morris <pelzelmo@grinnell.edu>  
**Subject:** Re: email  

And I'd add that the pain point here is the redirect that Comm currently has set up. It doesn't appear
to be changeable from within the cloned copy, and when Mark tried reconstructing the site on his own
subdomain using Updraft, the homepage worked but all the links still pointed back to the cloned
comm site with the apparently baked in redirect.  

Is getting a copy with no redirect possible? Or does comm have to stop the redirect from within their
own cPanel long enough for us to copy it?  

By redirect, I mean comm.sites.grinnell.edu now redirects
to https://www.grinnell.edu/about/leadership/offices-services/institutional-planning/campus-plan.
We have confirmed that the WP site has unique content, and on top of that, WARCing the redirected address leads to WARCing the whole college site...as we learned.  

Thanks for any insight you have!  
Liz  

---

**From:** McFate, Mark <mcfatem@grinnell.edu>  
**Sent:** Wednesday, July 27, 2022 2:57 PM  
**To:** Pelzel, Morris <pelzelmo@grinnell.edu>  
**Cc:** Rodrigues, Elizabeth <rodrigue8@grinnell.edu>  
**Subject:** Re: email  

Good afternoon, Mo.  

I’ve been waiting on some ITS changes to DG today and turned my attention
back to comm.sites.grinnell.edu/clone for a bit. In that site’s wp-admin I tried
turning off, then deleting, the “Redirection” module, but that had no effect.  

So, I tried changing the site’s “sekngs” to have it resolve to a different URL,
and that didn’t work. Then I tried changing it to resolve to my new https://dg-
dev.sites.grinnell.edu address, but that also failed.  

Liz suggested trying the “Updraft” module to migrate the site and provided an
article with guidance. Once I’d completed the prescribed backup process, I
tried to restore the backup into dg-dev.sites.grinnell.edu, but was warned that
the free version of “Updraft” is for “backup only”, and not to be used for
“migration”. The migration add-on costs extra, or one must purchase Updraft
Premium. 8^(  

Well, I didn’t like that answer so I proceeded with the restoration anyway.
The outcome was interesting... I got a copy of the old comm.sites.grinnell.edu
home page at https://dg-dev.sites.grinnell.edu, but all of the navigation was
still redirected to their new site, and some nav elements didn’t work at all.  

So, that was not a site that I can WARC as intended.  

The other effect of restoring from backup was that I lost access to dg-dev.sites.grinnell.edu/wp-admin, since that address always asked me to login and then took me back to comm.sites.grinnell.edu/wp-admin again. So, I opened the cPanel for dg-dev.sites.grinnell.edu and uninstalled WordPress, and have since re-installed a pristine copy and I have wp-admin access there once again.  

Through all of this we looked at different means of properly “migrating” the
old WordPress site at comm.sites.grinnell.edu/wp-admin to my new domain
at dg-dev.sites.grinnell.edu, but everything I’ve found so far suggests that
there is no easy DIY process, there are only $$$$ options available. Even
Reclaim’s own discussion about migration suggests the same...  

https://reclaimhostig.com/migration-assistance/.  

So, I’m wondering if you have a recommendation for me.... How can we easily
get the WordPress content that’s in comm.sites.grinnell.edu migrated to dg-dev.sites.grinnell.edu?  

Thanks for any advice you can offer. Take care.  

-Mark M.  

---
**From:** McFate, Mark <mcfatem@grinnell.edu>  
**Date:** Monday, July 25, 2022 at 10:44 AM  
**To:** Pelzel, Morris <pelzelmo@grinnell.edu>  
**Subject:** Re: email  

Ok, thanks Mo. No worries, and no rush. Take care.  

-Mark M.  

---
**From:** Pelzel, Morris <pelzelmo@grinnell.edu>  
**Date:** Monday, July 25, 2022 at 10:42 AM  
**To:** McFate, Mark <mcfatem@grinnell.edu>  
**Subject:** email  

Mark,  

I'm setting up the domain you requested. If you just received an email about
your password, please ignore it...I accidentally left a check box checked (that
should have been unchecked).  

I'll send you more information in a moment.  

Mo  

---

# Attempting to WARC `https://dg-dev.sites.grinnell.edu`

DLAC was able to properly clone the old comm site into my https://dg-dev.sites.grinnell.edu Wordpress space, without redirection, so my hope was restored.  I set about creating a WARC of that site...

## First `wget` from My MacBook Pro

```
wget --warc-file=living-and-learning-community-web-archive --recursive --level=5 --warc-cdx --page-requisites --html-extension --convert-links --execute robots=off --directory-prefix=. -x /solr-search --wait=10 --random-wait https://dg-dev.sites.grinnell.edu/
```

```
FINISHED --2022-08-01 12:08:09--
Total wall clock time: 18m 19s
Downloaded: 94 files, 11M in 1m 13s (156 KB/s)
```

## Second `wget` from iMac

```
wget --warc-file=living-and-learning-community-web-archive --recursive --level=10 --warc-cdx --page-requisites --html-extension --convert-links --execute robots=off --directory-prefix=. -x /solr-search --wait=10 --random-wait https://dg-dev.sites.grinnell.edu/
```

```
FINISHED --2022-08-01 14:04:25--
Total wall clock time: 16m 13s
Downloaded: 94 files, 11M in 7.3s (1.54 MB/s)
```

## Outcome

Since both `wget` operations returned 94 files it's safe to assume that constitutes a complete archive.  

On the iMac the process produced the following `.cdx` index and `.warc.gz` compressed archive...

```
╭─markmcfate@MAD25W812UJ1G9 ~ ‹ruby-2.3.0›
╰─$ ls -alh living*
-rw-r--r--  1 markmcfate  staff    35K Aug  1 14:04 living-and-learning-community-web-archive.cdx
-rw-r--r--  1 markmcfate  staff   9.1M Aug  1 14:04 living-and-learning-community-web-archive.warc.gz
```

# WARC is NOT Complete

Unfortunately, the WARC mentioned above is woefully incomplete because **the WordPress reconstruction of the old site is also incomplete**.  A lot of the old content regarding projects like the HSSC, Adminssions Center, and campus Landscaping were still "published" in the site, but excluded from navigation so the `wget...` command used to produce the WARC was unable to "find" them.

I enlisted the help of Donna D., an original author of the site, to reassemble things as best we could.  Now that that's done (8-Aug-2022) I'm kicking off a new WARC process on iMac 8660, like so...

```
╭─markmcfate@MAD25W812UJ1G9 ~/dg-dev.sites.grinnell.edu ‹ruby-2.3.0›
╰─$ time wget --warc-file=living-and-learning-community-web-archive --recursive --level=10 --warc-cdx --page-requisites --html-extension --convert-links --execute robots=off --directory-prefix=. -x /solr-search --wait=10 --random-wait https://dg-dev.sites.grinnell.edu/
Opening WARC file ‘living-and-learning-community-web-archive.warc.gz’.

/solr-search: Scheme missing.
--2022-09-08 13:00:47--  https://dg-dev.sites.grinnell.edu/
Resolving dg-dev.sites.grinnell.edu (dg-dev.sites.grinnell.edu)... 165.227.97.167
Connecting to dg-dev.sites.grinnell.edu (dg-dev.sites.grinnell.edu)|165.227.97.167|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Saving to: ‘./dg-dev.sites.grinnell.edu/index.html’

     0K .......... .......... .......... .......... ..........  314K
    50K .......... .......... .......... .......... ....       6.78M=0.2s

2022-09-08 13:00:48 (569 KB/s) - ‘./dg-dev.sites.grinnell.edu/index.html’ saved [96460] 
...
Converting links in ./dg-dev.sites.grinnell.edu/wp-content/themes/twentyseventeen/assets/css/blocks.css?ver=20220524.css... nothing to do.
Converting links in ./dg-dev.sites.grinnell.edu/wp-content/plugins/cool-timeline/assets/css/ctl_styles.min.css?ver=2.4.4.css... nothing to do.
Converting links in ./dg-dev.sites.grinnell.edu/wp-content/plugins/cool-timeline/assets/css/prettyPhoto.css?ver=2.4.4.css... 100.
37-63
Converted links in 198 files in 2.6 seconds.
wget --warc-file=living-and-learning-community-web-archive --recursive         30.23s user 31.62s system 0% cpu 2:59:10.63 total
```

## Success!

The output from the above operation includes `/Users/markmcfate/dg-dev.sites.grinnell.edu/living-and-learning-community-web-archive.warc.gz` and a corresponding `.cdx` file both stored on iMac 8660.  ~~Both files have also been copied to my OneDrive so the `.gz` file also exists at `/Users/markmcfate/Library/CloudStorage/OneDrive-GrinnellCollege/iMac-Home-Folder-07-Sep-2022/living-and-learning-community-web-archive.warc.gz`.~~

## Moving WARCs to //Storage

I've striked the mention of _OneDrive_ above because on my Macs I just don't trust _OneDrive_ anymore.  Today I created a new `WARCs` folder in my _OneDrive_, or at least I thought I did, in order to consolidate my storage of WARC archives.  Well, the folder structure that I see in my _OneDrive_ on iMac 8660 doesn't look the same as on my GC MacBook, MA01713.  So, like I said, I just don't trust it.

I do have a reliable home for WARCs in `//Storage`, the college's age-old network storage, so that's where I'm going to put these precious files, at least for now.  So I've mounted `//Storage/Library/mcfatem` on my MacBook as verified below...

```
╭─mcfatem@MAC02FK0XXQ05Q /Volumes/Library/mcfatem
╰─$ pwd
/Volumes/Library/mcfatem
```

_Note: I keep a mount link in `Finder` on every Mac I have, it reads something like this under the `Go | Connect to Server...` menu: `smb://storage/library/mcfatem`_.

## Capturning a WARC of https://rootstalk-archive.grinnell.edu

While working on this WARC process I discovered that a very old website, https://rootstalk-archive.grinnell.edu, was still "active" (although the site certificates were now invalid) but overdue to be retired.  So, I assumed it would be a good idea to capture a WARC.  Due to the expired certificate I used this command on iMac 8660 to capture the site:

```
time wget --warc-file=rootstalk-archive-WARC --recursive --level=10 --warc-cdx --page-requisites --html-extension --convert-links --execute robots=off --directory-prefix=. -x /solr-search --wait=10 --random-wait --no-check-certificate https://rootstalk-archive.grinnell.edu/
```

The result is a pair of files, almost 2.5 GB in size, named:

```
-rwx------@ 1 markmcfate  staff   1.0M Sep 14 23:48 rootstalk-archive-WARC.cdx
-rwx------@ 1 markmcfate  staff   2.4G Sep 14 23:48 rootstalk-archive-WARC.warc.gz
```

### //Storage WARC Contents

All of the aforementioned WARC capture files, and more, are now stored in `//Storage` as shown below...

```
╭─markmcfate@MAD25W812UJ1G9 /Volumes/mcfatem/warcs ‹ruby-2.3.0›
╰─$ ls -alh
total 6481568
drwx------+ 1 markmcfate  GRIN\Domain Users    16K Sep 16 10:07 .
drwx------+ 1 markmcfate  GRIN\Domain Users    16K Jul 13 10:23 ..
-rwx------@ 1 markmcfate  staff               361K Sep  8 15:59 living-and-learning-community-web-archive.cdx
-rwx------@ 1 markmcfate  staff               556M Sep  8 15:59 living-and-learning-community-web-archive.warc.gz
-rwx------+ 1 markmcfate  staff                74K Oct 27  2021 mime-and-me.warc.cdx
-rwx------+ 1 markmcfate  staff               101M Oct 27  2021 mime-and-me.warc.warc.gz
-rwx------@ 1 markmcfate  staff               1.0M Sep 14 23:48 rootstalk-archive-WARC.cdx
-rwx------@ 1 markmcfate  staff               2.4G Sep 14 23:48 rootstalk-archive-WARC.warc.gz
-rwx------@ 1 markmcfate  staff               621K Sep 14 14:36 wget-log
```

## Verified Using https://replayweb.page

I turned to [ReplayWeb](https://replayweb.page) in order to confirm the validity of the two "new" WARCs listed above.  Using that tool I was able to successfully load and subsequently browse both of the most recently captured WARCs, specifically...

  - https://replayweb.page/?source=file%3A%2F%2Fliving-and-learning-community-web-archive.warc.gz#view=resources&urlSearchType=prefix&url=https%3A%2F%2Fdg-dev.sites.grinnell.edu%2F&ts=20220908180047, and
  - https://replayweb.page/?source=file%3A%2F%2Frootstalk-archive-WARC.warc.gz#view=resources&urlSearchType=prefix&url=https%3A%2F%2Frootstalk-archive.grinnell.edu&ts=20220914203341
   
_Note that, because of its size, the `ReplayWeb` rendering of `rootstalk-archive-WARC.warc.gz` takes a very, very, very long time to load and even longer to render!_

