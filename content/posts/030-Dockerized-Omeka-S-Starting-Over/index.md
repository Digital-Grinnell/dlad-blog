---
title: "Dockerized Omeka-S: Starting Over"
publishDate: 2019-07-25
lastmod: 2019-09-03T15:14:12-05:00
tags:
  - Omeka-S
  - Docker
  - docker-compose
---

| Attention! |
| --- |
| The Docksal portion of this discussion DID NOT WORK PROPERLY so I've hidden it from public view.  **Don't use this project with Docksal (`fin` commands) until further notice!** |

I've created a new fork of [dodeeric/omeka-s-docker](https://github.com/dodeeric/omeka-s-docker) at [DigitalGrinnell/omeka-s-docker](https://github.com/DigitalGrinnell/omeka-s-docker), and it introduces a new `docker-compose.yml` file for spinning [Omeka-S](https://omeka.org/s/) up locally, but WITHOUT Docksal (due to problems with the integration originally documented [here](/posts/019-dockerized-omeka-s/)).

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

## Adding Solr
We don't need `gramps` in our configuration, but we do need `Solr`, so first step is to modify your `/etc/hosts` file entry to look like this:
```
### For omeka-s-docker
127.0.0.1    localhost omeka.localdomain pma.localdomain solr.localdomain
```
`Solr` can easily be added to the current stack with some simple changes/additions in the `docker-compose.yml` file.  I gleaned my changes largely from the `Using Docker Compose` example at https://docs.docker.com/samples/library/solr/.

## A New Branch
Next, we should create a new branch of our repo to work in, and since `Docksal` won't be a part of the new work I'm going to take a bold step and remove it from the branch, like so:
```
cd ~/Projects/omeka-s-docker
git checkout master                 # This is just a precaution
git checkout -b master-with-solr
rm -fr .docksal
atom .
```

The new `docker-compose.yml` section for `Solr` looks like this:

```
  ## Adding solr per `Using Docker Compose` example at https://docs.docker.com/samples/library/solr/
  solr:
    image: solr
    restart: always
    networks:
      - network1
    # ports:           # MAM: `ports` is not required since we have traefik.port mapped to Solr's 8983 below.
    #   - "8983:8983"
    volumes:
      - solr-data:/opt/solr/server/solr/mycores
    entrypoint:
      - docker-entrypoint.sh
      - solr-precreate
      - mycore
    labels:
      - "traefik.backend=solr"
      - "traefik.port=8983"
      - "traefik.frontend.rule=Host:solr.localdomain"
```

## Removing Gramps
I did a `docker-compose up -d` and see that this stack, complete with `Solr`, appears to be working nicely now.  So I'm taking steps to remove all references to `Gramps`, which is no longer needed here.  That leaves us with these comments and explanatory text gleaned from the top of the new `docker-compose.yml` file:

```
## This is a modified copy of dodeeric's original docker-compose-traefik.yml with
## localhost addresses of:
##
##   - omeka.localdomain
##   - pma.localdomain
##   - solr.localdomain
##
## Note that you can also see the Traefik dashboard at http://omeka.localdomain:8080
##
## These addresses need to be defined/enabled locally with an entry in /etc/hosts of:
##
##    ### For omeka-s-docker
##    127.0.0.1    localhost omeka.localdomain pma.localdomain solr.localdomain
##
```

## Customizing the Image and Rebuilding
Time to add the `centerrow-master` theme changes held in https://github.com/DigitalGrinnell/centerrow.  So, I created a new .zip file from the aforementioned repo, and saved that to my local project as `centerrow-master.zip`, then I modified the project's `Dockerfile` to pull this .zip in place of the `centerrow-v1.4.0.zip` copy. To take advantage of that change I needed to build a new Docker image and employ it going forward.  After making changes to the `Dockerfile` and `docker-compose.yml` files, the command history was:

```bash
cd ~/Projects/omeka-s-docker
git checkout master-with-solr
sudo docker image build -t mcfatem/omeka-s:aug18 .
sudo docker image tag mcfatem/omeka-s:aug18 mcfatem/omeka-s:latest
sudo docker login --username=mcfatem
sudo docker image push mcfatem/omeka-s:aug18
sudo docker image push mcfatem/omeka-s:latest
```

