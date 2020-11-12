---
title: "Compact Build of dg.localdomain - Concise Instructions"
publishDate: 2020-10-20
lastmod: 2020-10-21T20:18:39-05:00
draft: false
tags:
  - ISLE
  - local
  - development
  - dg.localdomain
  - concise
  - compact
  - DG-FEDORA
---

This post is an addendum to an earlier post, [Local ISLE Installation: Migrate Existing Islandora Site - with Annotations](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again/), where I exhaustively documented my workflow for building a local/development instance of ISLE to mimic the behavoir of _Digital.Grinnell_.

## Goal
The goal of this project is to present a repeatable, minimal set of instructions for spinning up a safe, stand-alone, local/development instance of ISLE on any Mac running OS X.

## Prerequisites
This document assumes the user will be spinning up https://dg.localdomain on a Mac with a suitable `DG-FEDORA` USB stick mounted and accessible. See my [README.md](https://gist.github.com/Digital-Grinnell/f0900e9af9341e67433633be3fa0895d) public gist for complete instructions regarding creation, updates and handling of such a USB stick.  Additional prerequisites for running https://dg.localdomain can be found in ISLE documentation and in my [DG-FEDORA: A Portable FEDORA Repository](https://static.grinnell.edu/blogs/McFateM/posts/046-dg-fedora-a-portable-object-repository/) blog post.

