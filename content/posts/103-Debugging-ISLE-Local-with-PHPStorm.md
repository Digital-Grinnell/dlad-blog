---
title: "Debugging ISLE Local with PHPStorm"
date: 2021-03-17T08:39:33-05:00
publishdate: 2021-03-12
draft: false
emoji: true
tags:
    - debug
    - XDEBUG
    - ISLE
    - local
    - PHPStorm
    - drush
---

For the past couple of years I've been working in [Digital.Grinnell](https://digital.grinnell.edu) to remove as much "customization" as I can. The effort is coming along, but still, there's a long way to go.  Every now and then I come across a feature that we just can't live without, and it's in times like those that I turn to [PHPStorm](https://www.jetbrains.com/phpstorm/) for development and testing. Unfortunately, I've been operating without _PHPStorm_ in [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) because I worried that configuring the _PHPStorm_ debugger in a Docker environment would be a time-consuming, tall task.  It **was** tricky, but worry no more!   

## The Goal

Simple: Get _PHPStorm_ configured with _ISLE_ and my `http://dg.localdomain` development instance of _Digital.Grinnell_, with real-time debugging. I do my development on any one of three Mac's, so making things work in an OS X environment was also a requirement.  I searched, seemingly for days, through a host of blog posts, tutorials, and documents, for any applicable guidance that might get me to my goal.  There is LOTS of advice and guidance available, but in many cases it's for a very specific environment, or written strictly from a "How I Did It" perspective, with little or no explanation of "why" certain things were done.  

This post is another "How I Did It" account, but the resources I used include some welcome explanations.  

## The Resources

There was one key document that I came to rely on: [Turbocharged PHP Development with Xdebug, Docker & PHPStorm](https://dev.to/jump24/turbocharged-php-development-with-xdebug-docker-phpstorm-1n6c), a [dev.to](https://dev.to/) blog post by [James Seconde](https://dev.to/secondej).  Thank you, James!  Excellent work, and thank you for sharing!  

The other document that's still open in my browser is [Create a local server configuration](https://www.jetbrains.com/help/phpstorm/creating-local-server-configuration.html), part of _JetBrains'_ documentation suite.  This document is linked in from James' post too.  

## A Summary of Changes

`dg-isle` is my _Digital.Grinnell_ copy of the project repository identifed as `yourprojectnamehere-isle` in the _ISLE_ documentation.  All of my changes were made in that repo, and they are summarized in the following `git status` result:  

```
╭─mark@Marks-Mac-Mini ~/ISLE/dg-isle ‹main*›
╰─$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   docker-compose.local.yml
	modified:   local.env

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	xdebug-local.ini

no changes added to commit (use "git add" and/or "git commit -a")
```

### Contents of Those Files

#### docker-compose.local.yml  

In `docker-compose.local.yml` I added only the last line you see below, in the `volumes:` portion of the `apache:` container config.  

```
apache:
  image: islandoracollabgroup/isle-apache:1.5.4
  ...lines removed for clarity...
  volumes:
    # Customization: Bind mounting Drupal Code instead of using default Docker volumes for local development with an IDE.
    - ~/ISLE/dg-islandora:/var/www/html:cached
    ...lines removed for clarity...
    - ./xdebug-local.ini:/etc/php/7.1/apache2/conf.d/20-xdebug-local.ini
```

**Attention!** While the line I added above does work, it's a bit of a brute force approach and is probably not sustainable.  I've found a much better approach is to inject my debug config like so:

```
apache:
  image: islandoracollabgroup/isle-apache:1.5.4
  ...lines removed for clarity...
  volumes:
    # Customization: Bind mounting Drupal Code instead of using default Docker volumes for local development with an IDE.
    - ~/ISLE/dg-islandora:/var/www/html:cached
    ...lines removed for clarity...
    - ./xdebug-local.ini:/etc/php/7.1/mods-available/xdebug.ini
```

#### local.env and .env

In `local.env` I added a comment followed by three lines of configuration, all near the top of the file, like so:

```
## ISLE Local
## This local.env file is used with / for the docker-compose.local.yml

## Windows user should uncomment the following line:
# COMPOSE_CONVERT_WINDOWS_PATHS=1

## Parameters for XDEBUG and PHPStorm
ENABLE_XDEBUG=true
PHP_MEMORY_LIMIT='128M'
PHP_IDE_CONFIG='serverName=dg_local'
...remaining lines removed for clarity...
```

Note that `dg_local` above is the same as the `COMPOSE_PROJECT_NAME` parameter from my `.env` file.  The contents of `.env` remains unchanged:

```
#### Activated ISLE environment
# To use an environment other than the default Demo, please change values below
# from the default Demo to one of the following: Local, Test, Staging or Production
# For more information, consult https://islandora-collaboration-group.github.io/ISLE/install/install-environments/

COMPOSE_PROJECT_NAME=dg_local
BASE_DOMAIN=dg.localdomain
CONTAINER_SHORT_ID=ld
COMPOSE_FILE=docker-compose.local.yml
```

#### xdebug-local.ini

This is a new file, one not previously found in the _ISLE_ configuration.  James mapped this file into his configuration like so:

```
  - ./xdebug-local.ini:/usr/local/etc/php/conf.d/xdebug-local.ini
```

Don't use that in _ISLE_!  The **correct** config for _ISLE_ is the line I added to `docker-compose.local.yml` which reads:

```
  - ./xdebug-local.ini:/etc/php/7.1/apache2/mods-available/xdebug.ini
```

The `./` prefix in that line dictates that your `xdebug-local.ini` file should be in your project's root directory, the same directory where `docker-compose.local.yml` resides.  In my case that's `~/ISLE/dg-isle`.  

The contents of your `xdebug-local.ini` file, assuming you're using OS X, should be identical to James' copy, and mine:  

```
zend_extension=xdebug
xdebug.remote_enable=1
xdebug.remote_autostart=1
xdebug.remote_port=9001
xdebug.remote_host=host.docker.internal
```

## How I Did It

To be honest, I tried so many things, I am not absolutely certain which parts were necessary, and which were not.  So, let me just explain what I did in each of the steps that James outlined.  

  - **Step One: Installing Xdebug**  
    I did NOT create a new `Dockerfile` or new build of _ISLE_'s Apache container.  All that was required in that regard, I believe, was the inclusion of the `ENABLE_XDEBUG=true` line in `local.env`.  
    
  - **Step Two: Configuring Xdebug**  
    I followed James' guidance explicitly here. Please read his post!  
    
  - **Step Three: Inject Config to Docker**  
    Again, I followed James explicitly, but omitted the `DB_` parameters since I'm only interested in debugging PHP code.  As James suggests, the `serverName` parameter in `PHP_IDE_CONFIG:` is **critical**.  
    
  - **Step Four: Set up PHPStorm**  
    This is where things got a bit confusing, so I'll dispense with my recollection and just show you my end results in a series of screen grabs.  Please DO give James' post a good read though, there's lots of helpful explanation within.
    
#### My Project Structure

Locally, my _ISLE_ configuration and code live in a pair of repositories named `dg-isle` and `dg-islandora` inside an `~/ISLE` directory.  That `~/ISLE` directory now includes a `.idea` hidden folder, and that's where all of my associated _PHPStorm_ project info lives.  It all looks like this:

```
╭─mark@Marks-Mac-Mini ~/ISLE
╰─$ ls -alh
total 16
drwxr-xr-x    6 mark  staff   192B Mar 11 13:08 .
drwxrwxr-x+ 137 mark  staff   4.3K Mar 12 12:18 ..
drwxr-xr-x   13 mark  staff   416B Mar 12 12:14 .idea
drwxr-x---@  36 mark  staff   1.1K Mar 11 14:18 dg-islandora
drwxr-xr-x   42 mark  staff   1.3K Mar 11 12:41 dg-isle
```  

## First Steps in PHPStorm

The first thing I remember doing in _PHPStorm_ was creating my project.  That process is probably best shown in this screen grab:
{{% figure title="Creating My PHPStorm Project Structure" src="/images/post-103/new-phpstorm-project.png" %}}

I used the `New Project` button and `New Project from Existing Files...` pull-down option to get started. Be sure to choose the `Web server is installed locally...` scenario too.

The resulting structure can be seen in this screen grab showing the upper-left corner of my _PHPStorm_ application window.
{{% figure title="My PHPStorm Project Structure" src="/images/post-103/my-project-structure.png" %}}

## Next Steps

This is where things really get foggy, so, more screen grabs showing the results.
    
My `Run/Debug Configurations` look like this:
{{% figure title="PHPStorm Run/Debug Configurations" src="/images/post-103/phpstorm-run-debug-config.png" %}}

My `Preferences > Language & Frameworks > PHP > Servers` configuration looks like this: 
{{% figure title="Preferences" src="/images/post-103/servers-config.png" %}}

Please don't ask me to recall exactly how I created those configurations.  Here's what I do remember...

## Let the Magic Happen

The final pieces of this puzzle just seem to "magically" fall into place once you begin your first debugging session. In my case, after configuring most of what you've seen above, I did this:

  - Opened _PHPStorm_ to the `ISLE` project.
  - Opened `index.php` and set a breakpoint.  I also elected to add a simple print statement like you see below.  
    {{% figure title="My Breakpoint in index.php" src="/images/post-103/set-breakpoint-index.php.png" %}}
  - Toggled the "Start Listening" button (the button with the phone and red circle) in the included image. 
    {{% figure title="Start Listening" src="/images/post-103/start-listening.png" %}}
  - Opened my local _ISLE_ instance, `http://dg.localdomain`, in the browser of my choice, _Firefox_, and clicked `Refresh`.
    The first time I did this with _PHPStorm_ "listening", I was prompted with some "connection" follow-up questions. That happens only once, and the questions are not too difficult to answer.
  - Enjoyed debugging _ISLE_ without a single `var_dump()` or `print_r()` statement!      

## But What About Debugging in Drush?

I have a number of PHP scripts implemented in [drush](https://www.drush.org/latest/) as part of a Drupal module I call [idu](https://github.com/DigitalGrinnell/idu), and I need to be able to debug those too. But the above configuration doesn't work properly with _drush_ commands. So, what's missing?

After considerable searching I found two critical changes were necessary...

### Export the serverName Config

Before making any _drush_-specific configruation changes I was seeing messages like this in _PHPStorm_ when attempting to debug a script:

{{% figure title="Can't Find dg_local Server" src="/images/post-103/No-dg_local.png" %}}

Turns out for _cli_ debugging you have to explicitly "export" the `PHP_IDE_CONFIG` value inside the running container, like so:

```
root@7793f5d333fd:/var/www/html/sites/default# export PHP_IDE_CONFIG="serverName=dg_local"
```

But, hold on, that's still not right!  The `dg_local` server isn't what I want for _cli_ debugging.  For that I have a _PHPStorm_ server named `apache` that was automatically created for me.  So the command I need to run in the container is:

```
root@7793f5d333fd:/var/www/html/sites/default# export PHP_IDE_CONFIG="serverName=apache"
```

### Don't Use Automatic Breakpoints!

In my configuration, _drush_ lives in my _Apache_ container at `./opt/drush-8.x/vendor/drush/drush/drush`, but the source code I mapped to _PHPStorm_ only includes the directories and file that live in and below `/var/www/html`.  So, if you leave automatic breakpoints turned on in _PHPStorm_ and run _drush_, the debugger will stop in a location that you can't "see", making it nearly impossible to step through your code.

The fix for this is to turn OFF the last two _PHPStorm_ preferences checkboxes you see below. Turning those off will ensure that _PHPStorm_ does not stop execution at the first line inside the _Apache_ containers _drush_ command script. 

{{% figure title="Do NOT Set Automatic Breakpoints" src="/images/post-103/No-auto-breakpoints.png" %}}

  
And that's a wrap.  Until next time, happy debugging! 