The `docker-compose.yml` change was from this:
```
omeka:
  ...
  image: dodeeric/omeka-s:latest
```
...to this:
```
omeka:
  ...
  image: mcfatem/omeka-s:latest
```

After these changes/additions my `docker-compose up -d` appears to work properly making all of the following local sites available:

  - http://omeka.localdomain/         <-- Omeka-S installer
  - http://omeka.localdomain:8080     <-- Traefik dashboard
  - http://pma.localdomain/           <-- PHPMyAdmin
  - http://solr.localdomain           <-- Solr admin

## Adding WMI Data
A `wmi.sql` file dumped from Grinnell's Omeka-Classic `World Music Instruments` collection is now available in the project root.  The file was dumped by opening an SSH session on Grinnell's __omeka1__ server (`ssh vagrant@omeka1.grinnell.edu`) and running the following commands there:

```
cd /var/www/html/WorldMusicInstruments
mysqldump -h localhost -u wMIAdmin -p wmi > wmi.sql
rsync -aruvi wmi.sql markmcfate@132.161.249.239:/Users/markmcfate/Projects/omeka-s-docker/wmi.sql --progress
```

Unfortunately, this dump was HUGE, like 1.2 gigabytes!  So, I elected to try again but without the voluminous "_sessions_" table data, like so:

```
cd /var/www/html/WorldMusicInstruments
mysqldump -u wMIAdmin -p -h localhost wmi --ignore-table=database.sessions > ./wmi-dump.sql \
  && mysqldump -u wMIAdmin -p -h localhost -d wmi sessions >> ./wmi-dump.sql
rsync -aruvi wmi-dump.sql markmcfate@132.161.249.239:/Users/markmcfate/Projects/omeka-s-docker/wmi-dump.sql --progress
```

That did the trick.  Now the _wmi-dump.sql_ file is only 7.8 megabytes in size.

There are a few ways to get our Omeka-S instance populated with data like this, perhaps the most popular is to mount the .sql file into the database container's `/docker-entrypoint-initdb.d/` directory. I could not get this to work, probably because we've already mounted a Docker volume named `mariadb` in that container.  No matter, I found a slick one-liner [in this gist](https://gist.github.com/zburgermeiszter/89a41467c80327c0bb550a2c7077d747) that does the trick.  My version of the command was:

```
╭─mark@Marks-Mac-Mini ~/Projects/omeka-s-docker ‹master-with-solr*›
╰─$ docker exec -i omeka-s-docker_mariadb_1 /bin/bash -c "export TERM=xterm && mysql -uomeka -pomeka omeka" < wmi.sql  
```

## Image Updates
Since wrapping up the previous posting I've made some additional changes to this branch.  Specifically, my Omeka-S image has been upgraded to version 2.0.1, and I corrected the path that the `centerrow-master` theme gets unpacked into (it was `centerrow-master` but needs to be just `centerrow`).  I also added some necessary packages to the `omeka` service Dockerfile in order to support `Solr`.

Having made these changes I repeated the Docker image build process from above like so:

```
cd ~/Projects/omeka-s-docker
git checkout master-with-solr
sudo docker image build -t mcfatem/omeka-s:august .
sudo docker image tag mcfatem/omeka-s:august mcfatem/omeka-s:latest
sudo docker login --username=mcfatem
sudo docker image push mcfatem/omeka-s:august
sudo docker image push mcfatem/omeka-s:latest
```
The `omeka` service portion of `docker-compose.yml` is still pulling and using `mcfatem/omeka-s:latest` from Docker Hub.

## Retrieving WMI Content or "Files"
The following is a reminder to myself... to retrieve the `/var/www/html/files` data from the `World Musical Instruments` (WMI) collection, try this on your host:

```
╭─markmcfate@ma8660 ~/Projects/omeka-s-docker ‹ruby-2.3.0› ‹master-with-solr*›
╰─$ rsync -aruvi vagrant@omeka1.grinnell.edu:/var/www/html/MusicalInstruments/files/. files/ --verbose
╭─markmcfate@ma8660 ~/Projects/omeka-s-docker ‹ruby-2.3.0› ‹master-with-solr*›
╰─$ docker cp ./files/. omeka-s-docker_omeka_1:/var/www/html/files/
```

And that's a wrap...for now.
