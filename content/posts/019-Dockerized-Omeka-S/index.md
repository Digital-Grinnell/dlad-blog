---
title: A Dockerized Omeka-S for Development and Staging
date: 2019-06-10
---
| Update: 24-July-2019 |
| --- |
| The Docksal process outlined here is NOT working reliably.  See [this new post](/posts/030-dockerized-omeka-s-starting-over/) for updated info. |

My fork of the [dodeeric/omeka-s-docker](https://github.com/dodeeric/omeka-s-docker) project can be found at [McFateM/omeka-s-docker](https://github.com/McFateM/omeka-s-docker), and it introduces a new `docker-compose.yml` file for spinning [Omeka-S](https://omeka.org/s/) up on any Dockerized server, and a Docksal `.docksal` directory to enable local development using `fin up`.

| Note |
| --- |
| What follows is reflected in the `README.md` file at https://github.com/McFateM/omeka-s-docker. |

System requirements for local development of this project currently include:

- [Docker (Community Edition)](https://docs.docker.com/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docksal](https://docksal.io)

The workflows mentioned here were created on a Mac workstation and successfully pushed to a staging environment running Ubuntu 16.04.

## Local Development and Testing

If your workstation is able to run the aforementioned required components then the following steps can be used to launch and develop a local instance.  In a terminal on your workstation with Docker running...

```
cd ~/Projects    # or any path of your choice
git clone https://github.com/McFateM/omeka-s-docker.git
cd omeka-s-docker
fin up
```

The `fin up` command in this sequence should launch the project locally.  It should report...
```
Project URL: http://omeka-s-docker.docksal:8080
```
However, that statement is not entirely accurate in the case of Omeka-S.  The correct address will NOT require the `:8080` suffix.  So, the target address should be:
```
http://omeka-s-docker.docksal
```

You should be able to start (`fin up`) and stop (`fin down`) this local project as often as needed.  Any data you add to Omeka in this mode should persist as long as you don't remove the Omeka container or reset Docker entirely.

## Deploy to Staging

The requirements for an Omeka-S staging environment are essentially the same as the local workstation, except that Docksal is NOT required.

In addition, the staging server needs to also have been configured using `./init` and the workflow outlined in my [docker-bootstrap Workflow](/posts/008-docker-bootstrap-workflow/). The aforementioned `./init` script was successfully run against `dgdocker2.grinnell.edu` on June 7, 2019.

If all of those requirements have been met the site can be deployed to staging (currently this involves the `dgdocker2.grinnell.edu` server). In a terminal open to DGDocker2 with Docker running...

```
cd ~/Projects    # or any path of your choice
git clone https://github.com/McFateM/omeka-s-docker.git
cd omeka-s-docker
docker-compose up -d
```

You should be able to start (`docker-compose up -d`) and stop (`docker-compose stop`) this project as often as needed.  Any data you add to Omeka in this mode should persist as long as you don't remove the Omeka container or reset Docker entirely.  

Omeka-S was successfully launched as [https://omeka-s.grinnell.edu](https://omeka-s.grinnell.edu) on June 10, 2019.  Other associated apps also running on `DGDocker2` are tabulated below.

| Description | URL | Notes |
| --- | --- | --- |
| Portainer | https://dgdocker2.grinnell.edu  | Deployed as part of `docker-boostrap` and the `./init` script. This instance is password protected.
| Simple `WhoAmI` test application  | https://dgdocker2.grinnell.edu/whoami  |For testing proxy settings and connectivity.
| PHPMyAdmin  | https://dgdocker2.grinnell.edu/pma/  | Note that the trailing slash is REQUIRED!  

And that's a wrap.  Until next time...
