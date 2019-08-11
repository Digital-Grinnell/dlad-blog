---
title: "Building Grocy in Docksal"
publishDate: 2019-08-08
lastmod: 2019-08-11T08:34:34-05:00
tags:
  - Grocy
  - Docker
  - Docksal
  - fin
  - docker-compose
---
[Grocy](https://github.com/grocy/grocy) looks lika a great little PHP stack application for me. It's aim is to help folks organize and inventory their "stuff", with a slant toward food and groceries. I need this!

Since I'm also a big fan of [Docker](https://docker.io) and [Docksal](https://docksal.io), naturally I wanted to spin Grocy up in one of these environments.  Thankfully, the heavy lifting of getting this "Dockerized" has already been done, and that fine work is shared in GitHub at [grocy/grocy-docker](https://github.com/grocy/grocy-docker). So my quest last evening started with a fork of this GitHub project to [SummittDweller/grocy-docker](https://github.com/SummittDweller/grocy-docker), where I've created a new `docksal` branch.

| Disclaimer |
| --- |
| Note that `grocy` is not really work-related for me, but this process of "Dockerizing" and "Docksalizing" it is. So that's why this post is here and not in my personal blog. |  

## Dockerizing the Local Stack

I first forked the project using GitHub's interface, then switched to my personal MacBook and the terminal there, like this:

| Workstation Commands |
| --- |
| cd ~/Projects <br/> git clone https://github.com/SummittDweller/grocy-docker # clone the fork to local </br> cd grocy-docker <br/> git checkout -b docksal # create a new `docksal` local branch <br/> atom . # open the new local project directory in my [Atom](https://atom.io) editor <br/> docker-compose pull # pull the images as instructed <br/> docker-compose up -d # bring up the stack before any modifications |

I should mention that before all of this I edited my MacBook's `/etc/hosts` file to make sure I had only one active entry there for `127.0.0.1  localhost`.  :ballot_box_with_check: Confirmed.

So, I opened my browser to `https://localhost` as directed in the [grocy-docker documentation](https://github.com/grocy/grocy-docker). :100: Nice!

The original `docker-compose.yml` file for this project creates a Docker-managed volume called `database` and maps that volume to the `grocy` container's `/www` directory, one level above the `/www/public` webroot. The pertinent lines from `docker-compose.yml` look like this:

```
grocy:
  ...
  volumes:
    - database:/www
  ...
volumes:
  database:
```

That effectively "persists" any changes I make, until I remove them, of course. To test persistence, with the stack still running at https://localhost I entered the default `admin` user and `admin` password, navigated to the `Master` data options and proceeded to add a couple `locations` to my data.  

Next, with the stack still running I made a new host copy of it all, brought the stack down, changed the configuration, then brought it back up again with the new configuration, like so:

| Workstation Commands |
| --- |
| cd ~/Projects/grocy-docker <br/> mkdir docroot # makes a new folder on the host <br/> docker cp grocy:/www/. ./docroot/ # copy contents of `www` in the `grocy` container to the host's new directory <br/> docker-compose down # bring the stack down |

While this approach is OK, I wanted something a little more flexible with an accessible, persistent copy of the code and data on my MacBook host, so I used Atom to edit the `docksal` copy of `docker-compose.yml` to look like this:

```
grocy:
  ...
  volumes:
    # - database:/www
    - ./docroot:/www
  ...
# volumes:
#   database:
```

Then...
| Workstation Commands |
| --- |
| cd ~/Projects/grocy-docker <br/> docker-compose up -d # bring the stack back up again with the new directory mapping |

Ok, another visit to https://localhost confirms that the stack is working, and when I navigated back into the `Master` data my `locations` are still there. :ballot_box_with_check: Woot!

## Docksalizing the Local Stack

Ok, not sure I did this "correctly", but this process works.

| Workstation Commands |
| --- |
| cd ~/Projects/grocy-docker <br/> git checkout -b docksal # switch to the `docksal` local branch <br/> atom . # open the new local project directory in my [Atom](https://atom.io) editor <br/> fin config generate # accept the default and make this a `Docksal` stack |

The last command in the above sequence created a new `.docksal` directory in my project. Yay! It also created a new `index.php` file in the project's `./docroot` directory.  That's not quite right (and I'm not sure how to make `fin config generate` behave better), but easy to "fix".

I opened `./.docksal/docksal.env` in Atom and changed it to read:
```
DOCKSAL_STACK=default
# DOCROOT=docroot
DOCROOT=docroot/public
```
This simple change effectively moves the default `DOCROOT` target from `./docroot/index.php` to the correct `grocy` target of `./docroot/public/index.php`.

To test this change...

| Workstation Commands |
| --- |
| cd ~/Projects/grocy-docker <br/> git checkout -b docksal <br/> docker-compose down # bring the stack down <br/> docker stop $(docker ps -q) # stop the containers <br/> docker rm -v $(docker ps -qa) # remove the stopped containers <br/> fin up # bring up the new "Docksalized" stack |

Now a visit to http://grocy-docker.docksal as directed... and the stack is still working! When I navigated back into the `Master` data my `locations` are still there too. :ballot_box_with_check: Woot!

To bring the stack down...

| Workstation Commands |
| --- |
| cd ~/Projects/grocy-docker <br/> git checkout -b docksal <br/> fin stop # bring the "Docksalized" stack down |

Rinse and repeat as necessary.

## Weekend Improvements (the Best Kind!)

A few days ago, when this post was originally written, I also posted a "feature request" into the [Grocy issues queue](https://github.com/grocy/grocy/issues); specifically, it is [issue 341](https://github.com/grocy/grocy/issues/341), which is now closed.

Within a few hours there were comments posted to this issue; apparently other folks thought this would be a nice addition too. :simple_smile: Not long after that, Grocy's author, [Bernd Bestel](https://berrnd.de/) posted [this comment](https://github.com/grocy/grocy/issues/341#issuecomment-520152023):

{{% original %}}
Sure, any contributions are very welcome. :)

...but I'm already fiddling together a first draft about this ... will show you in a couple of minutes ... feel free to improve it then... :)
{{% /original %}}

Wow... I definitely owe Bernd a beverage of his choosing next time I'm in Germany!  But I digress...

Since I'm developing on a Mac, and not Windows, I can't easily run the Grocy code "directly" out-of-the-box; I need Docker for that.  Understandably, the `grocy-docker` project builds, or pulls, the latest tagged version of `grocy/grocy`, not the latest code, which resides in the `master` branch of the repo.  So I set to work trying to figure out how to build a Docker, and then Docksal, environment from Bernd's `master`.

I made this key substitution in the project's `Dockerfile-grocy`, along with a few associated and necessary changes:

```
#        wget -t 3 -T 30 -nv -O "grocy.zip" "https://github.com/grocy/grocy/archive/v${GROCY_VERSION}.zip" && \
        wget -t 3 -T 30 -nv -O "grocy.zip" "https://github.com/grocy/grocy/zipball/master" && \
```
...and it works using this local command-line process to implement it all.

| Workstation Commands |
| --- |
| cd ~/Projects/grocy-docker <br/> git checkout -b docksal <br/> docker stop $(docker ps -q); docker rm -v $(docker ps -qa); docker image rm --force $(docker image ls -q); docker system prune --force <br/> rm -fr docroot/* docroot/.yarnrc <br/> docker-compose build; docker-compose up -d <br/> docker cp grocy:/www/. docroot/ <br/> docker-compose down <br/> touch docroot/data/demo.txt <br/> fin up |

The first three lines ensure I'm working in the right location, then bring ALL Docker stacks down and clean-up. Line 4 removes any remnants of my previous `./docroot` capture, without removing `./docroot` itself. The 5th line rebuilds `grocy` in Docker, not Docksal, and starts up the stack.  Line 6 makes a copy of the running `grocy` container for safe-keeping. Line 7 brings the Docker stack down.  Line 8 creates an empty `./docroot/data/demo.txt` file in order to populate my project with a robust set of default locations and items (see [this documentation](https://github.com/grocy/grocy#demo-mode) for details). Line 9 brings the new stack back up in Docksal.

### Woot! It works.
I'm pushing the latest changes to the `docksal` branch of https://github.com/SummittDweller/grocy-docker.git at this very moment.  

And that's a wrap.  Until next time...
