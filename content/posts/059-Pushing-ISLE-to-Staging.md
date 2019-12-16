---
title: Pushing ISLE to Staging
publishDate: 2019-12-13
lastmod: 2019-12-13T14:23:34-05:00
draft: false
tags:
  - ISLE
  - isle-stage.grinnell.edu
  - DGDockerX
  - staging
  - development
  - git config core.fileMode
---

This post chronicles the steps I took to push my local `dg.localdomain` project, an ISLE v1.3.0 build, to staging on node `DGDockerX` as `https://isle-stage.grinnell.edu` using my [dg-isle](https://github.com/Digital-Grinnell/dg-isle) and [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora) repositories.

## Directories
I'll begin by opening a terminal on the staging host, `DGDockerX` as user `islandora`.  Then I very carefully (note the use of the `--recursive` flags!) clone the aforementioned projects to `DGDockerX` like so:

| Host / DGDockerX Commands |
| --- |
| cd /opt <br/> git clone --recursive https://github.com/Digital-Grinnell/dg-isle.git <br/> git clone --recursive https://github.com/Digital-Grinnell/dg-islandora.git <br/> cd dg-isle <br/> git checkout staging |

## One Useful Git Config Change
One thing I learned during this process is that all of the `dg-isle` config files that I’ve modified and/or mapped into the containers show up as “modified” when I do a `git status` on the host.  The only apparent “modification” is that these are all owned on the host by `mcfatem:mcfatem`, but prior to spin-up these were owned by `islandora:islandora`.  The files/directories are:

  - `config/apache/settings_php/settings.staging.php`,
  - `config/fedora/gsearch/foxmlToSolr.xslt`,
  - `config/fedora/gsearch/islandora_transforms/`, and
  - `config/solr/schema.xml`

This is apparently a known condition that does no harm, but it can be easily ignored by specifying:

| Host / DGDockerX Commands |
| --- |
| cd /opt/dg-isle <br/> git config core.fileMode false |

Thank you, [Noah Smith](https://app.slack.com/team/U2ZC9KMCK) for sharing that bit of wisdom!

## Starting the Stack
Having cloned the projects to the host as indicated above, we visit our host terminal and...

| Host / DGDockerX Commands |
| --- |
| cd /opt/dg-isle <br/> docker-compose up -d <br/> docker logs isle-apache-dg |

The startup will take a couple of minutes, and it does not "signal" when it's done, so that's the reason for the last command above.  You may need to repeat it several times, but you will know the startup is complete when you see the following at the bottom of the log output:

```
...
Done setting proper permissions on files and directories
XDEBUG OFF
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.0.7. Set the 'ServerName' directive globally to suppress this message
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 192.168.0.7. Set the 'ServerName' directive globally to suppress this message
[Mon Dec 16 18:28:44.428224 2019] [mpm_prefork:notice] [pid 67455] AH00163: Apache/2.4.41 (Ubuntu) configured -- resuming normal operations
[Mon Dec 16 18:28:44.428317 2019] [core:notice] [pid 67455] AH00094: Command line: '/usr/sbin/apache2 -D FOREGROUND'
```

## Some Settings Are Missing
I found some settings were missing the first time I started the stack like this.  A little research and debugging led me to believe that the not all of the required configuration commands had been executed.  In particular, I found that my large image (TIFF image) viewer wasn't displaying anything at all.   The remedy was to run the required `migration_site_vsets.sh` script, like so from the _Apache_ container...

| Apache Container Commands |
| --- |
| cd / <br/> ./utility-scripts/isle_drupal_build_tools/migration_site_vsets.sh |


Not quite a wrap.  Be back soon...
