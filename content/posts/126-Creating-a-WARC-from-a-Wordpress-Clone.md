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


## First `wget` from My MacBook Pro

```
wget --warc-file=living-and-learning-community-web-archive --recursive --level=5 --warc-cdx --page-requisites --html-extension --convert-links --execute robots=off --directory-prefix=. -x /solr-search --wait=10 --random-wait https://dg-dev.sites.grinnell.edu/
```

```
FINISHED --2022-08-01 12:08:09--
Total wall clock time: 18m 19s
Downloaded: 94 files, 11M in 1m 13s (156 KB/s)
```

## Second `wget`	 from iMac

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

# Enlisting Help from DLAC

All attempts to "clone" the old comm site in a form that could be successfully archived had failed, so we turned to the `Digital Liberal Arts Collaborative` (DLAC) and their `Reclaim Hosting` admin powers.

The remainder of this document includes a thread of emails captured and presented as a PDF document.

## DLAC Email Thread

{{% embed-pdf "../../pdfs/comm-sites-WARC-resolution.pdf" %}}
