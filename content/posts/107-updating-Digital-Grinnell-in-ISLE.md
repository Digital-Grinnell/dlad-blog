---
title: "Updating Digital.Grinnell in ISLE"
publishDate: 2021-06-22
lastmod: 2021-06-25T13:50:52-05:00
draft: false
tags:
  - ISLE
  - update
  - ratom
  - 52698
  - disable security
---

{{% annotation %}}
Attention: This is an annotated copy of the [ISLE project's](https://github.com/Islandora-Collaboration-Group/ISLE) [update.md](https://github.com/Digital-Grinnell/dg-isle/blob/main/docs/update/update.md) document. Annotations specific to _Digital.Grinnell_ appear in specially formatted blocks like this one

There was one universal change made here in the original text, specifically all references to _master_ branches have been changed to _main_ to correlate with updated names of the repositories involved in this process.
{{% /annotation %}}

{{% annotation %}}
Note: This update procedure was first performed "locally", as recommended on `2021-June-22` when I attempted it on my _Grinnell College_ MacBook Pro, _MA10713_, serial number _C02FK0XXQ05Q_. **The process failed miserably due to numerous errors, ultimately including...

```
WARNING: Module xdebug ini file doesn't exist under /etc/php/7.1/mods-available
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.22.0.7. Set the 'ServerName' directive globally to suppress this message
[Wed Jun 23 00:39:38.868649 2021] [core:emerg] [pid 72604] (95)Operation not supported: AH00023: Couldn't create the proxy mutex
[Wed Jun 23 00:39:38.870388 2021] [proxy:crit] [pid 72604] (95)Operation not supported: AH02478: failed to create proxy mutex
AH00016: Configuration Failed
Action '-D FOREGROUND' failed.
```

The `images-ld` container also crashed with lots of _Java_ trash, as _Java_ is apt to do:

```
[s6-init] making user provided files available at /var/run/s6/etc...exited 0.
[s6-init] ensuring user provided files have correct perms...exited 0.
[fix-attrs.d] applying ownership & permissions fixes...
[fix-attrs.d] 01-tomcat: applying...
[fix-attrs.d] 01-tomcat: exited 1.
[fix-attrs.d] 11-cantaloupe: applying...
[fix-attrs.d] 11-cantaloupe: exited 0.
[fix-attrs.d] done.
[cont-init.d] executing container initialization scripts...
[cont-init.d] 01-cantaloupe-config: executing...
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Backend set to env
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Starting confd
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Backend source(s) set to
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO /usr/local/cantaloupe/cantaloupe.properties has md5sum 1a486ec62cc9c046b9d61a4d3972cc91 should be 9f84eb40bf531b1714cc616f20e60341
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Target config /usr/local/cantaloupe/cantaloupe.properties out of sync
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Target config /usr/local/cantaloupe/cantaloupe.properties has been updated
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO /usr/local/tomcat/conf/logging.properties has mode -rwxr-xr-x should be -rw-r--r--
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO /usr/local/tomcat/conf/logging.properties has md5sum 8edf0889dd7a263984094de9bea3770b should be 943111bb86645471250c7b35ed695ab0
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Target config /usr/local/tomcat/conf/logging.properties out of sync
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Target config /usr/local/tomcat/conf/logging.properties has been updated
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO /usr/local/tomcat/conf/tomcat-users.xml has md5sum d04005f593cfc6db810a79766bbf7917 should be 64b2ab19d2455cfd3a36fa5d374baed3
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Target config /usr/local/tomcat/conf/tomcat-users.xml out of sync
2021-06-23T00:25:09Z b0db6274e175 /usr/local/bin/confd[2461]: INFO Target config /usr/local/tomcat/conf/tomcat-users.xml has been updated
[cont-init.d] 01-cantaloupe-config: exited 0.
[cont-init.d] done.
[services.d] starting services
Starting Tomcat Privileged.
[services.d] done.
#
# A fatal error has been detected by the Java Runtime Environment:
#
#  SIGILL (0x4) at pc=0x000000400ba12b21, pid=2588, tid=0x00000040ea42c700
#
# JRE version: OpenJDK Runtime Environment (8.0_292-b10) (build 1.8.0_292-b10)
# Java VM: OpenJDK 64-Bit Server VM (25.292-b10 mixed mode linux-amd64 compressed oops)
# Problematic frame:
# J 1791 C1 org.apache.catalina.startup.ContextConfig.processAnnotationsStream(Ljava/io/InputStream;Lorg/apache/tomcat/util/descriptor/web/WebXml;ZLjava/util/Map;)V (38 bytes) @ 0x000000400ba12b21 [0x000000400ba12ac0+0x61]
#
# Failed to write core dump. Core dumps have been disabled. To enable core dumping, try "ulimit -c unlimited" before starting Java again
#
# An error report file with more information is saved as:
# /run/s6/services/tomcat/hs_err_pid2588.log
Compiled method (c1)   25034 1791       3       org.apache.catalina.startup.ContextConfig::processAnnotationsStream (38 bytes)
 total in heap  [0x000000400ba128d0,0x000000400ba13a40] = 4464
 relocation     [0x000000400ba129f8,0x000000400ba12ab8] = 192
 main code      [0x000000400ba12ac0,0x000000400ba13440] = 2432
 stub code      [0x000000400ba13440,0x000000400ba13518] = 216
 oops           [0x000000400ba13518,0x000000400ba13520] = 8
 metadata       [0x000000400ba13520,0x000000400ba13558] = 56
 scopes data    [0x000000400ba13558,0x000000400ba13908] = 944
 scopes pcs     [0x000000400ba13908,0x000000400ba13a38] = 304
 dependencies   [0x000000400ba13a38,0x000000400ba13a40] = 8
#
# If you would like to submit a bug report, please visit:
#   https://github.com/AdoptOpenJDK/openjdk-support/issues
#
qemu: uncaught target signal 6 (Aborted) - core dumped
Aborted
[cont-finish.d] executing container finish scripts...
[cont-finish.d] done.
[s6-finish] waiting for services.
[s6-finish] sending all processes the TERM signal.
[s6-finish] sending all processes the KILL signal and exiting.
```

Rather than diving down this rabbit hole I elected to attempt this update on our _staging_ server, _DGDockerX_.
{{% /annotation %}}


# Update ISLE to the Latest Release

Update an existing ISLE installation to install the newest improvements and security updates. This process is intended to be backwards compatible with your existing ISLE site.

We strongly recommend that you begin the update process on your Local environment so that you may test and troubleshoot before proceeding to update your Staging and Production environments.

## Important Information

- These instructions assume you have already installed either the [Local ISLE Installation: New Site](../install/install-local-new.md) or the [Local ISLE Installation: Migrate Existing Islandora Site](../install/install-local-migrate.md) on your Local personal computer and are using that described git workflow.
- Please test these updates on your Local and Staging environments before updating your Production server.
- Always read the [Release Notes](../release-notes/release-1-4-1.md) for any version(s) newer than that which you are currently running.
- **Docker Desktop Update:** If Docker prompts that updates are available for your personal computer, please follow these steps:
    1. Go to your Local ISLE site: `docker-compose down`
    2. Install the new updated version(s) of Docker Desktop.
    3. Go to your Local ISLE site: `docker-compose up -d`

{{% annotation %}}
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
{{% /annotation %}}

## Update Local (personal computer)

{{% annotation %}}
As mentioned above, this work is being conducted in _staging_ rather than _local_, on _DGDockerX_ in the `/home/islandora/ISLE` directory and the `dg-isle` and `dg-islandora` directories there.
{{% /annotation %}}

* On your Local (personal computer) server, open a terminal (Windows: open Git Bash) and navigate to your Local ISLE repository (this contains the "docker-compose.local.yml" file):
    * **Example:** `cd /path/to/your/repository`

* Stop the existing ISLE containers:
    * `docker-compose down`

* Check your git remotes:
    * `git remote -v`
* If you do not have a remote named "icg-upstream" then create one:
    * `git remote add icg-upstream https://github.com/Islandora-Collaboration-Group/ISLE.git`

* Run a git fetch from the ICG upstream:
    * `git fetch icg-upstream`

* Checkout a new git branch as a precaution for performing the update on your project. This way your "main" branch stays safe and untouched until you have tested thoroughly and are ready to merge in changes from the recent update. You may select any name for your new local branch.
    * **Example:** `git checkout -b isle-update-numberhere`

{{% annotation %}}
My new branch is named `isle-update-1.5.7`.
{{% /annotation %}}


* Pull down the ICG ISLE "main" branch into your Local project's new "isle-update-numberhere" branch:
    * `git pull icg-upstream main`

{{% annotation %}}
I pulled `icg-upstream main` rather than _master_.
{{% /annotation %}}

* In your ISLE directory, you may view the newest release of ISLE code by entering:
    * `ls -lha`
* Now that you have pulled down the latest code, there are likely to be conflicts between your existing code and the newer code. Run this command to determine if there are git merge conflicts:
    * `git status`

{{% annotation %}}
Output from `git pull` follows.

```
╭─islandora@dgdockerx ~/ISLE/dg-isle ‹isle-update-1.5.7›
╰─$ git pull icg-upstream main
From https://github.com/Islandora-Collaboration-Group/ISLE
 * branch            main       -> FETCH_HEAD
Auto-merging staging.env
Auto-merging scripts/apache/migration_site_vsets.sh
CONFLICT (content): Merge conflict in scripts/apache/migration_site_vsets.sh
Auto-merging production.env
Auto-merging local.env
Removing docs/specifications/supported-software-matrix.md
Removing docs/specifications/supported-drupal-modules-matrix.md
Auto-merging docs/install/install-staging-migrate.md
Auto-merging docs/install/install-local-migrate.md
CONFLICT (content): Merge conflict in docs/install/install-local-migrate.md
Auto-merging docs/install/host-software-dependencies.md
Removing docs/install/_obsolete_install-server.md
Removing docs/contributor-docs/build-guide.md
Removing docs/contributor-docs/build-guide-v111.md
Removing docs/contributor-docs/ansible-guide.md
Removing docs/contributor-docs/ISLE-v.1.1.2-buildnotes.md
Removing docs/appendices/user-story-new-site.md
Removing docs/appendices/user-story-migration-site.md
Removing docs/appendices/user-story-demo-site.md
Auto-merging docker-compose.staging.yml
Auto-merging docker-compose.production.yml
Auto-merging docker-compose.local.yml
Auto-merging config/proxy/traefik.staging.toml
CONFLICT (content): Merge conflict in config/proxy/traefik.staging.toml
Auto-merging config/proxy/traefik.production.toml
CONFLICT (content): Merge conflict in config/proxy/traefik.production.toml
Auto-merging config/proxy/traefik.local.toml
Automatic merge failed; fix conflicts and then commit the result.
```
{{% /annotation %}}

* If there are any merge conflicts, then use a text editor (or IDE) to resolve them. (The [Atom](https://atom.io/) text editor offers green and red buttons to facilitate this process.) Some releases will have more merge conflicts than others. Carefully progress through this process of resolving merge conflicts. Changes will usually include but are not limited to:
    * new configuration files
    * new ISLE services optional or otherwise
    * new ISLE docker image tags
    * new comments
    * new documentation

{{% annotation %}}
I used `ratom` (see [Remote Atom](http://static.grinnell.edu/blogs/McFateM/posts/085-remote-atom/)) to resolve the 4 merge conflicts.
{{% /annotation %}}

* After all merge conflicts are resolved, then add and commit your edits to your Local environment:
    * **Example:** `git add <changedfileshere>`
    * **Example:** `git commit -m "ISLE update from version #X to version #Y"`

* Optional: If you want to backup this new branch to your origin, then run this command: (Ultimately after testing on your Local, you'll merge to `main` and then deploy the new code to your Staging and Production environments.)
    * **Example:** `git push origin isle-update-numberhere`

* Using the same open terminal, ensure you are in the root of your ISLE project directory:
    * **Example:** `cd /path/to/your/repository`
* Download the new ISLE docker images to the Local (personal computer):
    * `docker-compose pull`

{{% annotation %}}
There really should be an additional step here since you **must edit**, or at least check your `.env` file!  I changed mine to read as follows:
```
COMPOSE_PROJECT_NAME=dgs
BASE_DOMAIN=isle-stage.grinnell.edu
CONTAINER_SHORT_ID=dgs
COMPOSE_FILE=docker-compose.staging.yml
```
{{% /annotation %}}

* Run the new docker containers (and new code) on your Local environment:
    * `docker-compose up -d`

* In your web browser, enter the URL of your Local site:
    * **Example:** `https://yourprojectnamehere.localdomain`

{{% annotation %}}
With an active VPN connection, I am happy to report that the _staging_ site is now working at [https://isle-stage.grinnell.edu](https://isle-stage.grinnell.edu).  However, I'm getting tired or accepting the self-signed certs used in staging, so I found and executed [How to disable Firefox: “Warning: Potential Security Risk Ahead” forever](https://medium.com/volosoft/how-to-disable-firefox-warning-potential-security-risk-ahead-f081fbf81a4f).
{{% /annotation %}}

* Quality control (QC) the Local site and ensure the following:
    * The site appears and functions as it did prior to these updates.
    * You can ingest test objects without any issue.
    * You can modify existing object data without any issue.
    * All services are functional and without apparent ERROR warnings in the browser log console output.
        * **Example:** In Chrome, press the F12 button to open the [Console](https://developers.google.com/web/tools/chrome-devtools/console/), then select the "Console" tab.


{{% annotation %}}
Preliminary tests look good, although a search for "Ley" still returns a number of objects that _do not exist_ in my _DG-STAGING_ test repository.  I'm going to attempt to re-index FGS and Solr to see if I can fix that now.

Nope, the Fedora and Solr update scripts did not resolve this issue.  Next up, http://dgdockerx.grinnell.edu:8081/fedoragsearch/rest and login as `fgsAdmin`.  That opens the _Admin Client for Fedora Generic Search Service_ where I can hope to empty the index and rebuild.  Nope, the `createEmpty` option returns a message telling me to `createEmpty: Stop solr, remove the index dir, restart solr`.  So I opened a shell into the `isle-solr-dgs` container and did `root@d7e1538334f6:/usr/local/solr/collection1/data# rm -fr index`.  Then I tried the rebuild scripts again, but this also did NOT work.

Ultimately, after deleting the aforementioned directory, I had to bring the stack down and back up again (using `~/DG-STAGING/destroy.sh` and `~/DG-STAGING/RESTART.sh`), then rebuild _Fedora_ and update _Solr_.  Now I have an accurate, abbreviated _Solr_ return list!
{{% /annotation %}}

* When you have completed testing and have no further adjustments to make, switch from your "isle-update-numberhere" branch of code to your "main" branch:
    * `git checkout main`
* Merge your "isle-update-numberhere" branch of code to "main".
    * **Example:** `git merge isle-update-numberhere`

* Push this code to your online git provider ISLE
    * `git push -u origin main`
    * This will take 2-5 minutes depending on your internet speed.

{{% annotation %}}
I wasn't able to execute the sequence as presented above.  Instead, I did this:
```
╭─islandora@dgdockerx ~/ISLE/dg-isle
╰─$ git add .
╭─islandora@dgdockerx ~/ISLE/dg-isle
╰─$ git commit -m "Updated and working on DGDockerX"
╭─islandora@dgdockerx ~/ISLE/dg-isle
╰─$ git push origin isle-update-1.5.7
```
{{% /annotation %}}

* You now have the current ISLE project code checked into git; this will be the foundation for making changes to your Staging and Production servers.

{{% annotation %}}
During my updates to _DGDockerX_ I had network interruptions that left processes on the remote holding on to port 52698, the port that I need to make _ratom_ work.  I found this simple means of freeing up that port...

```
╭─islandora@dgdockerx ~
╰─$ sudo netstat -plant | grep 52698
tcp        0      0 127.0.0.1:52698         0.0.0.0:*               LISTEN      121885/sshd: island
tcp6       0      0 ::1:52698               :::*                    LISTEN      121885/sshd: island
tcp6       0      0 ::1:41724               ::1:52698               ESTABLISHED 24103/bash
tcp6       0      0 ::1:52698               ::1:41724               ESTABLISHED 121885/sshd: island
tcp6       0      0 ::1:52698               ::1:41382               ESTABLISHED 121885/sshd: island
tcp6       0      0 ::1:41400               ::1:52698               ESTABLISHED 122118/bash
tcp6       0      0 ::1:41610               ::1:52698               ESTABLISHED 23600/bash
tcp6       0      0 ::1:41382               ::1:52698               ESTABLISHED 122040/bash
tcp6       0      0 ::1:52698               ::1:41400               ESTABLISHED 121885/sshd: island
tcp6       0      0 ::1:52698               ::1:41610               ESTABLISHED 121885/sshd: island
╭─islandora@dgdockerx ~
╰─$ sudo kill -9 121885
```
{{% /annotation %}}

{{% annotation %}}
Hold on, there's one more significant part of the update process that's not covered here, updating the _Drupal_ and _Islandora_ code that is not technically part of _ISLE_, but probably should be?

My process for updating that went something like this:

```
╭─islandora@dgdockerx ~
╰─$ cd ~/ISLE/dg-islandora
╭─islandora@dgdockerx ~/ISLE/dg-islandora
╰─$ git checkout -b update-june-23
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-june-23*›
╰─$ docker exec -it isle-apache-dgs bash
root@03df8d9c975a:/# cd /var/www/html/sites/default/
root@03df8d9c975a:/var/www/html/sites/default# drush up
```

The `drush up` command was invoked to pull in all of the latest updates to _Drupal_ v7, and there were many, including an update to _Drupal_'s core.  Since the core got updated, I had to eventually revert changes to `/var/www/html/.htaccess` since those updates typically remove a line that _ISLE_ requires to function properly. I confirmed that the changes made by `drush up` did indeed make their way into `~/ISLE/dg-islandora` by checking `git status`. I managed to revert the changes to `.htaccess` using `git checkout -- .htaccess`.

After making those changes I found it necessary to restart the stack using:

```
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-june-23*›
╰─$ cd ~/DG-STAGING
╭─islandora@dgdockerx ~/DG-STAGING ‹main*›
╰─$ ./RESTART.sh
```

I subsequently had to run several of the `./Update-*.sh` scripts in `~/DG-STAGING` in order to get everything working properly. Once everything was working properly I pushed my `dg-islandora` changes to _Github_ using:

```
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-june-23*›
╰─$ git add --all .
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-june-23*›
╰─$ git commit -m "Updates from DGDockerX"
[update-june-23 f8e3cd8] Updates from DGDockerX
 232 files changed, 3498 insertions(+), 1283 deletions(-)
 rewrite modules/simpletest/files/css_test_files/comment_hacks.css.optimized.css (100%)
 create mode 100644 modules/simpletest/files/css_test_files/quotes.css
 create mode 100644 modules/simpletest/files/css_test_files/quotes.css.optimized.css
 create mode 100644 modules/simpletest/files/css_test_files/quotes.css.unoptimized.css
 mode change 100755 => 100644 sites/all/libraries/tuque/tests/README.md
 mode change 100755 => 100644 sites/all/libraries/tuque/tests/scripts/travis_setup.sh
 create mode 100644 sites/all/modules/contrib/link/link.admin.inc
 rewrite sites/all/modules/contrib/link/link.info (61%)
 rename sites/all/modules/contrib/link/tests/{link.test => LinkBaseTestClass.test} (85%)
 create mode 100644 sites/all/modules/contrib/link/tests/LinkConvertInternalPathsTest.test
 create mode 100644 sites/all/modules/contrib/link/tests/LinkDefaultProtocolTest.test
 rename sites/all/modules/contrib/link/tests/{link.entity_token.test => LinkEntityTokenTest.test} (98%)
 rename sites/all/modules/contrib/link/tests/{link.attribute.test => LinkFieldAttributesTest.test} (96%)
 rename sites/all/modules/contrib/link/tests/{link.crud_browser.test => LinkFieldCrudTest.test} (87%)
 rename sites/all/modules/contrib/link/tests/{link.validate.test => LinkFieldValidateTest.test} (60%)
 rename sites/all/modules/contrib/link/tests/{link.multilingual.test => LinkPathPrefixesTest.test} (98%)
 create mode 100644 sites/all/modules/contrib/link/tests/LinkSanitizeTest.test
 rename sites/all/modules/contrib/link/tests/{link.token.test => LinkTokenTest.test} (99%)
 create mode 100644 sites/all/modules/contrib/link/tests/LinkUnitTestCase.test
 create mode 100644 sites/all/modules/contrib/link/tests/LinkValidationApiTest.test
 delete mode 100644 sites/all/modules/contrib/link/tests/link.crud.test
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-june-23›
╰─$ git pull origin main                               
Username for 'https://github.com': digital@grinnell.edu
Password for 'https://digital@grinnell.edu@github.com':  xxxxxxxxxxxxxxxxxxxxxxxx
From https://github.com/Digital-Grinnell/dg-islandora
 * branch            main       -> FETCH_HEAD
Merge made by the 'recursive' strategy.
 .htaccess                                     |  13 +++++++--
 sites/all/modules/islandora/idu/idu.drush.inc | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 142 insertions(+), 4 deletions(-)
 ```

At this point I did another `cd ~/DG-STAGING; ./RESTART.sh` just to ensure things still work properly.  Another `./Update-PERMISSIONS.sh` was also needed.

Then...
```
╭─islandora@dgdockerx ~/ISLE/dg-islandora ‹update-june-23›
╰─$ git push origin update-june-23  
Username for 'https://github.com': digital@grinnell.edu
Password for 'https://digital@grinnell.edu@github.com': xxxxxxxxxxxxxxx
Counting objects: 660, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (348/348), done.
Writing objects: 100% (352/352), 102.29 KiB | 0 bytes/s, done.
Total 352 (delta 288), reused 1 (delta 0)
remote: Resolving deltas: 100% (288/288), completed with 261 local objects.
remote:
remote: Create a pull request for 'update-june-23' on GitHub by visiting:
remote:      https://github.com/Digital-Grinnell/dg-islandora/pull/new/update-june-23
remote:
To https://github.com/Digital-Grinnell/dg-islandora
 * [new branch]      update-june-23 -> update-june-23
 ```
{{% /annotation %}}


## Update Staging Server

{{% annotation %}}
Ok, at this point I've already got our staging server up-to-date, including the addtion of my `purge-tmp-files` script successfully added to the Apache container's `/etc/cron.hourly` directory.  So my next steps will be to backup the production database and `/var/www/html/sites/default/files`, merge all of the `dg-isle` and `dg-islandora` repository changes into their respective `main` branches, and repeat all of my implementation and testing in staging again.
{{% /annotation %}}

* SSH into your Staging ISLE Host Server:
    * **Example:** `ssh islandora@yourstagingserver.institution.edu`
    * **Example:** `cd /opt/yourprojecthere`

* Stop the existing ISLE containers:
    * `docker-compose down`

* Update the Docker files via git:
    * `git pull origin main`

<!-- TODO: Break this down into simpler steps -->
* You must now again fix the `.env` file as you did in the `On Remote Staging - Edit the ".env" File to Change to the Staging Environment` step of either the [Staging ISLE Installation: New Site](../install/install-staging-new.md) or the [Staging ISLE Installation: Migrate Existing Islandora Site](../install/install-staging-migrate.md) instructions. As described, this step is a multi-step, involved process that allows an end-user to make appropriate changes to the `.env` and then commit it locally to git. This local commit will never be pushed back to the git repository and this is critical because it allows future ISLE updates and/or configuration changes. In other words, you are restoring what you had in the `.env` to the Staging settings in case they are overwritten.

* Download the new ISLE docker images to the remote Staging environment:
    * `docker-compose pull`
    * This may take a few minutes depending on your network connection

* Run the new docker containers (and new code) on your Staging environment:
    * `docker-compose up -d`

The new containers should start up and your Staging Islandora site should be available, without any loss of existing content.

{{% annotation %}}
I used the `/home/islandora/DG-STAGING/RESTART.sh` script on _DGDockerX_ to restart the stack after capturing the production database and `/var/www/html/sites/default/files` contents.  It worked nicely! It did require one run of the `/home/islandora/DG-STAGING/Update-PERMISSIONS.sh` script to get everything set.

Next update will be to our production server, _DGDocker1_, where I hope to repeat this process **to-the-letter**.
{{% /annotation %}}

* QC the Staging site and ensure the following:
    * The site appears and functions as it did prior to these updates.
    * You can ingest test objects without any issue.
    * You can modify existing object data without any issue.
    * All services are functional and without apparent ERROR warnings in the browser log console output.

* We recommend that you observe the above Staging installation for a few days or a week.

## Update Production Server

 When you are confident that your Staging installation is working as expected:

 * Repeat the same above "Update Staging Server" process but do so on your Production server environment.

## Additional Resources

Please post questions to the public [Islandora ISLE Google group](https://groups.google.com/forum/#!forum/islandora-isle), or subscribe to receive emails.


# End of: Update ISLE to the Latest Release

And that's a wrap. Until next time...
