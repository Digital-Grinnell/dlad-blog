---
title: Scheduled Updates for a Hugo Static Site
date: 2020-07-18T16:56:04-05:00
author: Mackenzie McFate
tags:
  - docker
  - Automator
  - Hugo
  - calendar
---

A few months ago I migrated a site, [The Compass Rose Band](https://compassroseband.net), from Drupal to Hugo for my Uncle. Since then  I have been maintaining the site, adding and removing dates, and updating the site about every other week. With the passage of time events on the site "automatically" move from "upcoming" to "past", but since it is a "static" site, that only happens when I recompile and rebuild the site.  So I needed to automate builds.

I tried a few different ideas I'd heard about, including [crontab](http://crontab.org), but on my Mac desktop I ended up settling on an [Automator](https://support.apple.com/guide/automator/welcome/mac) workflow tied to a _Calendar_ event.

## Create a Calendar Event in Automator

First, I launched _Automator_, selected `New Document`, then _Calendar Alarm_.  Next, I selected the _Calendar_ path under _Library_, then I dragged _New Calendar Event_ into the workspace on the right half of the window. The _Automator_ startup screen and my new _Calendar Alarm_ config looked like this:

  {{% figure title="Automator startup" src="/images/post-086/automator-start.png" %}}

  {{% figure title="Calendar alarm config" src="/images/post-086/new-calendar-alarm.png" %}}

Take note that in the image above I named my event "CRB-Update", added it to my existing _Automator_ calendar, and set it to happen one time with a duration of zero minutes. It turns out that this settign didn't matter as you'll see later on. Later, I also learned that it's easy to change the frequency and time of the event once it is confirmed to be working properly.

Next, under _Library_ I selected _Utilities_, then I selected _Run Shell Script_ and dragged that into the workspace on the right side of the window, dropping it below my "CRB-Update" event. The new config looked like this with `/bin/bash` selected in the _Shell_ dropdown:

  {{% figure title="Run shell script added" src="/images/post-086/run-shell-script.png" %}}

The commands that I need to run in this _bash_ shell are described in the table below.

| Command | Purpose |
| ---     | ---     |
| cd ~/GitHub/compass-rose-band | Change the working directory to the local home for my CRB site/project. |
| git stash | Make sure any uncommitted changes I've made in this project are stashed away. |
| git pull | Make a "clean" pull of the project from its origin/master branch in GitHub. |
| ./push-update.sh | Execute the _push-update.sh_ script to compile and push the project to production. |

When written as a one-liner this becomes:

```
cd ~/GitHub/compass-rose-band; git stash; git pull; ./push-update.sh
```

  {{% figure title="Shell with commands" src="/images/post-086/shell-with-commands.png" %}}

## push-update.sh Changes

Once I got the _Run Shell Script_ option configured I thought things would work nicely, but the original version of `./push-update.sh` used a series of `docker login` commands without any _Docker_ credentials; it required user input to run properly. I couldn't just add the `docker login` info to the file and expose the login credentials, so, after some Googling I decided to create a .txt file in my home directory containing only the Docker password, and then passed that in to the `docker login` command using `cat` as documented in [Provide a password using STDIN](https://docs.docker.com/engine/reference/commandline/login/#provide-a-password-using-stdin). Note that in the aforementioned .txt file the login password appears on a single line **with NO newline at the end!**

I also updated `push-update.sh` so it contained only one login instead of the three `docker login` commands that were there previously. That script now looks begins like this:

```
#!/bin/bash
# current=`git symbolic-ref --short -q HEAD`
# git checkout ${current}

## Login to docker, one time only!
cat ~/summittdweller-docker-login.txt | /usr/local/bin/docker login -u summittdweller --password-stdin

# Compile the site before copying to the new image.  Round 1 = compassroseband.net
/usr/local/bin/hugo --ignoreCache --ignoreVendor --minify --debug --verbose --baseURL=https://compassroseband.net
echo "Hugo's compassroseband.net compilation is complete."
echo "Starting docker image build..."
/usr/local/bin/docker image build -f push-update-Dockerfile --no-cache -t compassrose .
echo "docker image build is complete."
/usr/local/bin/docker tag compassrose summittdweller/compassrose1:latest
/usr/local/bin/docker push summittdweller/compassrose1:latest
...
```

## One Final Glitch

Unfortunately, this also failed because Docker was still configured to use a "credstore" that is not what I wanted. A little more searching the web lead me to [this Github Issue post](https://github.com/docker/docker-credential-helpers/issues/149#issuecomment-566832756) and it was just what I needed.  After making the specified change my _Automator_ seems to works nicely.

## Saving the Full Configuration

Just one thing left to do in order to wrap things up... save my work.  To do this I clicked _File_ and _Save_ in the _Automator_ main menu, and saved the configuration with a name of "CRB-Update.app" with a type of _Calendar Alarm_. The complete configuration looked like this:

  {{% figure title="Complete CRB-Update.app Configuration" src="/images/post-086/full-config.png" %}}

Saving the configruation as "CRB-Update.app" automatically creates a new immediate _Calendar_ event, and this is a nice feature because it effectively runs a live test of the config.  In my case it created an event like so:

  {{% figure title="New Calendar Event" src="/images/post-086/new-event.png" %}}

Thankfully, the "test" that this "immedaite" event initiated worked perfectly!  So, the only thing left was to duplicate the "CRB-Update" event and give it a reasonable start time and recurrence.  My end result looks like this in _Calendar_:

  {{% figure title="Final Calendar Events" src="/images/post-086/final-events.png" %}}

## It Works!

Throughout the process I used the `Run` option (in the top right of the _Automator_ window) to test out the workflow.  Now that it works I can relax and watch it do its thing! :sweat_smile:

And that's a wrap. Until next time...
**Thank you Mackenzie!**
