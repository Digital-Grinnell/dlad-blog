---
title: Resetting Docker
publishdate: 2019-07-27
lastmod: 2019-07-31T13:59:46-05:00
tags:
  - Docker
  - reset
  - prune
---
## This command snippet needs a blog post of its own!

I typically use the following command stream to clean up any Docker cruft before I begin anew. Note: Uncomment the third line ONLY if you want to delete images and download new ones. If you do, be patient, it could take several minutes depending on connection speed.

| Workstation Commands |
| --- |
| docker stop $(docker ps -q) <br/> docker rm -v $(docker ps -qa) <br/> # docker image rm $(docker image ls -q) <br/> docker system prune --force |

And that's a wrap.  Until next time...
