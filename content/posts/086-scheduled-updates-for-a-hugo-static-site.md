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

I tried a few different ideas I'd heard about, including [crontab](http://crontab.org), but on my Mac desktop I ended up settling on an [Automator](https://support.apple.com/guide/automator/welcome/mac) workflow.

## Calendar Events and Automator Setup

First, I set up a repeating event in the _Calendar_ app on the days I wanted the site to rebuild. I named these events "CRB Reload".

  {{% figure title="Calendar screenshot" src="/images/post-086/calendar-screenshot.png" %}}

Next, I launched _Automator_, and started a new _Calendar Alarm_ document.

  {{% figure title="Automator screenshot" src="/images/post-086/automator-start.png" %}}

Under _Library_, I opened the _Calendar_ options, and dragged _Filter Calendar Items_ into the workspace.

  {{% figure title="Calendar library" src="/images/post-086/calendar-library.png" %}}

I set the filter to pick up any events titled "CRB Reload" that were occurring on the current day.

  {{% figure title="Calendar filter" src="/images/post-086/calendar-filter.png" %}}

Next, I tested out a few options in the _Utilities_ library.

  {{% figure title="Utilities library" src="/images/post-086/utilities-library.jpeg" %}}

## Shell Script

Ultimately I ended up using the _Run Shell Script_ option to navigate to the site folder containing the `push-update.sh` file, but the file, at that time, had `docker login` commands hard-coded in, and required user input to run. I couldn't just add the `docker login` info to the file and expose the login credentials, so, after some Googling I decided to create a .txt file in my home directory containing only the Docker password, and then passed that in to the `docker login` command using `cat` as documented in [Provide a password using STDIN](https://docs.docker.com/engine/reference/commandline/login/#provide-a-password-using-stdin). Note that in the aforementioned .txt file the login password appears on a single line **with NO newline at the end!**

I also updated `push-update.sh` so it contained only one login instead of the three `docker login` commands that were there previously. That script now looks reads like this:

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

## Finishing Up

Now that I had a secure way to pass Docker credentials to the `docker login` command, I could finish setting up the navigate-and-execute script in _Automator_. I dragged the option to 'Run Shell Script' into the workspace under the _Calendar Filter_, and set up a script to `cd` into the site folder and then execute the `push-update.sh` file.  The entire _Calendar Alarm_ in _Automator_ looks like this:

  {{% figure title="Complete Calendar Alarm" src="/images/post-086/full-workflow.png" %}}

## One Final Glitch

Unfortunately, this also failed because Docker was still configured to use a "credstore" that is not what I wanted. A little more searching the web lead me to [this Github Issue post](https://github.com/docker/docker-credential-helpers/issues/149#issuecomment-566832756) and it was just what I needed.  After making the specified change my _Automator_ works nicely.

Throughout the process I used the 'Run' option (in the top right of the _Automator_ window) to test out the workflow. Now I can relax and watch it do its thing! :sweat_smile:

And that's a wrap. Until next time...
**Thank you Mackenzie!**
