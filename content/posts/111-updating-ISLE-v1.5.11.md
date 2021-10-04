---
title: "Updating Digital.Grinnell to ISLE v1.5.11"
publishDate: 2021-09-27
lastmod: 2021-09-30T08:02:10-05:00
draft: false
tags:
  - ISLE
  - update
  - v1.5.11
---

{{% annotation %}}
Attention: This is an updated copy of [post 107](content/posts/107-updating-Digital-Grinnell-in-ISLE.md) gleaned from the [ISLE project's](https://github.com/Islandora-Collaboration-Group/ISLE) [update.md](https://github.com/Digital-Grinnell/dg-isle/blob/main/docs/update/update.md) document. **ONLY the headings from the original document and the annotations which are specific to _Digital.Grinnell_ appear in this document!**
{{% /annotation %}}

{{% annotation %}}
Note: This update procedure was NOT performed "locally", as recommended, due to substantial errors encountered in my last attempt to update. Rather than diving down that rabbit hole, again, I elected to attempt this update on our _staging_ server, _DGDockerX_ on `2021-Sep-27`.
{{% /annotation %}}

# Update ISLE to the Latest Release

## Important Information

```
# stop the docker service
$ sudo service docker stop

# download the latest docker binary and replace the current outdated docker
# DEPRECATED WAY TO UPGRADE DOCKER: $ sudo wget https://get.docker.com/builds/Linux/x86_64/docker-latest -O /usr/bin/docker
$ sudo yum update docker-engine

# start the docker service
$ sudo service docker start

# check the version
$ sudo docker version

# check the images and containers
$ sudo docker images
$ sudo docker ps
$ sudo docker ps -a
```

## Update Local (personal computer)

As mentioned above, this work is being conducted in _staging_ rather than _local_, on _DGDockerX_ in the `/home/islandora/ISLE` directory and the `dg-isle` and `dg-islandora` directories there.

My new branch is named `isle-update-v1.5.11`.

Output from `git pull` follows.

```
╭─islandora@dgdockerx ~/ISLE/dg-isle ‹isle-update-v1.5.11›
╰─$ git pull icg-upstream main
From https://github.com/Islandora-Collaboration-Group/ISLE
 * branch            main       -> FETCH_HEAD
Auto-merging docs/install/host-software-dependencies.md
Auto-merging docker-compose.staging.yml
Auto-merging docker-compose.production.yml
Auto-merging docker-compose.local.yml
Merge made by the 'recursive' strategy.
 docker-compose.demo.yml                    | 14 +++++++-------
 docker-compose.local.yml                   | 16 ++++++++--------
 docker-compose.production.yml              | 16 ++++++++--------
 docker-compose.staging.yml                 | 14 +++++++-------
 docker-compose.test.yml                    | 16 ++++++++--------
 docs/cookbook-recipes/migrate-dbs-utf8.md  |  6 +++---
 docs/install/host-software-dependencies.md | 22 +++++++++++++++++++++-
 docs/install/install-same-server.md        | 45 +++++++++++++++++++++++++++++++++++++++++++++
 docs/release-notes/release-1-5-10.md       | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 docs/release-notes/release-1-5-11.md       | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 docs/release-notes/release-1-5-8.md        | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 docs/release-notes/release-1-5-9.md        | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mkdocs.yml                                 |  7 ++++++-
 13 files changed, 377 insertions(+), 43 deletions(-)
 create mode 100644 docs/install/install-same-server.md
 create mode 100644 docs/release-notes/release-1-5-10.md
 create mode 100644 docs/release-notes/release-1-5-11.md
 create mode 100644 docs/release-notes/release-1-5-8.md
 create mode 100644 docs/release-notes/release-1-5-9.md
 ```

There were NO merge conflicts so `ratom` (see [Remote Atom](http://static.grinnell.edu/blogs/McFateM/posts/085-remote-atom/)) was not needed.

There really should be an additional step here since you **must edit**, or at least check your `.env` file!  I changed mine to read as follows:

```
COMPOSE_PROJECT_NAME=dgs
BASE_DOMAIN=isle-stage.grinnell.edu
CONTAINER_SHORT_ID=dgs
COMPOSE_FILE=docker-compose.staging.yml
```

With an active VPN connection, I am happy to report that the _staging_ site is now working at [https://isle-stage.grinnell.edu](https://isle-stage.grinnell.edu).  

Preliminary tests look good, and a search for "Ley" returns a very short list of objects that _do_ exist in my _DG-STAGING_ test repository.  

I wasn't able to execute the sequence as presented above.  Instead, I did this:

```
╭─islandora@dgdockerx ~/ISLE/dg-isle
╰─$ git add .
╭─islandora@dgdockerx ~/ISLE/dg-isle
╰─$ git commit -m "Updated and working on DGDockerX"
╭─islandora@dgdockerx ~/ISLE/dg-isle
╰─$ git push origin isle-update-v1.5.11
```

Hold on, there's one more significant part of the update process that's not covered here, updating the _Drupal_ and _Islandora_ code that is not technically part of _ISLE_, but probably should be?

My process for updating that went something like this:

```
╭─islandora@dgdockerx ~
╰─$ cd ~/ISLE/dg-islandora
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹main›
╰─$ git pull
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹main›
╰─$ git checkout -b update-sept-27
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-sept-27*›
╰─$ docker exec -it isle-apache-dgs bash
root@e97835142685:/# cd /var/www/html/sites/default/
root@e97835142685:/var/www/html/sites/default# rm -fr files/webform/*
root@e97835142685:/var/www/html/sites/default# drush up
```

The `drush up` command was invoked to pull in all of the latest updates to _Drupal_ v7, and there were many, including an update to _Drupal_'s core, now at _v7.82_.  Since the core got updated, I had to eventually revert changes to `/var/www/html/.htaccess` since those updates typically remove a line that _ISLE_ requires to function properly. I confirmed that the changes made by `drush up` did indeed make their way into `~/ISLE/dg-islandora` by checking `git status`. I managed to revert the changes to `.htaccess` using `sudo git checkout -- .htaccess`.

After making those changes I found it necessary to restart the stack using:

```
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-sept-27*›
╰─$ cd ~/DG-STAGING
╭─islandora@dgdockerx ~/DG-STAGING ‹main*›
╰─$ ./RESTART.sh
```

This time I did NOT have to run several of the `./Update-*.sh` scripts in `~/DG-STAGING` in order to get everything working properly.  So, I pushed my `dg-islandora` changes to _Github_ using:

```
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-sept-27*›
╰─$ git add --all .
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-sept-27*›
╰─$ git commit -m "Updates from DGDockerX"
[update-sept-27 e27a34c] Updates from DGDockerX
 183 files changed, 954 insertions(+), 666 deletions(-)
 mode change 100644 => 100755 scripts/drupal.sh
 mode change 100644 => 100755 scripts/password-hash.sh
 mode change 100644 => 100755 scripts/run-tests.sh
 rewrite sites/all/modules/contrib/views/README.txt (70%)
 ╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-sept-27›
 ╰─$ git pull origin main
 Username for 'https://github.com': Digital-Grinnell
 Password for 'https://Digital-Grinnell@github.com': xxxxxxxxxxxxxxx
 From https://github.com/Digital-Grinnell/dg-islandora
  * branch            main       -> FETCH_HEAD
 Already up-to-date.
 ```

At this point I did another `cd ~/DG-STAGING; ./RESTART.sh` just to ensure things still work properly.  Another `./Update-PERMISSIONS.sh` was also needed.

Then...
```
╭─islandora@dgdockerx ~/DG-STAGING ‹main›
╰─$ cd ~/ISLE/dg-islandora
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-sept-27›
╰─$ git push origin update-sept-27
Username for 'https://github.com': Digital-Grinnell
Password for 'https://Digital-Grinnell@github.com': xxxxxxxxxxxxxxx
Counting objects: 558, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (288/288), done.
Writing objects: 100% (292/292), 35.30 KiB | 0 bytes/s, done.
Total 292 (delta 253), reused 0 (delta 0)
remote: Resolving deltas: 100% (253/253), completed with 227 local objects.
remote:
remote: Create a pull request for 'update-sept-27' on GitHub by visiting:
remote:      https://github.com/Digital-Grinnell/dg-islandora/pull/new/update-sept-27
remote:
To https://github.com/Digital-Grinnell/dg-islandora
 * [new branch]      update-sept-27 -> update-sept-27
 ```

## Update Staging Server

Ok, at this point I've already got our staging server up-to-date, including the addition of my `purge-tmp-files` script successfully added to the Apache container's `/etc/cron.hourly` directory, but the ownership on that script is `islandora:islandora` and it needs to be `root:root`.  So, I need to change that from inside the `isle-apache-dgs` container like so: `root@bc83fc8bb3c3:/etc/cron.hourly# chown root:root purge-tmp-files`.

My next steps will be to backup the production database and `/var/www/html/sites/default/files`, merge all of the `dg-isle` and `dg-islandora` repository changes into their respective `main` branches, and repeat all of my implementation and testing in staging again.  For **production backup** look at `~/ISLE/DEPLOY/dump-production.sh` on `DGDocker1` for guidance!

I used the `~/ISLE/DG-STAGING/rsync-from-STORAGE.sh` and `~/ISLE/DG-STAGING/RESTART.sh` scripts on _DGDockerX_ to restart the stack after capturing the production database and `/var/www/html/sites/default/files` contents.  It worked nicely except for a warning about permissions on `public://backup_migrate/manual`.  I reran the `~/ISLE/DG-STAGING/Update-PERMISSIONS.sh` script and the warning went away.

I subsequently performed a `git add .; git commit -m "message"; git push origin update-sept-27` command sequence from both the `~/ISLE/dg-islandora` and a similar sequence, but with branch `isle-update-v1.5.11` in `~/ISLE/dg-isle` repositories to commit all changes.  I subsequently opened pull requests to merge both back to the corresponding `main` branches of their respective repositories.

Next update will be to our production server, _DGDocker1_, where I hope to repeat this process **to-the-letter**.

# Working Here !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Add a note about making sure we hold on to, and use, the old `acme.json` file that's in `~/ISLE/dg-isle/config/proxy/`!

## Update Production Server

 When you are confident that your Staging installation is working as expected:

 * Repeat the same above "Update Staging Server" process but do so on your Production server environment.

## Additional Resources

Please post questions to the public [Islandora ISLE Google group](https://groups.google.com/forum/#!forum/islandora-isle), or subscribe to receive emails.

{{% annotation %}}
One hiccup in the `production` update...  I encountered this error when trying to initiate an IMI import:
```
RuntimeException: Unable to create the cache directory (/var/www/private/ed). in Twig\Cache\FilesystemCache->write() (line 57 of /var/www/html/sites/all/modules/islandora/islandora_multi_importer/vendor/twig/twig/src/Cache/FilesystemCache.php).
```
The problem appeared to be ownership of the `/var/www/public` directory in the _Apache_ container.  The `public` folder was owned by `islandora:islandora` so I opened a shell into _Apache_ and did `cd /var/www/; chown -R islandora:www-data public`.  That seems to have fixed the problem nicely.
{{% /annotation %}}

# End of: Update ISLE to the Latest Release

And that's a wrap. Until next time...