## Credentials
Some of the scripts documented below may require login credentials including:

  - Your workstation (Mac) password, and
  - A username and password combination authorizing you to clone the [Digital-Grinnell/dg-isle](https://github.com/Digital-Grinnell/dg-isle) and [Digital-Grinnell/dg-islandora](https://github.com/Digital-Grinnell/dg-islandora) _private_ GitHub repositories.

    - These credentials can be found inside the `Digital Grinnell Bits` portion of the GC Libraries' _LastPass_ vault.  The information is listed there under the name `DG Private Repositories (dg-isle + dg-islandora)`.
    - Alternatively, you may obtain these credentials indirectly by emailing `digital@grinnell.edu`.

## Four RESTART Scripts
The process of spinning up a `https://dg.localdomain` stack has been boiled down to a sequence of roughly 20 necessary commands. While it would be possible to enter these commands sequentially into your workstation's terminal, there is a much easier path. The commands have been captured in a series of _bash_ scripts named `RESTART-1.sh`, `RESTART-2.sh`, `RESTART-3.sh`, and `RESTART-4.sh`.

| Script | Number of Commands | Purpose |
| --- | --- | --- |
| RESTART-1.sh | ~15 commands | This script does all the heavy lifting. It creates and populates the necessary directory structure, clones project repositories, pull Docker images, and launches 7 containers that define a minimal ISLE stack. |
| RESTART-2.sh | 1 command repeated up to 10 times over a ten-minute span | This script echoes the log file of the last command executed in `RESTART-1.sh`. |
| RESTART-3.sh | 4 commands | This script imports a previously exported Drupal database, updates some dynamic components, and begins the process of indexing DG-FEDORA's digital objects. |
| RESTART-4.sh | 2 commands | This script wraps things up by recreating DG-FEDORA's Solr index and flushing the Drupal caches. |

All four scripts can be found on your `DG-FEDORA` USB stick.

## Typical Use
With a `DG-FEDORA` USB stick properly mounted on your Mac, you simply need to open a terminal window and execute the following command sequence:

```
cd /Volumes/DG-FEDORA
./RESTART-1.sh
./RESTART-2.sh
./RESTART-3.sh
./RESTART-4.sh
```

**DO NOT simply copy and paste these commands into your terminal!** They need to be run one-at-a-time, in sequence, with execution of each command following successful completion of the previous command.

## Colors
Each script will set your terminal background to `black` and subsequently provide output using the following color scheme:

| Color | Meaning |
| --- | --- |
| Cyan | Normal output |
| Yellow | Progress or status messages |
| Green | Successful completion messages |
| Magenta | Prompts and alerts. Pay particular attention to these! |
| Red | Errors |

## Troubleshooting
_This section of the document will be populated as issues are encountered.  If you have a question or concern, or encounter any issues with this process please bring it to my attention by emailing `digital@grinnell.edu`.  Your experience and feedback will help shape this section for the benefit of others!  Thank you!_

<!--

### Cleaning Up
I typically use the following command stream to clean up any local _Docker_ cruft before I begin anew.  Note: Uncomment the third line ONLY if you want to delete images and download new ones.  If you do, be patient, it could take several minutes depending on connection speed.

```
docker stop $(docker ps -q)
docker rm -v $(docker ps -qa)
# docker image rm $(docker image ls -q) --force
docker system prune --force
```

### Mount the `DG-FEDORA` Portable Repository
Local `dg.localdomain` instances of _Digital.Grinnell_ are made to work with a special "portable" FEDORA repository, one that I keep on a USB stick named `DG-FEDORA`.  **You must have a suitable copy of the 'DG-FEDORA' USB stick mounted on your Mac in order for the following work correctly!**

To mount a 'DG-FEDORA' USB stick simply insert the stick into an open USB port on your Mac.  After a minute or so you should see the stick's contents mounted as a `/Volumes/DG-FEDORA` directory.

#### Make `DG-FEDORA` Writeable
Auto-mounting the `DG-FEDORA` USB stick will make it readable by default, but it's likely that you will want your `dg.localdomain` site to also write content to the USB stick.  To enable this, execute the following command as documented in [DG-FEDORA: A Portable FEDORA Repository](https://static.grinnell.edu/blogs/McFateM/search/?q=DG-FEDORA):

```
sudo mount -u -w /Volumes/DG-FEDORA
```

### Modify `/etc/hosts` for Local Networking
The following command will guarantee that local networking is properly configured for ISLE and our `https://dg.localdomain` address.  It does so by adding appropriate aliases for the localhost address, `127.0.0.1`, to the end of your `/etc/hosts` file.

```
echo \"127.0.0.1  localhost dg.localdomain admin.dg.localdomain portainer.dg.localdomain images.dg.localdomain\" | sudo tee -a /etc/hosts
```

### Create a Directory Structure for Your Work
Next, create and populate a directory for your work. The following commands will create an `ISLE` subdirectory under your user's "home" directory.  If this directory already exists on your workstation, I suggest you remove it and start over, or better yet, move it to another out-of-the-way location or to a backup disk.

```
cd ~
mkdir -p .out-of-the-way
[ ! -f ISLE ] || mv -fr ISLE .out-of-the-way
mkdir -p ISLE
cd ISLE
git clone --recursive https://github.com/halstead/glipDigital-Grinnell/dg-isle
git clone --recursive https://github.com/halstead/glipDigital-Grinnell/dg-islandora
cd dg-isle
cp sample.env .env
```

### Begin the Docker Build of `dg.localdomain`
Pull Docker images and being the build process. Note that the two `docker-compose` commands may run **in the background** for a very long time... 30 minutes or more! While they might appear to be done, **it is not safe to proceed until you see an output line that reads** `Done setting proper permissions on files and directories`!

```
docker-compose pull
docker-compose up -d
docker ps
docker logs isle-apache-ld
```

Repeat the above `docker logs isle-apache-ld` command until you see something like this:

```
Changing permissions of all directories inside /var/www/html to rwxr-x---...
Changing permissions of all files inside /var/www/html to rw-r-----...
Changing permissions of files directories in /var/www/html/sites to rwxrwx---...
Changing permissions of all files inside all files directories in /var/www/html/sites to rw-rw----...
Changing permissions of all directories inside all files directories in /var/www/html/sites to rwxrwx---...
find: ‘./*/files’: No such file or directory
find: ‘./*/files’: No such file or directory
Done setting proper permissions on files and directories
XDEBUG OFF
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.7. Set the 'ServerName' directive globally to suppress this message
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.7. Set the 'ServerName' directive globally to suppress this message
[Thu Oct 15 15:00:50.631578 2020] [mpm_prefork:notice] [pid 13246] AH00163: Apache/2.4.46 (Ubuntu) configured -- resuming normal operations
[Thu Oct 15 15:00:50.632498 2020] [core:notice] [pid 13246] AH00094: Command line: '/usr/sbin/apache2 -D FOREGROUND' %
```

### Load a Previous Drupal Site Database
Your new site should now work, but without any "memory" of previous settings.  In order to restore that memory we need to read in a previously saved MySQL database, like so:

```
# Copy a previously saved database into the running MySQL container.
docker cp /Volumes/DG-FEDORA/Extras/local_drupal_site_101620.sql  isle-mysql-ld:/site.sql
# Open a terminal to work inside the MySQL container.
docker exec -it isle-mysql-ld bash
# That `docker exec...` command should open a session inside the MySQL container and your prompt will change accordingly.
```

Now, inside the MySQL container terminal, import the database:

```
# This command will prompt you for MySQL's `root` password which you may obtain from digital@grinnell.edu
mysql -u root -o p digital_grinnell < site.sql
# Close the MySQL terminal after import
exit
```

### Execute the Following Commands Inside the Apache Container

Now we need to run a string of commands inside the Apache container.  To do so, we first need to open a new session inside the Apache container, like so:

```
docker exec -it isle-apache-ld bash
# That `docker exec...` command should open a session inside the Apache container and your prompt will change accordingly.
```

#### Update Composer and Clear All Caches

The next set of commands may take a few minutes to run. Inisde the running Apache container enter:

```
cd /var/www/html
find . -type f -name 'composer.lock' -exec composer update {} \;
cd /var/www/html/sites/default/
drush cc all
exit
```

### Update the FEDORA and Solr Indicies

The next pair of commands will need to run inside the FEDORA container.  To open a session for the command do this:

```
docker exec -it isle-fedora-ld bash
# That `docker exec...` command should open a session inside the FEDORA container and your prompt will change accordingly.
```

#### Update FEDORA

Now to update the FEDORA index on the `DG-FEDORA` USB stick we run this:

```
cd /utility_scripts/
./rebuildFedora.sh
```

Note that this process may take a few minutes. You will know it is complete when you see a final response like this:

```
SUCCESS: 129 objects rebuilt.
```

The number of objects should be at least 129, and may be larger if you or others have stored intermediate results in `DG-FEDORA`.

#### Update Solr

In the same FEDORA terminal window:

```
./updateSolrIndex.sh
```

### Flush All Caches Again

Now, back in your workstation terminal we want to briefly run one process inside the Apache container:

```
docker exec -w /var/www/html/sites/default/  isle-apache-ld drush cc all
```

## Command Summary

```
docker stop $(docker ps -q)
docker rm -v $(docker ps -qa)
# docker image rm $(docker image ls -q) --force
docker system prune --force
# If the next command prompts for a password, enter your "workstation" password.
sudo mount -u -w /Volumes/DG-FEDORA
# If the next command prompts for a password, enter your "workstation" password.
echo \"127.0.0.1  localhost dg.localdomain admin.dg.localdomain portainer.dg.localdomain images.dg.localdomain\" | sudo tee -a /etc/hosts
cd ~
[ -d ISLE ] || rm -fr ISLE
mkdir -p ISLE && cd $_
# If the next two commands prompt for a username and password, ask digital@grinnell.edu for necessary github/Digital-Grinnell credentials.
git clone --recursive https://github.com/Digital-Grinnell/dg-isle
git clone --recursive https://github.com/Digital-Grinnell/dg-islandora
cd dg-isle
cp sample.env .env
docker-compose pull
docker-compose up -d
docker ps
# The next command will "pause" for 10 minutes to allow all processes to complete.
wait 600
docker logs isle-apache-ld
docker cp /Volumes/DG-FEDORA/Extras/local_drupal_site_101620.sql  isle-mysql-ld:/site.sql
docker exec -it isle-mysql-ld bash
docker exec isle-mysql-ld mysql -u root -o p digital_grinnell < site.sql
docker exec -w /var/www/html find . -type f -name 'composer.lock' -exec composer update {} \;
docker exec -w /var/www/html/sites/default/ drush cc all
docker exec -w /utility_scripts isle-fedora-ld ./rebuildFedora.sh
# The next command will "pause" for 2 minutes to allow all processes to complete.
wait 120
docker exec -w /utility_scripts isle-fedora-ld ./updateSolrIndex.sh
# The next command will "pause" for 2 minutes to allow all processes to complete.
wait 120
docker exec -w /var/www/html/sites/default/  isle-apache-ld drush cc all
```
-->

And that's a wrap.  Until next time or until the feedback starts to roll in, whichever comes first...
