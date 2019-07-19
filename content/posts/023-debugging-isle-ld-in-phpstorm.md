---
title: Debugging ISLE-ld (Local Development) in PHPStorm
date: 2019-07-12
draft: false
---

# Debugging ISLE on a Mac
This guidance applies to debugging PHP code in a local `ISLE-ld`, that's http://isle.localdomain, instance using [PHPStorm](https://www.jetbrains.com/phpstorm/).

## Modify ISLE's `docker-compose.override.yml`
Before engaging _PHPStorm_ we need to make one change to our `ISLE-ld` configuration by running a `docker cp` command, making a change to our `docker-compose.override.yml` file, and restarting the stack.  Here are the commands and procedure.

| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> mkdir -p persistent/html <br/> docker cp isle-apache-ld:/var/www/html/. ./persistent/html |

The above commands will make a new `./persistent/html` directory on the host, if one does not already exist, and the `docker cp` command will copy the current contents of the _Apache_ container's `/var/www/html` directory to the host.  Next we need to modify `docker-compose.override.yml` to map the `./persistent/html` directory into the container.  

On the host, open `docker-compose.override.yml` in your favorite editor and remove comments from the three lines that read:  

  - &nbsp;&nbsp;apache:
  - &nbsp;&nbsp;&nbsp;&nbsp;volumes:
  - &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./persistent/html:/var/www/html       # necessary for PHPStorm debugging!  

| Important! |
| --- |
| Proper indentation in `docker-compose.override.yml`, like all .yml files, is **CRITICAL**!  There should be 2 spaces (one tab) at the start of the `apache:` line, 4 spaces before `volumes:`, and 6 spaces before `.persistent...`. |  

Having saved the modified `docker-compose.override.yml` file, restart things by doing the following.  

| Workstation Commands |
| --- |
| cd ~/Projects/ISLE <br/> docker-compose down <br/> docker-compose up -d |  

In a minute or two your `http://isle.localdomain` should be back up and running, and ready for debugging in _PHPStorm_.

## PHPStorm Configuration
In the *PHPStorm* menu go to: `Preferences > Languages & Frameworks > PHP > Debug > DBGp Proxy` and set the following settings:

    IDE key: `PHPSTORM`
    Host: `docker.for.mac.localhost`
    Port: `9009`

Next, we need to configure a server. This is how *PHPStorm* will map the file paths in your local system to the ones in your container.

  The following is a ONE TIME procedure.  If you've already done this then all you need to do is select the *PHPStorm* project, one you created and named earlier, from the *PHPStorm* splash screen.

  - From the *PHPStorm* splash screen choose `Create New Project from Existing Files`. Click `Next`.
  - **CRITICAL**...*pay attention to this!* Select `Source files are in a local directory, no Web server is yet configured.`. Click `Next`.
  - A directory map of your host should appear.  Navigate in this map to your **ISLE** project, the folder where your `docker-compose.yml` file exists.  There should also be a `./persistent/html` folder there from steps we took in the previous section.  Choose the `html` folder, click `Project Root`, then click `Finish`.
  - You now have a new "local" project named `html`.
  - Relax a little while your *PHPStorm* project is indexed for the first time.

## Launching a Web Debug Session
Once you're all setup and have your PHPStorm project open...

  - Set breakpoints in your code, toggle `Start listening for PHP connections` on (the green/red telephone icon). When turned on the red parts of the icon turn green.
  - Open the `Run` menu in PHPStorm and look near the bottom of the window for the `Break at first line in PHP scripts` option.  Ensure that it is toggled `ON` so that your debug session will encouter at least one breakpoint.
  - Now open your browser and navigate to your site (mine is `http://isle.localdomain`).
  - In PHPStorm you may see a pop-up window titled `Incoming Connection from XDebug`.  Click `Accept`.
  - If everything is working properly your PHPStorm `Debug` window pane will open and if you click the `Debugger` tab you'll see your `index.php` code and a cursor with the first line of code highlighted, usually: `define('DRUPAL_ROOT', getcwd());`.

## Debugging CLI (aka Drush) Commands
Visit the *PHPStorm* menu `Preferences > Languages & Frameworks > PHP > Servers` and add a server named `Docker` with the following parameters:

  - Host: `docker.for.mac.localhost`
  - Port: `80`
  - Debugger: `Xdebug`
  - Use path mappings: `Checked`
    - File/Directory: `/Users/mark/ISLE-ld/html`
    - Absolute path on server: `/var/www/html`

Open a terminal into the `isle-apache-ld` container and run `export PHP_IDE_CONFIG=serverName=Docker` to complete the configuration.

Set breakpoints in your *Drush* code and run any `drush` command in the same `isle-apache-ld` terminal with debug listening toggled on in *PHPStorm*.

And that's a wrap.  Until next time...
