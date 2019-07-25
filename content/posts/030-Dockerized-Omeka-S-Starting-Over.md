---
title: "Dockerized Omeka-S: Starting Over"
date: 2019-07-25T09:36:17-05:00
---
I've created a new fork of [dodeeric/omeka-s-docker](https://github.com/dodeeric/omeka-s-docker) at [DigitalGrinnell/omeka-s-docker](https://github.com/DigitalGrinnell/omeka-s-docker), and it introduces a new `docker-compose.yml` file for spinning [Omeka-S](https://omeka.org/s/) up locally, but WITHOUT Docksal (due to problems with the integration originally documented [here](https://static.grinnell.edu/blogs/McFateM/posts/019-dockerized-omeka-s/)).

System requirements for local development of this project currently include:

- [Docker (Community Edition)](https://docs.docker.com/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Local Development and Testing

If your workstation is able to run the aforementioned required components then the following steps can be used to launch and develop a local instance.  Assuming your workstation is Linux or a Mac, you'll need to edit your `/etc/hosts` with an editor of your choice, and `sudo` privileges might be required.  For me this was...

```
sudo nano /etc/hosts
```

In the `/etc/hosts` file comment out any line beginning with `127.0.0.1` and add the following two lines just above it...
```
### For omeka-s-docker
127.0.0.1    localhost omeka.localdomain pma.localdomain gramps.localdomain
```
The new `127.0.0.1...` line will enable you to use `http://omeka.localdomain` to open and work with your new Omeka-S instance in any browser on your workstation.

Now to launch Omeka-S, return to your workstation terminal and...

```
cd ~/Projects    # or any path of your choice
git clone https://github.com/DigitalGrinnell/omeka-s-docker.git
cd omeka-s-docker
docker-compose up -d
```

The `docker-compose up -d` command in this sequence should launch the project locally.  Once it is complete you should be able to open any browser and visit `http://omeka.localdomain` to work with Omeka-S, or `http://pma.localdomain` if you want PHPMyAdmin.

## Adding a Custom Docksal Config
Following the guidance provided in https://docs.docksal.io/stack/extend-images/#docker-file...

```
╭─mark@Marks-Air.grinnell.edu ~/Projects
╰─➤  cd omeka-s-docker
╭─mark@Marks-Air.grinnell.edu ~/Projects/omeka-s-docker  ‹master›
╰─➤  ls -alh
total 53784
drwxr-xr-x  14 mark  staff   448B Jul 24 13:13 .
drwxr-xr-x@ 11 mark  staff   352B Jul 24 12:37 ..
drwxr-xr-x  12 mark  staff   384B Jul 25 09:00 .git
-rw-r--r--   1 mark  staff   1.1K Jul 24 12:37 .htaccess
-rw-r--r--   1 mark  staff   2.5K Jul 24 12:37 Dockerfile
-rw-r--r--   1 mark  staff   3.2K Jul 24 12:37 README.md
-rw-r--r--   1 mark  staff   725K Jul 24 12:37 centerrow-v1.4.0.zip
-rw-r--r--   1 mark  staff   827K Jul 24 12:37 cozy-v1.3.1.zip
-rw-r--r--   1 mark  staff   112B Jul 24 12:37 database.ini
-rw-r--r--   1 mark  staff   1.8K Jul 24 13:11 docker-compose.yml
-rw-r--r--   1 mark  staff   2.4K Jul 24 12:37 imagemagick-policy.xml
-rw-r--r--   1 mark  staff    13M Jul 24 12:37 omeka-s-1.4.0.zip
-rw-r--r--   1 mark  staff    11M Jul 24 12:37 omeka-s-modules-v4.tar.gz
-rw-r--r--   1 mark  staff   698K Jul 24 12:37 thedaily-v1.4.0.zip
╭─mark@Marks-Air.grinnell.edu ~/Projects/omeka-s-docker  ‹master›
╰─➤  git remote -v
origin	https://github.com/DigitalGrinnell/omeka-s-docker.git (fetch)
origin	https://github.com/DigitalGrinnell/omeka-s-docker.git (push)
╭─mark@Marks-Air.grinnell.edu ~/Projects/omeka-s-docker  ‹master›
╰─➤  git checkout -b docksal
Switched to a new branch 'docksal'
╭─mark@Marks-Air.grinnell.edu ~/Projects/omeka-s-docker  ‹docksal›
╰─➤  fin config generate  
DOCROOT has been detected as docroot. Is that correct? [y/n]: y
Configuration was generated. You can start it with fin project start
```

Per the [documentation](https://docs.docksal.io/stack/extend-images/#docker-file) I made a duplicate of the project's original `./Dockerfile` and put the new copy in `./.docksal/services/cli/Dockerfile`.  Then I replaced the initial `FROM...` statement in the new file with a copy pulled from the documentation, so we have this...

```
## Replacing one 'FROM...' line below with three lines that follow it from https://docs.docksal.io/stack/extend-images/#docker-file.  MAM 25-July-2019
#FROM php:apache  
# Note how we use cli:2 here, which refers the latest available 2.x version
# So that we wouldn't need to update this every time new version of Docksal cli releases
FROM docksal/cli:2-php7.2
```
In `./.docksal/docksal.env` I also changed the DOCROOT to `/var/www/html`.

Trying `fin up`...


And that's a wrap.  Until next time...
