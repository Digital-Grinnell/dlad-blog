---
title: Migration to Lando
publishdate: 2020-02-17
lastmod: 2020-02-20T22:25:11-06:00
draft: false
tags:
  - Docksal
  - Lando
  - Drupal 8
  - Wieting
  - mogtofu33
  - docker-compose-drupal
---

I have ITS tickets, for seemingly simple DNS changes, that are now more than a month old, and because of that I've taken steps to try and do some _ISLE_ staging work on one of my _DigitalOcean_ droplets, namely _summitt-services-droplet-01_. In order to accommodate that I've moved nearly all of the sites and services from that droplet to my other, _summitt-dweller-DO-docker_.  The site migration was a smooth process except for [https://Wieting.TamaToledo.com](https://wieting.tamatoledo.com). That _Drupal 8_ site has been difficult to upgrade and migrate largely because it was deployed using my old _Port-Ability_ scripts, and about a year ago I scrapped _Port-Ability_ in favor of [Docksal](https://docksal.io), but I never got around to moving that particular site to a _Docksal_ environment.  Well, now I'm finding it almost impossible to complete that migration to _Docksal_.

# The Problem with Docksal

_Docksal_ is a wonderful development environment, but I can't find an effective, and easily repeatable, path from development to production when using it. _Docksal_ provides system services including an `SSH Agent`, `DNS`, and `Reverse Proxy` as documented [here](https://docs.docksal.io/core/overview/).  _Docksal_ services are provided by a `cli` container/service which is also responsible for providing a robust set of `fin` commands.  In addition to `cli`, a typical _Docksal_ stack also provides containers for `web` and `db`, and those look a lot like what I like to deploy for _Drupal_ in production.  However, the `cli` container looks nothing like what I deploy in production, and therein lies the rub.

# The Promise of Lando

Hindsight is 20/20, so this must be the year to look back and make course corrections, right?  Had I not fallen so quickly for the speed and glitz of _Docksal_ I would have given some of its alternatives, like [Lando](https://lando.dev), a closer look.  The immediate promise of _Lando_ is that it builds, in development, a stack that looks much more like what I wish to deploy in production, and it does so by not integrating as tightly as _Docksal_ does.

# Migrating the Wieting Theatre Web Site to Lando

Another thing that I like about _Lando_ is the fact that [Jeff Geerling](https://www.jeffgeerling.com) has taken it for a spin and documented some of his experience with it in his blog. So I have elected to begin my adventures in _Lando_ with [this post](https://www.jeffgeerling.com/blog/2018/getting-started-lando-testing-fresh-drupal-8-umami-site).

After following Jeff's lead I discovered that it left me a little short of my goal... to spin up an **existing** _Drupal 8_ site using _Lando_.  So, I backed off a bit and returned to studying the contents of [https://github.com/lando/lando](https://github.com/lando/lando).  Along the way I found a post by the folks at [colorfield](https://colorfield.be/).

## Following colorfield.be

See [Drupal and Docker the easy way with Lando](https://colorfield.be/blog/drupal-and-docker-the-easy-way-with-lando).

```
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ php -d memory_limit=-1 composer.phar create-project drupal-composer/drupal-project:8.x-dev wieting-lando --stability dev --no-interaction
  ...wait for it...
  ╭─mark@Marks-Mac-Mini ~/GitHub
  ╰─$ cd wieting-lando
  ╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
  ╰─$ lando init
  ? From where should we get your app's codebase? current working directory
  ? What recipe do you want to use? drupal8
  ? Where is your webroot relative to the init destination? web
  ? What do you want to call this app? wieting  

NOW WE'RE COOKING WITH FIRE!!!
Your app has been initialized!

Go to the directory where your app was initialized and run `lando start` to get rolling.
Check the LOCATION printed below if you are unsure where to go.

Oh... and here are some vitals:

 NAME      wieting
 LOCATION  /Users/mark/GitHub/wieting-lando
 RECIPE    drupal8
 DOCS      https://docs.devwithlando.io/tutorials/drupal8.html
```

Then...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ atom .    # to add config: keys for via:nginx and database:mariadb
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando start
Let's get this party started! Starting app..
Creating network "landoproxyhyperion5000gandalfedition_edge" with driver "bridge"
Creating landoproxyhyperion5000gandalfedition_proxy_1 ... done
Creating network "wieting_default" with the default driver
Creating wieting_database_1  ... done
Creating wieting_appserver_1 ... done
Creating wieting_appserver_nginx_1 ... done
Waiting until appserver_nginx service is ready...
Waiting until appserver service is ready...
Waiting until database service is ready...

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME                  wieting
 LOCATION              /Users/mark/GitHub/wieting-lando
 SERVICES              appserver_nginx, appserver, database
 APPSERVER_NGINX URLS  https://localhost:32808
                       http://localhost:32809
                       http://wieting.lndo.site
                       https://wieting.lndo.site
```

A visit to [https://wieting.lndo.site](https://wieting.lndo.site) takes me to the `/core/install.php` script where I set the following...

  - Language: English
  - Installation Profile: Standard
  - Database type: MariaDB
  - Database name: drupal8
  - Database username: drupal8
  - Database password: drupal8
  - Host: database

BOOMSHAKALAKA! The site info was already there.  The [site](https://wieting.lndo.site) is up!

## Composer, Drush and Drupal Console

Did some checking just to be sure these work...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando composer --version
Composer 1.9.3 2020-02-04 12:58:49
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando drush status
 Drupal version   : 8.8.2
 Site URI         : http://default
 DB driver        : mysql
 DB hostname      : database
 DB port          : 3306
 DB username      : drupal8
 DB name          : drupal8
 Database         : Connected
 Drupal bootstrap : Successful
 Default theme    : bartik
 Admin theme      : seven
 PHP binary       : /usr/local/bin/php
 PHP config       :
 PHP OS           : Linux
 Drush script     : /app/vendor/drush/drush/drush
 Drush version    : 10.2.1
 Drush temp       : /tmp
 Drush configs    : /app/vendor/drush/drush/drush.yml
                    /app/drush/drush.yml
 Install profile  : standard
 Drupal root      : /app/web
 Site path        : sites/default
 Files, Public    : sites/default/files
 Files, Temp      : /tmp
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando drupal about

Drupal Console (1.9.4)
======================

Copy configuration files.
  drupal init

Download, install and serve Drupal 8
  drupal quick:start

Create a new Drupal project
  drupal site:new

Install a Drupal project
  drupal site:install

Lists all available commands
  drupal list

Update project to the latest version.
   drupal self-update

╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$
```

Woot!

## Committing to GitHub

Since there are no secrets in this config, yet, I'm going to push it to _GitHub_.  Specifically... [SummittDweller/wieting-lando](https://github.com/SummittDweller/wieting-lando).

## Restarting Local Development

I'm back at work on the campus of _Grinnell College_ today and am looking to pick up last evening's development here, so I need to "move" my project to a different host, namely _MA8660_.  Let's see if this works...

```
╭─markmcfate@ma8660 ~/GitHub ‹ruby-2.3.0›
╰─$ git clone https://github.com/SummittDweller/wieting-lando
Cloning into 'wieting-lando'...
remote: Enumerating objects: 30, done.
remote: Counting objects: 100% (30/30), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 30 (delta 0), reused 30 (delta 0), pack-reused 0
Unpacking objects: 100% (30/30), done.
╭─markmcfate@ma8660 ~/GitHub ‹ruby-2.3.0›
╰─$ cd wieting-lando           
```

Whoa! The `wieting-lando` directory looks a little empty, probably because I see that my `.gitignore` file ignored alot of stuff. :frowning:  No matter, let's see if we can work some magic...

```
╭─markmcfate@ma8660 ~/GitHub/wieting-lando ‹ruby-2.3.0› ‹master›
╰─$ lando composer update
  ...and the magic happens...
╭─markmcfate@ma8660 ~/GitHub/wieting-lando ‹ruby-2.3.0› ‹master›
╰─$ lando start
Let's get this party started! Starting app..
  ...more magic...
Waiting until database service is ready...

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME                  wieting
 LOCATION              /Users/markmcfate/GitHub/wieting-lando
 SERVICES              appserver_nginx, appserver, database
 APPSERVER_NGINX URLS  https://localhost:32773
                       http://localhost:32774
                       http://wieting.lndo.site:8000
                       https://wieting.lndo.site:444
```

And BOOM, we are ready to install a new site again!

## Switching Gears...Again

I'm turning my attention now to `summitt-dweller-DO-docker` and https://github.com/mogtofu33/docker-compose-drupal(https://github.com/mogtofu33/docker-compose-drupal) which I recently forked to [https://github.com/SummittDweller/docker-compose-drupal](https://github.com/SummittDweller/docker-compose-drupal).

My attempt to get my `wieting-lando` Drupal code up and working at _DigitalOcean_ per the instructions in [Installation and configuration](https://github.com/SummittDweller/docker-compose-drupal#installation-and-configuration) working as `administrator` on `summitt-dweller-DO-docker` looks like this:

```
╭─administrator@summitt-dweller-DO-docker /opt
╰─$ git clone https://github.com/SummittDweller/docker-compose-drupal.git
╭─administrator@summitt-dweller-DO-docker /opt
╰─$ cd docker-compose-drupal
╭─administrator@summitt-dweller-DO-docker /opt/docker-compose-drupal ‹master›
╰─$ git checkout -b wieting
╭─administrator@summitt-dweller-DO-docker /opt/docker-compose-drupal ‹wieting›
╰─$ cp docker-compose.tpl.yml docker-compose.yml\ncp default.env .env
╭─administrator@summitt-dweller-DO-docker /opt/docker-compose-drupal ‹wieting›
╰─$ nano .env   # to make recommended edits
╭─administrator@summitt-dweller-DO-docker /opt/docker-compose-drupal ‹wieting›
╰─$ nano docker-compose.yml   # to make recommended edits
╭─administrator@summitt-dweller-DO-docker /opt/docker-compose-drupal ‹wieting›
╰─$ docker-compose config   # to check the config...good to go
```

Then from `MA8660`...

```
╭─markmcfate@ma8660 ~/GitHub/wieting-lando ‹ruby-2.3.0› ‹master*›
╰─$ rsync -aruvi . administrator@104.248.237.235:/opt/docker-compose-drupal/drupal/. --progress
```

Then back on `summitt-dweller-DO-docker`...

```
╭─administrator@summitt-dweller-DO-docker /opt/docker-compose-drupal ‹wieting›
╰─$ docker-compose up --build -d
```

But this command failed because of two issues:

  - `Cannot start service portainer: driver failed programming external connectivity on endpoint wieting-portainer` - _Portainer_ is already running on this node, we don't need it again!
  - `Cannot start service nginx: driver failed programming external connectivity on endpoint wieting-nginx` - Sure, port 80 is already occupied...we need some _Traefik_ magic here!


<!--
## Next Step...Ensure That I Can Deploy to `summitt-dweller-DO-docker`

Taking a look at the aforementioned server indicates 3 services running under a _Traefik_ reverse-proxy that serves [https://Wieting.TamaToledo.net](https://Wieting.TamaToledo.net).  The services are:

  - wodby/drupal-php:7.1-dev-4.4.2   "/docker-entrypoint.…"  9000/tcp  wieting_php
  - wodby/drupal-nginx:8-1.13-4.1.0  "/docker-entrypoint.…"  80/tcp    wieting_nginx
  - wodby/mariadb:10.2-3.1.3         "/docker-entrypoint.…"  3306/tcp  wieting_mariadb

That looks a lot like what I have locally with _Lando_.  Now if I can find a "production-capable" stack with a similar architecture...  Hmmm, what about https://github.com/mogtofu33/docker-compose-drupal?  I'll have to check that out next.

╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ mkdir lando-wieting
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ cd lando-wieting
╭─mark@Marks-Mac-Mini ~/GitHub/lando-wieting
╰─$ lando init --recipe drupal8
? From where should we get your app's codebase? current working directory
? Where is your webroot relative to the init destination? web
? What do you want to call this app? wieting

NOW WE'RE COOKING WITH FIRE!!!
Your app has been initialized!

Go to the directory where your app was initialized and run `lando start` to get rolling.
Check the LOCATION printed below if you are unsure where to go.

Oh... and here are some vitals:

 NAME      wieting
 LOCATION  /Users/mark/GitHub/lando-wieting
 RECIPE    drupal8
 DOCS      https://docs.devwithlando.io/tutorials/drupal8.html

╭─mark@Marks-Mac-Mini ~/GitHub/lando-wieting
╰─$ atom .   <-- added config elements for php: 7.2, mariadb, and ngnix
╭─mark@Marks-Mac-Mini ~/GitHub/lando-wieting
╰─$ lando start
Let's get this party started! Starting app..
Creating network "landoproxyhyperion5000gandalfedition_edge" with driver "bridge"
Creating landoproxyhyperion5000gandalfedition_proxy_1 ... done
Creating network "wieting_default" with the default driver
Creating wieting_appserver_1 ... done
Creating wieting_database_1  ... done
Waiting until appserver service is ready...

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME            wieting
 LOCATION        /Users/mark/GitHub/lando-wieting
 SERVICES        appserver, database
 APPSERVER URLS  https://localhost:32796
                 http://localhost:32797
                 http://wieting.lndo.site
                 https://wieting.lndo.site

╭─mark@Marks-Mac-Mini ~/GitHub/lando-wieting
╰─$ lando drush site-install standard --account-name=admin --account-pass=admin --db-url='mysql://drupal8:drupal8@database/drupal8' --site-name=wieting
```




## Migration per Lando Issue 1822

See [Issue 1822](https://github.com/lando/lando/issues/1822) for details.

```
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ mkdir wieting-2020
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ cd wieting-2020
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-2020
╰─$ lando init
? From where should we get your app's codebase? remote git repo or archive
? Please enter the URL of the git repo or tar archive containing your application code https://github.com/drupal-composer/drupal-project
? What recipe do you want to use? drupal8
? Where is your webroot relative to the init destination? web
? What do you want to call this app? wieting
Creating landoinitwieting_init_1 ... done
Detected that https://github.com/drupal-composer/drupal-project is a git repo
Cloning into '.'...
remote: Enumerating objects: 1100, done.
remote: Total 1100 (delta 0), reused 0 (delta 0), pack-reused 1100
Receiving objects: 100% (1100/1100), 281.15 KiB | 0 bytes/s, done.
Resolving deltas: 100% (496/496), done.
Checking connectivity... done.
Copying git clone over to /app...
Stopping landoinitwieting_init_1 ... done
Going to remove landoinitwieting_init_1
Removing landoinitwieting_init_1 ... done

NOW WE'RE COOKING WITH FIRE!!!
Your app has been initialized!

Go to the directory where your app was initialized and run `lando start` to get rolling.
Check the LOCATION printed below if you are unsure where to go.

Oh... and here are some vitals:

 NAME      wieting
 LOCATION  /Users/mark/GitHub/wieting-2020
 RECIPE    drupal8
 DOCS      https://docs.devwithlando.io/tutorials/drupal8.html

╭─mark@Marks-Mac-Mini ~/GitHub/wieting-2020 ‹8.x*›
╰─$ atom .
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-2020 ‹8.x*›
╰─$ lando start
Let's get this party started! Starting app..
Starting landoproxyhyperion5000gandalfedition_proxy_1 ... done
Starting wieting_appserver_1 ... done
Starting wieting_database_1  ... done
Creating wieting_appserver_nginx_1 ... done
Waiting until appserver_nginx service is ready...
Waiting until database service is ready...
Waiting until appserver service is ready...
Waiting until database service is ready...

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME                  wieting
 LOCATION              /Users/mark/GitHub/wieting-2020
 SERVICES              appserver_nginx, appserver, database
 APPSERVER_NGINX URLS  https://localhost:32842
                       http://localhost:32843
                       http://wieting.lndo.site
                       https://wieting.lndo.site

╭─mark@Marks-Mac-Mini ~/GitHub/wieting-2020 ‹8.x*›
╰─$ lando composer install
> Drupal\Composer\Composer::ensureComposerVersion
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
    1/105:	https://codeload.github.com/sebastianbergmann/code-unit-reverse-lookup/legacy.zip/4419fcdb5eabb9caa61a27c7a1db532a6b55dd18
  ...
  drupal/drupal: This package is meant for core development,
                 and not intended to be used for production sites.
                 See: https://www.drupal.org/node/3082474
  Vendor directory already clean.  
```



## My Own Migration Config

```
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ mkdir wieting-lando
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ cd wieting-lando
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ mkdir private tmp
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ ll
total 0
drwxr-xr-x  2 mark  staff    64B Feb 20 13:36 private
drwxr-xr-x  2 mark  staff    64B Feb 20 13:36 tmp
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando init --source remote --remote-url https://github.com/drupal/drupal.git
? What recipe do you want to use? drupal8
? Where is your webroot relative to the init destination? .
? What do you want to call this app? wieting
Creating network "landoinitwieting_default" with the default driver
Creating landoinitwieting_init_1 ... done
Detected that https://github.com/drupal/drupal.git is a git repo
Cloning into '.'...
remote: Enumerating objects: 336, done.
remote: Counting objects: 100% (336/336), done.
remote: Compressing objects: 100% (242/242), done.
remote: Total 718638 (delta 177), reused 169 (delta 89), pack-reused 718302
Receiving objects: 100% (718638/718638), 211.65 MiB | 15.63 MiB/s, done.
Resolving deltas: 100% (501214/501214), done.
Checking connectivity... done.
Copying git clone over to /app...
Stopping landoinitwieting_init_1 ... done
Going to remove landoinitwieting_init_1
Removing landoinitwieting_init_1 ... done

NOW WE'RE COOKING WITH FIRE!!!
Your app has been initialized!

Go to the directory where your app was initialized and run `lando start` to get rolling.
Check the LOCATION printed below if you are unsure where to go.

Oh... and here are some vitals:

 NAME      wieting
 LOCATION  /Users/mark/GitHub/wieting-lando
 RECIPE    drupal8
 DOCS      https://docs.devwithlando.io/tutorials/drupal8.html

╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando ‹8.8.x*›
╰─$ lando start              
Let's get this party started! Starting app..
Creating network "landoproxyhyperion5000gandalfedition_edge" with driver "bridge"
Creating landoproxyhyperion5000gandalfedition_proxy_1 ... done
Pulling database (bitnami/mysql:5.7)...
5.7: Pulling from bitnami/mysql
6729c2f8f6ae: Already exists
6a297d9ad4fc: Pull complete
3bfbc5cebc5b: Pull complete
4dbc491146aa: Pull complete
0bb2bd335d54: Pull complete
05618a0409f7: Pull complete
49891e5ca23e: Pull complete
6d98a11b2d5e: Pull complete
5d849b2cc430: Pull complete
Digest: sha256:4ece1b5e1fbd0d3bf176ed4919d26aa4b4b0c3e4303f7aabdb3137e89cf49fba
Status: Downloaded newer image for bitnami/mysql:5.7
Pulling appserver (devwithlando/php:7.2-apache-2)...
7.2-apache-2: Pulling from devwithlando/php
7.2-apache-2: Pulling from devwithlando/php
619014d83c02: Already exists
f4714e5926d3: Already exists
83f2e17b3109: Already exists
85e8f49d6f5d: Already exists
ea8f9d93b7a1: Pull complete
21e7e4734c6e: Pull complete
5a155d22afc0: Pull complete
e1f0863dde72: Pull complete
c5197c75ba18: Pull complete
9d2de194b1f8: Pull complete
ee19714b23e2: Pull complete
e2799251f791: Pull complete
1223f2c8cadd: Pull complete
c157bfb9bb6d: Pull complete
Digest: sha256:adebb98251aeef3c5ba41ca6481e2287ef6869fae58ff9e4500411af498eeae2
Status: Downloaded newer image for devwithlando/php:7.2-apache-2
Starting wieting_appserver_1 ... done
Creating wieting_database_1  ... done
Waiting until database service is ready...

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME            wieting
 LOCATION        /Users/mark/GitHub/wieting-lando
 SERVICES        appserver, database
 APPSERVER URLS  http://wieting.lndo.site
                 https://wieting.lndo.site

```

## Migration Per norwegian.blue

```
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ mkdir wieting-lando
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ cd wieting-lando
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ mkdir private
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ mkdir tmp
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando init
? From where should we get your app's codebase? current working directory
? What recipe do you want to use? drupal8
? Where is your webroot relative to the init destination? htdocs
? What do you want to call this app? wieting

NOW WE'RE COOKING WITH FIRE!!!
Your app has been initialized!

Go to the directory where your app was initialized and run `lando start` to get rolling.
Check the LOCATION printed below if you are unsure where to go.

Oh... and here are some vitals:

 NAME      wieting
 LOCATION  /Users/mark/GitHub/wieting-lando
 RECIPE    drupal8
 DOCS      https://docs.devwithlando.io/tutorials/drupal8.html

╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ atom .
```

I edited my `.lando.yml` file as directed using _Atom_, so that it looks like this:

```
name: wieting
recipe: drupal8
config:
  webroot: htdocs
  php: '7.2'
  via: nginx
  database: mariadb
  xdebug: true
```

Then...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando start
Let's get this party started! Starting app..
Starting landoproxyhyperion5000gandalfedition_proxy_1 ... done
Starting wieting_database_1  ... done
Starting wieting_appserver_1 ... done
Starting wieting_appserver_nginx_1 ... done
Creating wieting_appserver_1 ... done
Creating wieting_appserver_nginx_1 ... done
Stopping wieting_appserver_nginx_1 ... done
Creating wieting_database_1 ... done
Stopping wieting_database_1 ... done

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME                  wieting
 LOCATION              /Users/mark/GitHub/wieting-lando
 SERVICES              appserver_nginx, appserver, database
 APPSERVER_NGINX URLS  http://wieting.lndo.site
                       https://wieting.lndo.site
```

## Departing From the `norweigian.blue` Script

I found that the [https://norwegian.blue/node/86](https://norwegian.blue/node/86) script got a little messy around Step 7, so borrowing guidance from [Composer template for Drupal projects](https://github.com/drupal-composer/drupal-project) I changed things up a bit, like so:

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando composer create-project drupal/recommended-project drupal8 --no-interaction

```

 This seems to have worked nicely, putting my _Drupal_ installation in a sub-directory of the project at `drupal8`.  However, this takes `drush`, and perhaps other tools, out of the `appserver` container's `$PATH` and that's not gonna work.

Aha! Me thinks the solution to this problem lies in the [Lando - Drupal 8 - Using Drush](https://docs.lando.dev/config/drupal8.html#using-drush) documentation.


 So I edited the new `composer.json` using _Atom_, adding two new lines to the `extra:installer-paths` key, like so:

```
  "web/themes/custom/{$name}": ["type:drupal-custom-theme"],
  "web/modules/custom/{$name}": ["type:drupal-custom-module"]
```

 Then I did...

 ```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ cd drupal8                    
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando composer config repositories.wieting vcs https://github.com/SummittDweller/wieting.git
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando composer config repositories.wieting_theme vcs https://github.com/SummittDweller/wieting_theme.git
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando composer require drupal/antibot drupal/backup_migrate drupal/calendar drupal/calendar_datetime drupal/captcha drupal/checklistapi drupal/ctools drupal/ctools_views drupal/devel drupal/entity_browser drupal/entity_clone drupal/entity_print drupal/entity_print_views drupal/exif drupal/google_analytics drupal/hms_field drupal/image_captcha drupal/imce drupal/kint drupal/mailgun drupal/mailsystem drupal/masquerade drupal/media_entity drupal/media_entity_flickr drupal/media_entity_image drupal/menu_link_highlight drupal/metatag drupal/pathauto drupal/permissions_by_term drupal/profile drupal/redirect drupal/seo_checklist drupal/simplenews drupal/social_media drupal/token drupal/typed_data drupal/views_templates drupal/bootstrap summittdweller/wieting summittdweller/wieting_theme
   ...
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ chmod u+w web/sites/default    # See https://www.drupal.org/forum/support/post-installation/2019-12-09/fresh-install-drupal-880-composer-require-could-not
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando composer update   
```

Once this was done I went back to the [https://norwegian.blue/node/86](https://norwegian.blue/node/86) script, Step 7.3 (the numbering here is a little wonky, but it's the `ln -s drupal...` command).

## Back On Script

As mentioned above, I'm back on the script and proceeding like so...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal-8.x
╰─$ cd ..
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ ln -s drupal8/web htdocs
```

A visit to [http://wieting.lndo.site](http://wieting.lndo.site) takes me to the _Drupal_ install page as intended.

## But `drush` is Broken!

This approach appears to work, thus far, but `drush` is broken in the process.  When I attempt to run a `lando drush status` command, or even run `drush` inside the `appserver` container, I get something like...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando drush status              
OCI runtime exec failed: exec failed: container_linux.go:346: starting container process caused "exec: \"drush\": executable file not found in $PATH": unknown
```

A closer look shows...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando ssh                             
www-data@c00c2bca5d75:/app/drupal8$ echo $PATH
/app/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/www/.composer/vendor/bin
www-data@c00c2bca5d75:/app/drupal8$ cd /app/vendor/bin
bash: cd: /app/vendor/bin: No such file or directory
```

So the `$PATH` in the container is wrong, it should include `/app/druapl8/vendor/bin`.  I posted about this in _Lando_'s _Slack_ #community channel and got back a conversation that begins [here](https://devwithlando.slack.com/archives/C2XBSHX8R/p1582142751438800).  

It's suggested that I can fix this by adding the following to my `.lando.yml` file, my "Landofile":

```
tooling:
  drush:
    cmd:  /app/drupal8/vendor/bin/drush  
```

So I added that and tried `lando drush status` again, but got the same error.  I'm going to do a `lando rebuild`, as suggested, and see if that helps.  Nope, but further investigation shows me that `drush` isn't installed at all, so...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando composer require drush/drush
```

...and then...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal8
╰─$ lando drush status
 Drupal version : 8.8.2
 Site URI       : http://default
 PHP binary     : /usr/local/bin/php
 PHP config     :
 PHP OS         : Linux
 Drush script   : /app/drupal8/vendor/drush/drush/drush
 Drush version  : 10.2.1
 Drush temp     : /tmp
 Drush configs  : /app/drupal8/vendor/drush/drush/drush.yml
 Drupal root    : /app/drupal8/web
 Site path      : sites/default
```

It works!

## But _Drupal Console_ Does Not!

So, running `lando drupal about` does not work, but after a `lando ssh` and some poking around inside the container, I find that running `drupal about` from `/app` shows that the console lives at `/app/drupal/vendor/drupal/console/bin/drupal`.  Let's set that path in `.lando.yml` by adding a new `drupal:cmd` key like so:

```
tooling:
  drush:
    cmd:  /app/drupal8/vendor/bin/drush
  drupal:
    cmd: /app/drupal/vendor/drupal/console/bin/drupal
```

Nope, but let's do another `lando rebuild` and try again.  




I'm going to fix that from within like so...

```


So, I completed entries on that page as instructed, and voila!  The site is up, but bland.  Next steps were largely per the script, but started with bringing a copy of my previously exported `wieting` database into the project like so...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ cp -fr ~/GitHub/.out-of-the-way/wieting-lando2/init-db.d .
```

Then per the script...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando ‹master*›
╰─$ lando db-import init-db.d/backup-2020-02-14T15-06-09.mysql
Preparing to import /app/init-db.d/backup-2020-02-14T15-06-09.mysql into drupal8 on localhost:3306 as root...
Destroying all current tables in drupal8...
NOTE: See the --no-wipe flag to avoid this step!
Dropping batch table from drupal8 database...
Dropping block_content table from drupal8 database...
Dropping block_content__body table from drupal8 database...
Dropping block_content_field_data table from drupal8 database...
Dropping block_content_field_revision table from drupal8 database...
Dropping block_content_revision table from drupal8 database...
Dropping block_content_revision__body table from drupal8 database...
Dropping cache_bootstrap table from drupal8 database...
Dropping cache_config table from drupal8 database...
Dropping cache_container table from drupal8 database...
Dropping cache_data table from drupal8 database...
Dropping cache_default table from drupal8 database...
Dropping cache_discovery table from drupal8 database...
Dropping cache_dynamic_page_cache table from drupal8 database...
Dropping cache_entity table from drupal8 database...
Dropping cache_menu table from drupal8 database...
Dropping cache_page table from drupal8 database...
Dropping cache_render table from drupal8 database...
Dropping cachetags table from drupal8 database...
Dropping comment table from drupal8 database...
Dropping comment__comment_body table from drupal8 database...
Dropping comment_entity_statistics table from drupal8 database...
Dropping comment_field_data table from drupal8 database...
Dropping config table from drupal8 database...
Dropping file_managed table from drupal8 database...
Dropping file_usage table from drupal8 database...
Dropping history table from drupal8 database...
Dropping key_value table from drupal8 database...
Dropping key_value_expire table from drupal8 database...
Dropping menu_link_content table from drupal8 database...
Dropping menu_link_content_data table from drupal8 database...
Dropping menu_link_content_field_revision table from drupal8 database...
Dropping menu_link_content_revision table from drupal8 database...
Dropping menu_tree table from drupal8 database...
Dropping node table from drupal8 database...
Dropping node__body table from drupal8 database...
Dropping node__comment table from drupal8 database...
Dropping node__field_image table from drupal8 database...
Dropping node__field_tags table from drupal8 database...
Dropping node_access table from drupal8 database...
Dropping node_field_data table from drupal8 database...
Dropping node_field_revision table from drupal8 database...
Dropping node_revision table from drupal8 database...
Dropping node_revision__body table from drupal8 database...
Dropping node_revision__comment table from drupal8 database...
Dropping node_revision__field_image table from drupal8 database...
Dropping node_revision__field_tags table from drupal8 database...
Dropping path_alias table from drupal8 database...
Dropping path_alias_revision table from drupal8 database...
Dropping queue table from drupal8 database...
Dropping router table from drupal8 database...
Dropping search_dataset table from drupal8 database...
Dropping search_index table from drupal8 database...
Dropping search_total table from drupal8 database...
Dropping semaphore table from drupal8 database...
Dropping sequences table from drupal8 database...
Dropping sessions table from drupal8 database...
Dropping shortcut table from drupal8 database...
Dropping shortcut_field_data table from drupal8 database...
Dropping shortcut_set_users table from drupal8 database...
Dropping taxonomy_index table from drupal8 database...
Dropping taxonomy_term__parent table from drupal8 database...
Dropping taxonomy_term_data table from drupal8 database...
Dropping taxonomy_term_field_data table from drupal8 database...
Dropping taxonomy_term_field_revision table from drupal8 database...
Dropping taxonomy_term_revision table from drupal8 database...
Dropping taxonomy_term_revision__parent table from drupal8 database...
Dropping user__roles table from drupal8 database...
Dropping user__user_picture table from drupal8 database...
Dropping users table from drupal8 database...
Dropping users_data table from drupal8 database...
Dropping users_field_data table from drupal8 database...
Dropping watchdog table from drupal8 database...
Importing /app/init-db.d/backup-2020-02-14T15-06-09.mysql...

Import complete!
```




Now, to make the project recognize the new database I need to edit, using _Atom_, my 'settings.php' file, that's `./drupal-8.x/web/sites/default/settings.php`.  In that file I change my `default` database settings to match the contents of the database I just imported.  Specifically...

```
$databases['default']['default'] = array (
  'database' => 'wieting',
  'username' => 'drupal',
  'password' => '-> obfuscated <-',
  'prefix' => '',
  'host' => 'database',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
```

Now let's see what we have at [http://wieting.lndo.site](http://wieting.lndo.site)?  **Yes!** That's progress!

## The Config Directory is Empty

So, checking `settings.php` I find, true to form, that the `../config/sync` directory is empty.  That's not right.  Lets go get our last working configuration...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/drupal-8.x
╰─$ rsync -aruvi ~/GitHub/wieting-docksal/config/sync/. . --progress
  ...
sent 1,587,746 bytes  received 18,601 bytes  458,956.29 bytes/sec
total size is 1,496,141  speedup is 0.93
```
 And attempt to apply it with a restart like so:

 ```








## Geerling's Way

So, following Jeff's lead, I'll begin like so:

```
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ git clone --branch 8.8.2 https://git.drupal.org/project/drupal.git lando-d8
Cloning into 'lando-d8'...
warning: redirecting to https://git.drupalcode.org/project/drupal.git/
remote: Enumerating objects: 2379, done.
remote: Counting objects: 100% (2379/2379), done.
remote: Compressing objects: 100% (1132/1132), done.
remote: Total 718333 (delta 1296), reused 2250 (delta 1204), pack-reused 715954
Receiving objects: 100% (718333/718333), 159.26 MiB | 15.63 MiB/s, done.
Resolving deltas: 100% (521457/521457), done.
Note: checking out '55e055c3eeb15c941f92f1db2376e9578a9ddccc'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

Checking out files: 100% (15343/15343), done.
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ cd lando-d8  
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹55e055c3ee›
╰─$ git checkout -b wieting
Switched to a new branch 'wieting'
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting›
╰─$
```

Then, as Jeff suggests...

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting›
╰─$ lando init
? From where should we get your app's codebase? current working directory
? What recipe do you want to use? drupal8
? Where is your webroot relative to the init destination? .
? What do you want to call this app? wieting

NOW WE'RE COOKING WITH FIRE!!!
Your app has been initialized!

Go to the directory where your app was initialized and run `lando start` to get rolling.
Check the LOCATION printed below if you are unsure where to go.

Oh... and here are some vitals:

 NAME      wieting
 LOCATION  /Users/mark/GitHub/lando-d8
 RECIPE    drupal8
 DOCS      https://docs.devwithlando.io/tutorials/drupal8.html

 ╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
 ╰─$ lando start
 Let's get this party started! Starting app..
 landoproxyhyperion5000gandalfedition_proxy_1 is up-to-date
 Pulling appserver (devwithlando/php:7.2-apache-2)...
 7.2-apache-2: Pulling from devwithlando/php
 619014d83c02: Already exists
 f4714e5926d3: Already exists
 83f2e17b3109: Already exists
 85e8f49d6f5d: Already exists
 ea8f9d93b7a1: Pull complete
 21e7e4734c6e: Pull complete
 5a155d22afc0: Pull complete
 e1f0863dde72: Pull complete
 c5197c75ba18: Pull complete
 9d2de194b1f8: Pull complete
 ee19714b23e2: Pull complete
 e2799251f791: Pull complete
 1223f2c8cadd: Pull complete
 c157bfb9bb6d: Pull complete
 Digest: sha256:adebb98251aeef3c5ba41ca6481e2287ef6869fae58ff9e4500411af498eeae2
 Status: Downloaded newer image for devwithlando/php:7.2-apache-2
 Starting wieting_database_1  ... done
 Starting wieting_appserver_1 ... done
 Waiting until database service is ready...
 Waiting until appserver service is ready...
 Waiting until database service is ready...

 BOOMSHAKALAKA!!!

 Your app has started up correctly.
 Here are some vitals:

  NAME            wieting
  LOCATION        /Users/mark/GitHub/lando-d8
  SERVICES        appserver, database
  APPSERVER URLS  http://wieting.lndo.site
                  https://wieting.lndo.site

```

OK, but that's not quite what I wanted, I'd prefer an `NGINX` stack rather than `Apache`.  So let's look at what _Lando_ hath wrought.

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
╰─$ ls -alh
total 624
drwxr-xr-x  27 mark  staff   864B Feb 18 08:52 .
drwxr-xr-x@ 33 mark  staff   1.0K Feb 18 08:49 ..
-rw-r--r--   1 mark  staff   1.0K Feb 18 08:49 .csslintrc
-rw-r--r--   1 mark  staff   357B Feb 18 08:49 .editorconfig
-rw-r--r--   1 mark  staff   151B Feb 18 08:49 .eslintignore
-rw-r--r--   1 mark  staff    41B Feb 18 08:49 .eslintrc.json
drwxr-xr-x  12 mark  staff   384B Feb 18 08:57 .git
-rw-r--r--   1 mark  staff   3.8K Feb 18 08:49 .gitattributes
-rw-r--r--   1 mark  staff   2.3K Feb 18 08:49 .ht.router.php
-rw-r--r--   1 mark  staff   7.7K Feb 18 08:49 .htaccess
-rw-r--r--   1 mark  staff    51B Feb 18 08:52 .lando.yml
-rw-r--r--   1 mark  staff    95B Feb 18 08:49 INSTALL.txt
-rw-r--r--   1 mark  staff   5.8K Feb 18 08:49 README.txt
-rw-r--r--   1 mark  staff   262B Feb 18 08:49 autoload.php
drwxr-xr-x   7 mark  staff   224B Feb 18 08:49 composer
-rw-r--r--   1 mark  staff   4.9K Feb 18 08:49 composer.json
-rw-r--r--   1 mark  staff   224K Feb 18 08:49 composer.lock
drwxr-xr-x  46 mark  staff   1.4K Feb 18 08:49 core
-rw-r--r--   1 mark  staff   1.5K Feb 18 08:49 example.gitignore
-rw-r--r--   1 mark  staff   549B Feb 18 08:49 index.php
drwxr-xr-x   3 mark  staff    96B Feb 18 08:49 modules
drwxr-xr-x   3 mark  staff    96B Feb 18 08:49 profiles
-rw-r--r--   1 mark  staff   1.6K Feb 18 08:49 robots.txt
drwxr-xr-x   7 mark  staff   224B Feb 18 08:49 sites
drwxr-xr-x   3 mark  staff    96B Feb 18 08:49 themes
-rw-r--r--   1 mark  staff   848B Feb 18 08:49 update.php
-rw-r--r--   1 mark  staff   4.5K Feb 18 08:49 web.config
```

## Before I Forget

I found [Lando's "Drupal 8" documentation](https://docs.lando.dev/config/drupal8.html#drupal-8) to be especially helpful for these next steps.  That documentation draws particular attention to the `.lando.yml` file, the "Landofile" in the project root.  Let's have a look...

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
╰─$ cat .lando.yml
name: wieting
recipe: drupal8
config:
  webroot: .
```

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
╰─$ cat composer.json
{
    "name": "drupal/drupal",
    "description": "Drupal is an open source content management platform powering millions of websites and applications.",
    "type": "project",
    "license": "GPL-2.0-or-later",
    "homepage": "https://www.drupal.org/project/drupal",
    "support": {
        "docs": "https://www.drupal.org/docs/user_guide/en/index.html",
        "chat": "https://www.drupal.org/node/314178"
    },
    "require": {
        "composer/installers": "^1.0.24",
        "drupal/core": "self.version",
        "drupal/core-project-message": "self.version",
        "drupal/core-vendor-hardening": "self.version",
        "wikimedia/composer-merge-plugin": "^1.4"
    },
    "require-dev": {
        "behat/mink": "1.7.x-dev",
        "behat/mink-goutte-driver": "^1.2",
        "behat/mink-selenium2-driver": "1.3.x-dev",
        "composer/composer": "^1.9.1",
        "drupal/coder": "^8.3.2",
        "jcalderonzumba/gastonjs": "^1.0.2",
        "jcalderonzumba/mink-phantomjs-driver": "^0.3.1",
        "mikey179/vfsstream": "^1.6.8",
        "phpunit/phpunit": "^6.5 || ^7",
        "phpspec/prophecy": "^1.7",
        "symfony/css-selector": "^3.4.0",
        "symfony/phpunit-bridge": "^3.4.3",
        "symfony/debug": "^3.4.0",
        "justinrainbow/json-schema": "^5.2",
        "symfony/filesystem": "~3.4.0",
        "symfony/finder": "~3.4.0",
        "symfony/lock": "~3.4.0",
        "symfony/browser-kit": "^3.4.0"
    },
    "minimum-stability": "dev",
    "prefer-stable": true,
    "config": {
        "preferred-install": "dist",
        "autoloader-suffix": "Drupal8"
    },
    "extra": {
        "_readme": [
            "By default Drupal loads the autoloader from ./vendor/autoload.php.",
            "To change the autoloader you can edit ./autoload.php.",
            "This file specifies the packages.drupal.org repository.",
            "You can read more about this composer repository at:",
            "https://www.drupal.org/node/2718229"
        ],
        "merge-plugin": {
            "recurse": true,
            "replace": false,
            "merge-extra": false
        },
        "installer-paths": {
            "core": ["type:drupal-core"],
            "libraries/{$name}": ["type:drupal-library"],
            "modules/contrib/{$name}": ["type:drupal-module"],
            "profiles/contrib/{$name}": ["type:drupal-profile"],
            "themes/contrib/{$name}": ["type:drupal-theme"],
            "drush/Commands/contrib/{$name}": ["type:drupal-drush"],
            "modules/custom/{$name}": ["type:drupal-custom-module"],
            "themes/custom/{$name}": ["type:drupal-custom-theme"]
        },
        "drupal-core-project-message": {
            "post-install-cmd-message": [
                "<bg=blue;fg=white>drupal/drupal</>: This package is meant for core development,",
                "               and not intended to be used for production sites.",
                "               See: https://www.drupal.org/node/3082474"
            ],
            "post-create-project-cmd-message": [
                "<bg=red;fg=white>drupal/drupal</>: This package is meant for core development,",
                "               and not intended to be used for production sites.",
                "               See: https://www.drupal.org/node/3082474"
            ]
        }
    },
    "autoload": {
        "psr-4": {
            "Drupal\\Core\\Composer\\": "core/lib/Drupal/Core/Composer"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Drupal\\Composer\\": "composer"
        }
    },
    "scripts": {
        "pre-install-cmd": "Drupal\\Composer\\Composer::ensureComposerVersion",
        "pre-update-cmd": "Drupal\\Composer\\Composer::ensureComposerVersion",
        "pre-autoload-dump": "Drupal\\Core\\Composer\\Composer::preAutoloadDump",
        "drupal-phpunit-upgrade-check": "Drupal\\Core\\Composer\\Composer::upgradePHPUnit",
        "drupal-phpunit-upgrade": "@composer update phpunit/phpunit symfony/phpunit-bridge phpspec/prophecy symfony/yaml --with-dependencies --no-progress",
        "post-update-cmd": [
            "Drupal\\Composer\\Composer::generateMetapackages",
            "Drupal\\Composer\\Composer::ensureBehatDriverVersions"
        ],
        "phpcs": "phpcs --standard=core/phpcs.xml.dist --runtime-set installed_paths $($COMPOSER_BINARY config vendor-dir)/drupal/coder/coder_sniffer --",
        "phpcbf": "phpcbf --standard=core/phpcs.xml.dist --runtime-set installed_paths $($COMPOSER_BINARY config vendor-dir)/drupal/coder/coder_sniffer --"
    },
    "repositories": [
        {
            "type": "composer",
            "url": "https://packages.drupal.org/8"
        },
        {
            "type": "path",
            "url": "core"
        },
        {
            "type": "path",
            "url": "composer/Plugin/ProjectMessage"
        },
        {
            "type": "path",
            "url": "composer/Plugin/VendorHardening"
        }
    ]
}
```

Wow, that "Landofile" is pretty sparse which just means there are LOTS of default values in play here.  The `composer.json` is pretty standard for an initial _Drupal 8_ site too.  I'm going to use the documentation to override some of the "Landofile", and see if I can introduce my own `composer.json` too, using [Atom](https://atom.io), like so:

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
╰─$ atom .
```

I'll document the changes I made above once I'm all done here, but for now suffice it to say that I visited [https://wieting.lndo.site](http://wieting.lndo.site) and got redirected to [http://wieting.lndo.site/core/install.php](http://wieting.lndo.site/core/install.php) to install the site as expected.

## Bringing My Own Database

[The documentation](https://docs.lando.dev/config/drupal8.html#importing-your-database) says that I should be able to import my own database like so:

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
╰─$ cp -f ../wieting/backup-2020-02-14T15-06-09.mysql .
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
╰─$ lando db-import backup-2020-02-14T15-06-09.mysql
Preparing to import /app/backup-2020-02-14T15-06-09.mysql into lemp on localhost:3306 as root...
Destroying all current tables in lemp...
NOTE: See the --no-wipe flag to avoid this step!
Dropping ban_ip table from lemp database...
...
Dropping watchdog table from lemp database...
Importing /app/backup-2020-02-14T15-06-09.mysql...

Import complete!
```

## Bringing My Own `settings.php`

Since the database import wasn't enough, let's make sure we have our trusty old `settings.php` file too:

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8 ‹wieting*›
╰─$ cp -f ../wieting/web/sites/default/settings.php sites/default/.
```

Using _Atom_ again I made one necessary change in the `databases` key by changing `'host' => 'db'` to `'host' => 'database'` inside `settings.php`.

## Adding My Own Composer Parts










First step, on my iMac workstation, `MA8660`, is to clone the _Docksal_ work that I've done thus far:

```
╭─markmcfate@ma8660 ~/GitHub ‹ruby-2.3.0›
╰─$ git clone https://github.com/SummittDweller/wieting-docksal.git wieting-lando
Cloning into 'wieting-lando'...
remote: Enumerating objects: 1150, done.
remote: Counting objects: 100% (1150/1150), done.
remote: Compressing objects: 100% (666/666), done.
remote: Total 1150 (delta 486), reused 1132 (delta 468), pack-reused 0
Receiving objects: 100% (1150/1150), 7.24 MiB | 8.51 MiB/s, done.
Resolving deltas: 100% (486/486), done.
╭─markmcfate@ma8660 ~/GitHub ‹ruby-2.3.0›
╰─$ cd wieting-lando
╭─markmcfate@ma8660 ~/GitHub/wieting-lando ‹ruby-2.3.0› ‹master›
╰─$ lando init
[1]    6483 killed     lando init
```

Whoa, what happened there? `Traps` happened.  The software that GC employs to protect endpoints is blocking execution of `lando`.  So I've filed another ticket to get that resolved...soon, I hope.  :frowning:

# And Now For Something Completely Different...

Actually, not so different, but working from my home office now, where `lando` can run free!  So, from my Mac Mini at home...

```
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ git clone https://github.com/SummittDweller/wieting-docksal.git wieting-lando
Cloning into 'wieting-lando'...
remote: Enumerating objects: 1150, done.
remote: Counting objects: 100% (1150/1150), done.
remote: Compressing objects: 100% (666/666), done.
remote: Total 1150 (delta 486), reused 1132 (delta 468), pack-reused 0
Receiving objects: 100% (1150/1150), 7.24 MiB | 9.47 MiB/s, done.
Resolving deltas: 100% (486/486), done.
╭─mark@Marks-Mac-Mini ~/GitHub
╰─$ cd wieting-lando
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando ‹master›
╰─$ ls -alh
total 141168
drwxr-xr-x  22 mark  staff   704B Feb 17 15:32 .
drwxr-xr-x@ 33 mark  staff   1.0K Feb 17 15:32 ..
drwxr-xr-x   9 mark  staff   288B Feb 17 15:32 .docksal
-rw-r--r--   1 mark  staff   357B Feb 17 15:32 .editorconfig
-rwxr-xr-x   1 mark  staff   746B Feb 17 15:32 .env.example
drwxr-xr-x  12 mark  staff   384B Feb 17 15:34 .git
-rw-r--r--   1 mark  staff   3.8K Feb 17 15:32 .gitattributes
-rwxr-xr-x   1 mark  staff   466B Feb 17 15:32 .gitignore
-rwxr-xr-x   1 mark  staff   169B Feb 17 15:32 .travis.yml
-rwxr-xr-x   1 mark  staff    18K Feb 17 15:32 LICENSE
-rwxr-xr-x   1 mark  staff    39K Feb 17 15:32 README.md
-rw-r--r--   1 mark  staff   9.5M Feb 17 15:32 backup-2020-02-14T15-06-09.mysql
-rwxr-xr-x   1 mark  staff   4.8K Feb 17 15:32 composer.json
-rw-r--r--   1 mark  staff   446K Feb 17 15:32 composer.lock
drwxr-xr-x   3 mark  staff    96B Feb 17 15:32 config
drwxr-xr-x   6 mark  staff   192B Feb 17 15:32 drush
-rwxr-xr-x   1 mark  staff   414B Feb 17 15:32 load.environment.php
-rwxr-xr-x   1 mark  staff   481B Feb 17 15:32 phpunit.xml.dist
drwxr-xr-x   3 mark  staff    96B Feb 17 15:32 scripts
-rw-r--r--   1 mark  staff    29M Feb 17 15:32 sql-dump_2020-02-14-14-31.sql
-rw-r--r--   1 mark  staff    29M Feb 17 15:32 sql-dump_2020-02-14-14-31.sql.original
drwxr-xr-x  18 mark  staff   576B Feb 17 15:32 web
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando ‹master›
╰─$ rm -fr .docksal .git
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando init
? From where should we get your app's codebase? current working directory
? What recipe do you want to use? lemp
? Where is your webroot relative to the init destination? web
? What do you want to call this app? wieting

NOW WE'RE COOKING WITH FIRE!!!
Your app has been initialized!

Go to the directory where your app was initialized and run `lando start` to get rolling.
Check the LOCATION printed below if you are unsure where to go.

Oh... and here are some vitals:

 NAME      wieting
 LOCATION  /Users/mark/GitHub/wieting-lando
 RECIPE    lemp
 DOCS      https://docs.devwithlando.io/tutorials/lemp.html

╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando start
Let's get this party started! Starting app..
landoproxyhyperion5000gandalfedition_proxy_1 is up-to-date
Starting wieting_database_1  ... done
Starting wieting_appserver_1 ... done
Starting wieting_appserver_nginx_1 ... done
Waiting until appserver_nginx service is ready...
Waiting until database service is ready...
Waiting until appserver service is ready...

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME                  wieting
 LOCATION              /Users/mark/GitHub/wieting-lando
 SERVICES              appserver_nginx, appserver, database
 APPSERVER_NGINX URLS  https://localhost:32779
                       http://localhost:32780
                       http://wieting.lndo.site
                       https://wieting.lndo.site

╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$
```

# Before I Forget

I found [Lando's "Drupal 8" documentation](https://docs.lando.dev/config/drupal8.html#drupal-8) to be especially helpful for these next steps.

# Progress Report

The result of the actions documented above... a _Drupal_ 8.8.2 framework for creation of a new site at [http://wieting.lndo.site/core/install.php](http://wieting.lndo.site/core/install.php).  But, that's not entirely what I had in mind, so what's missing?  A little sleuthing inside the `wieting_appserver_1` container shows me that the first missing component is a proper `/var/www/web/sites/default/settings.php` file.  The one that _Lando_ initialized has only the default values for things...no database!  And why would that be the case?  Because my `wieting-docksal` repository on _GitHub_ has no such file.  Let's fix that by bringing the stack down, and introducing a proper file into this new project...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando stop
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ cd web/sites/default
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando/web/sites/default
╰─$ cp -f ~/GitHub/wieting-docksal/web/sites/default/settings.php .
```

Based on the documentation, we need to make at least one small change to our `settings.php`, the database host name in a _Lando_ stack should be `database`, not `db`.

Having made that one change, lets start the stack again...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando start
Let's get this party started! Starting app..
landoproxyhyperion5000gandalfedition_proxy_1 is up-to-date
Starting wieting_database_1        ... done
Starting wieting_appserver_1 ... done
Starting wieting_appserver_nginx_1 ... done
Waiting until appserver_nginx service is ready...
Waiting until database service is ready...
Waiting until appserver service is ready...
Waiting until database service is ready...
Waiting until database service is ready...
Waiting until database service is ready...
Waiting until database service is ready...

BOOMSHAKALAKA!!!

Your app has started up correctly.
Here are some vitals:

 NAME                  wieting
 LOCATION              /Users/mark/GitHub/wieting-lando
 SERVICES              appserver_nginx, appserver, database
 APPSERVER_NGINX URLS  https://localhost:32796
                       http://localhost:32797
                       http://wieting.lndo.site
                       https://wieting.lndo.site
```

And the services...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ docker ps --format "{{.Names}}\t {{.Status}}\t  {{.Command}}"
wieting_appserver_nginx_1	 Up 6 minutes	  "/lando-entrypoint.s…"
wieting_database_1	 Up 6 minutes (healthy)	  "/lando-entrypoint.s…"
wieting_appserver_1	 Up 6 minutes	  "/lando-entrypoint.s…"
landoproxyhyperion5000gandalfedition_proxy_1	 Up 46 hours	  "/lando-entrypoint.s…"
```

And the rest of the stack's landscape...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando info
[
  {
    service: 'appserver_nginx',
    urls: [
      'https://localhost:32796',
      'http://localhost:32797',
      'http://wieting.lndo.site',
      'https://wieting.lndo.site'
    ],
    type: 'docker-compose',
    hostnames: [
      'appserver_nginx.wieting.internal'
    ]
  },
  {
    service: 'appserver',
    urls: [],
    type: 'php',
    via: 'nginx',
    served_by: 'appserver_nginx',
    webroot: 'web',
    config: {},
    version: '7.3',
    meUser: 'www-data',
    hostnames: [
      'appserver.wieting.internal'
    ]
  },
  {
    service: 'database',
    urls: [],
    type: 'mysql',
    internal_connection: {
      host: 'database',
      port: '3306'
    },
    external_connection: {
      host: 'localhost',
      port: '32795'
    },
    creds: {
      database: 'lemp',
      password: 'lemp',
      user: 'lemp'
    },
    config: {},
    version: '5.7',
    meUser: 'www-data',
    hostnames: [
      'database.wieting.internal'
    ]
  }
]
```

# Importing the Database

The `backup-2020-02-14T15-06-09.mysql` in my project root is a .mysql dump of my previous `wieting-docksal` work and should do nicely as an import to this new framework. According to the [Importing Your Database](https://docs.lando.dev/config/drupal8.html#importing-your-database) portion of the documentation, I should be able to import this database like so:

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando db-import backup-2020-02-14T15-06-09.mysql
Preparing to import /app/backup-2020-02-14T15-06-09.mysql into lemp on localhost:3306 as root...
Destroying all current tables in lemp...
NOTE: See the --no-wipe flag to avoid this step!
Importing /app/backup-2020-02-14T15-06-09.mysql...

Import complete!
```

# OK, WHat Do We Have Now?

Nope, the stack is still prompting me to create a new site, but why?  Well, the [ssh](https://docs.lando.dev/basics/ssh.html#ssh) portion of the documentation says I can open a terminal inside any container, so lets try...

```
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-lando
╰─$ lando ssh bash
www-data@4609ebe2804e:/app$
```

We're in!  And I see one potential problem, our `settings.php` file still has open permissions, like so:

```
www-data@4609ebe2804e:/app/web/sites/default$ ls -alh
total 72K
drwxr-xr-x 6 www-data dialout  192 Feb 16 06:22 .
drwxr-xr-x 6 www-data dialout  192 Feb 16 05:34 ..
-rw-r--r-- 1 www-data dialout 6.7K Feb 16 05:34 default.services.yml
-rw-r--r-- 1 www-data dialout  30K Feb 16 05:34 default.settings.php
drwxrwxrwx 2 www-data dialout   64 Feb 16 06:22 files
-rw-rw-rw- 1 www-data dialout  30K Feb 16 06:22 settings.php
```

Let's fix that and see what happens...

```
www-data@4609ebe2804e:/app/web/sites/default$ chmod 444 settings.php
```

Still no joy.  :frowning:



So, according to the documentation, we should be able to run `drush` like so:

```
cd web/sites/default
lando drush status
```


to import it using `drush`...

```

-->

And that's...promising.  I'll be back.  :smile:
