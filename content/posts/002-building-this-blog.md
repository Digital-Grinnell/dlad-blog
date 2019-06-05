---
date: 2018-11-19
title: Building this Blog with Hugo, Docker, Docksal, and More
---

In this post I will attempt to chronicle the steps my associates and I took to complete the configuration of `static.grinnell.edu`, and to eventually create this blog following [Juan Treminio's](https://jtreminio.com/) lead.  Small portions of Juan's [blog post](https://jtreminio.com/blog/setting-up-a-static-site-with-hugo-and-push-to-deploy/) are reproduced here, with permission, so that you can follow along in his work.  Those passages appear with a colored background like so:

{{% original %}}
...I will walk you through the complete process of setting up a static
website that you can deploy new versions with a simple `git push`.

Pushing to your repo will trigger an automated build process that will generate
minified HTML/CSS/JS files, package them in an Nginx image, add a new image to
[Docker Hub](https://hub.docker.com/), deploy a new container on your host and
automatically generate and maintain free SSL certificates using
[Let's Encrypt](https://letsencrypt.org/)...

The only prerequisite is you have Docker installed on your local machine.
All other dependencies will be in Docker containers.
{{% /original %}}

## Technologies and Services

We've added one tool, *Docksal*, to Juan's original workflow, so the complete list of technologies and services now includes:

* [Docksal](https://docksal.io/) for creating and managing a quick-and-easy local environment for development and testing,

{{% original %}}
* [Hugo](https://gohugo.io/) for static site generator,
* [Ansible](https://www.ansible.com/) for configuring the server,
* [Docker](https://www.docker.com/) for containers,
* [Traefik](https://traefik.io/) for routing traffic to correct container,
    and automatic SSL certificates,
* [Watchtower](https://github.com/v2tec/watchtower) for keeping latest Docker
    image running on your site.
* [Let's Encrypt](https://letsencrypt.org/) for free, automated SSL certificate.
{{% /original %}}

## Production Server Configuration - A Simple One-Time Process

If you have `root` access to a networked Linux server it can be configured as a production host with a script that Juan has provided.

{{% original %}}
I have created a
[simple Ansible-based configuration](https://github.com/jtreminio/docker-bootstrap)
that

* installs Docker,
* opens ports `80`, `443` and `8080` on firewall (optional),
* adds Traefik and configures Let's Encrypt support,
* creates a Watchtower container.
{{% /original %}}

It's important to note that Juan's `./init` script is installed "locally" on your development host, presumably a desktop or laptop workstation, and it makes changes 'remotely' to your production server.  To install `./init` just follow the instruction provided in his [docker-bootstrap](https://github.com/jtreminio/docker-bootstrap) project.

I had a `sudo`-enabled account, but not `root` access, on my production server so I copied the public SSH key from my laptop to the server's `root` account so that `./init` could do it's thing.  It worked wonderfully.

Juan's blog post explains the individual parts of the process including a sample of the output you should see if things go well.  The process is also idempotent, so you can run it more than once with no ill-effects, and it will only do what's required to get your server configured. A little trial-and-error is all it took for me to get it done, and the errors were never catastrophic nor the trials too stressful.

## Next Up... Docksal

This is the point where I suggest we diverge from Juan's workflow, just for a little while.  Install *Docksal* on your local machine using the instructions provided at https://docksal.io/.  While you are there, visit the ['docs' pages](https://docs.docksal.io) and take a quick tour of the documentation so you get a sense of what *Docksal* is, and how to use it.  Pay particular attention to the section dedicated to ['fin'](https://docs.docksal.io/fin), the command you'll use to do nearly everything.  If you're like me, you won't regret this little side-trip.

Once *Docksal* is installed you will find a new, hidden `.docksal` directory in your 'home' directory; this is where *Docksal* lives on your machine.  

Now open a local terminal and navigate within to any directory of your choice.  I did this expecting to eventually create a group of static web sites destined for Grinnell's `static` server, so in my case:

  ```
  cd ~
  mkdir static-sites
  cd static-sites
  ```

Next, invoke the *Docksal* `fin` command in your terminal.  `fin` with no trailing arguments should produce a 'help' screen that begins something like this:

```
Docksal control cli utility v1.79.4

Usage: fin <command>

Management Commands:
  db <command>             	Manage databases (fin help db)
  project <command>        	Manage project(s) (fin help project)
  ssh-key <command>        	Manage SSH keys (fin help ssh-key)
  system <command>         	Manage Docksal (fin help system)

Commands:
  bash [service]           	Open shell into service's container. Defaults to cli
  logs [service]           	Show service logs (e.g., Apache logs, MySQL logs) and Unison logs (fin help logs)
```

To create your *Hugo* project using *Docksal* enter the command: `fin project create`.  The terminal will prompt you to enter a _**name**_ for your project.  I choose `blogs-McFateM` because this blog is intended to be one among many destined for the `static` server.  Please be sure to remember your project _**name**_ as we will refer to it often.

Next, *Docksal* will present you with a list of zero-configuration project types and it prompts you to select one.  Choose `11. Hugo` by entering the number eleven and hitting return.  Nothing has actually happened because *Docksal* gives you an indication of what's about to happen should you choose to proceed.  Enter `y` to proceed or `n` to abort.

If you cleared *Docksal* to proceed it will spin up a set of containers including:

* a command line interface (CLI) service to respond to `fin` commands,
* an Apache web service,
* a virtual host (v-host) proxy service,
* a DNS service to resolve web addresses, and
* an SSH-agent to help manage permissions and access to your project.  

Note that if the creation of the DNS and/or SSH-agent services needs elevated privileges you may be prompted by the process to enter your local user's password to authorize them.

The creation of your new *Hugo* project also created a new directory with the _**name**_ you specified, and with its own `.docksal` subdirectory.  In my case the `~/static-sites/blogs-McFateM` directory was created along with `~/static-sites/blogs-McFateM/.docksal`.  This new `.docksal` subdirectory includes definitions for some new `fin` commands that are specific to *Hugo*.  

If all is well, the output of your `fin project create` command should end with something like this:

```
Compiling a static site...

                   | EN  
+------------------+----+
  Pages            | 10  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     |  3  
  Processed images |  0  
  Aliases          |  1  
  Sitemaps         |  1  
  Cleaned          |  0  

Total in 301 ms

Done!
  Open http://static.blogs-McFateM.docksal
  To develop a Hugo site with real-time updates use fin develop (see README.md for details)

  Read more about Hugo on https://gohugo.io/getting-started/quick-start/
```

There's other useful information included in the output of `fin project create` so I encourage you to look back at the details.  

`fin` commands always act relative to your current working directory. So if you navigate within your terminal to your new project _**name**_ folder, the equivalent in my case of `cd ~/static-sites/blogs-McFateM`, you can launch *Hugo*-specific 'custom' commands.  Navigate to your new project directory and enter `fin` with no arguments.  Once again you're presented with a 'help' screen, but this time the output ends with a few 'custom' commands.  They include:

```
Custom commands:
  compile                  	Compile a static site from Hugo sources
  develop                  	Start Hugo server for real-time development
  hugo                     	Run Hugo commands <accepts params>
  init                     	Initialize demo Hugo site
```

`fin develop` is the command you will use most.  From your project's directory entering `fin develop` is all it takes to compile your site (*Hugo* generates static content into a `public` subdirectory during this process), serve it via a new local DNS entry, and monitor content or configuration changes you make to your site.  `fin develop` will automatically compile any change you make on-the-fly.

When you run `fin develop` you should see something like this:

```
Marks-MacBook-Air:blogs-McFateM mark$ fin develop
Server will be available at: http://blogs-McFateM.docksal

                   | EN  
+------------------+----+
  Pages            | 22  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     | 20  
  Processed images |  0  
  Aliases          |  6  
  Sitemaps         |  1  
  Cleaned          |  0  

Total in 176 ms
Watching for changes in /var/www/{content,data,layouts,static,themes}
Watching for config changes in /var/www/config.toml
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://blogs-McFateM.docksal/ (bind address 0.0.0.0)
Press Ctrl+C to stop

Change detected, rebuilding site
2018-11-18 20:43:48.312 +0000
Source changed "/var/www/content/post/a-blog-is-born.md": WRITE
Total in 29 ms
```

Note that the site address created by `fin project create` and `fin develop` are different since the former prepends a subdomain of `static` to the project name.  As long as the container is running you can use either address, but I recommend using the later address created by `fin develop` since changes are automatically compiled in that environment, as mentioned below.

While `fin develop` is running (note that you must enter `Ctrl-C` in your terminal to stop it) you can open a tab to the site's address (it appears in your output) in any web browser on your local machine and your site should appear.  If you make a change to the site's content or configuration, and save the change, `fin develop` should automatically compile the change for you.  Having made a change just return to your site's tab in your browser and click 'refresh'; your change should appear.

Using these simple steps you can quickly and easily configure, change, test and repeat!  When you want to suspend your work just return to your terminal, enter `Ctrl-C` if `fin develop` is still running, then enter `fin stop`.  The `fin stop` command will terminate the containers associated with your project, but it won't remove them.

When you want to resume work on your project just open a terminal, navigate back to your project directory, and enter `fin up`.  This will rebuild, if necessary, and restart your containers in short order.  Note that `fin up` will report a local URL that is supposed to open your site; however, that address **may not work** properly.  To get back into development just follow-*up*, pun intended, with a `fin develop` command and visit the address that it reports.  Also, don't forget to refresh your browser after each saved change to your content or configuration.

## Build and Test Locally

*Docksal* is great for development, but in this case we need something closer to 'reality' to do some 'real' testing before pushing to production.  The process that Juan outlines will ultimately build a lightweight Docker 'multi-stage' image that includes Hugo, Nginx, and your Hugo project.  That Docker image is really what we need to test, and it's not hard to do.

I encourage you to look at Juan's [blog post](https://jtreminio.com/blog/setting-up-a-static-site-with-hugo-and-push-to-deploy/) beginning with this section:

{{% original %}}
### Manual deployment process steps

With a single command Hugo takes all your HTML/Markdown content and generates
static files in `/public`...
{{% /original %}}

Make sure you run these commands on your local machine, in a terminal opened to your project directory:

{{% original %}}
docker image build -t hugo-test .  
docker image ls  
docker container run --rm -it -p 8080:80 hugo-test  
{{% /original %}}

These commands should produce an image named/tagged `hugo-test`, and run that image; one that should be **identical** to what you'll eventually push to production.  While the container is running you should be able to visit your project at [http://localhost:8080](http://localhost:8080).

## Troubleshooting - My Experience

If the `docker image build -t hugo-test .` command fails to build an image, as my first attempt did, be sure to look at your `config.toml` file carefully.  Initially, my `config.toml` file didn't contain any `theme` key/value pair, presumably because it came from a 'sample' project that intentionally left the theme definition up to the user.  The `docker image build` command includes a step that will 'minify' many of the project's parts to reduce overall image size.  If you don't define a theme in your `config.toml` file minify won't work.

You may find that setting the right `baseurl` or `baseURL` key/value pair in `config.toml` can be tricky. I find myself changing this value depending on the environment, local or production, that I'm targeting.  As I understand it, the proper form for the `baseurl` value depends on your host, obviously, and your theme. This blog is designed to run from a 'path', that is to say its address consists of a host (*static.grinnell.edu*) with a trailing `/path` like so: `https://static.grinnell.edu/blogs/McFateM`.  I found that specifying just the `/path` with NO leading slash in `baseurl` did the trick, like so:  `baseurl = blogs/McFateM`.  This form seemed to work well across all hosts... my local *Docksal* development instance, the local image created earlier in this section, and in production too.  Your mileage may vary.  If your project loads as simple text, with no theme, or if your front page works but others do not, then your `baseurl` could be to blame.

Finally, if you can't spin up your local Docker image at [http://localhost:8080](http://localhost:8080), and you see Docker errors about port conflicts, then something (Nginx servers are notorious for this) on your local machine is probably already listening to port 8080.  Rather than trying to find and fix the source of the problem, simply change the port mapping in your `docker container run...` command to something like this:  `docker container run --rm -it -p 8081:80 hugo-test`.  If that's successful you should be able to visit your project site at [http://localhost:8081](http://localhost:8081).

## Another Reason to Build/Test Locally

In my next post we'll return largely to [Juan Treminio's post](https://jtreminio.com/blog/setting-up-a-static-site-with-hugo-and-push-to-deploy/) to push this blog to production (Yay!) with the help of [Docker Hub](https://hub.docker.com/) and automated builds.  However, when I tried setting up an automated build I ran into problems, and I'll discuss them in the upcoming post.  Fortunately, I found that I could push to Docker Hub the `hugo-test` image created in this section, and bypass the automated build in order to help work out the issues.  More on that in my next post.
