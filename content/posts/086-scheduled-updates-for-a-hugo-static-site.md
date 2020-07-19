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

First, I set up events in the _Calendar_ app on the days I wanted the site to rebuild. I named these events "CRB Reload".

  {{% figure title="Calendar screenshot" src="/images/post-086/calendar-screenshot.jpeg" %}}

Next, I launched _Automator_, and started a new workflow document.

  {{% figure title="Automator screenshot" src="/images/post-086/automator-start.png" %}}

Under _Library_, I opened the _Calendar_ options, and dragged 'Filter Calendar Items/Events' into the workspace.

  {{% figure title="Calendar library" src="/images/post-086/calendar-library.jpeg" %}}

I set the filter to pick up any events titled "CRB Reload" that were occurring on the current day.

  {{% figure title="Calendar filter" src="/images/post-086/calendar-filter.png" %}}

Next, I tested out a few options in the _Utilities_ library.

  {{% figure title="Utilities library" src="/images/post-086/utilities-library.jpeg" %}}

At first I tried using shell script to navigate to the site folder containing the `push-update.sh` file, but the file, at that time, had `docker login` commands hard-coded in, and required user input to run. I couldn't just add the `docker login` info to the file and expose the login credentials, so, after some Googling I decided to create a .txt file in my home directory containing only the docker password, and then passed that in to the `docker login` command using `cat` as documented in [Provide a password using STDIN](https://docs.docker.com/engine/reference/commandline/login/#provide-a-password-using-stdin).

  {{% figure title="my_password.txt file" src="/images/post-086/text-file.jpeg" %}}

I also updated `push-update.sh` so it contained only one login instead of the three `docker login` commands that were there previously.

  {{% figure title="The push-update.sh script" src="/images/post-086/push-update-file.jpeg" %}}

Now that I had a secure way to pass docker credentials to the login command, I could finish setting up the navigate-and-execute script in Automator. I dragged the option to 'Run AppleScript' into the work space under the calendar filter, and set up a script to `cd` into the site folder and then execute the `push-update.sh` file.

  {{% figure title="Workflow" src="/images/post-086/full-workflow.jpeg" %}}

Throughout the process I used the 'Run' option (in the top right of the _Automator_ window) to test out the workflow. Now I can relax and watch it do its thing! :sweat_smile:

And that's a wrap. Until next time...
**Thank you Mackenzie!**
