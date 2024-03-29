# The Grinnell College Digital Library Application Developer's Blog

This project, my Grinnell College [Digital Library Application Developer's blog](/), is no longer a [Docker "Multi-Stage" build](https://docs.docker.com/develop/develop-images/multistage-build/).

## GitHub Pages

I successfully moved this blog to _GitHub Pages_ in October 2021, after creating instances of it on _DigitalOcean_ and _Azure_.  _GH Pages_, specifically https://static.grinnell.edu/dlad-blog/ seems like the right home for it, finally.

## Resources

I've create a _OneTab_ of resources that I used here: https://www.one-tab.com/page/Pm1eXBmxS8KOe7PjCt_DLg.  Enjoy!

<!---  Everything below this point is OBSOLETE!

  , a single-image application developed using [Docksal](https://docksal.io/) and [Hugo](https://gohugo.io/).  Apart from the use of Docksal, the project is patterned after [Juan Treminio's blog](https://jtreminio.com/) and the text of his [original README.md](#original-Juan) file is included below.  The text of the [original Docksal README.md](#original-Docksal) file is also included.
  ,

# Deploying this Blog

This blog is intended to be deployed using my [dockerized-server](https://github.com/McFateM/dockerized-server) approach, and the command stream used to launch [the blog]( /) on Grinnell College's `static.Grinnell.edu` server is:

```
NAME=blogs-mcfatem
HOST=static.grinnell.edu
IMAGE="mcfatem/blogs-mcfatem"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=web \
    --label "traefik.frontend.rule=Host:${HOST};PathPrefixStrip:/blogs/McFateM" \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network web \
    --restart always \
    ${IMAGE}
```

My `docker-bootstrap` [workflow diagram](https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf), exported as a PDF, just happens to use this blog as an example!

# Updating This Blog

The process of adding a post, or any addition/change, to this blog is pretty straightforward...

```
cd ~/Projects/blogs-McFateM
docker image build -t new-img .
docker login
docker tag new-img mcfatem/blogs-mcfatem:latest
docker push mcfatem/blogs-mcfatem:latest
```

Watchtower should *automagically* take care of the rest!

# An Even Easier Update

Not long ago I added the _Atom Shell Commands_ package to my _Atom_ config, added a command named **Push a Static Update**, and pointed that command at the _push_update.sh_ script that is now part of this project.  That _bash_ script, does just a few things, and it reads like this:

```bash
#!/bin/bash
cd ~/Projects/blogs-McFateM
perl -i.bak -lpe 'BEGIN { sub inc { my ($num) = @_; ++$num } } s/(build = )(\d+)/$1 . (inc($2))/eg' config.toml
docker image build -t blog-update .
docker login
docker tag blog-update mcfatem/blogs-mcfatem:latest
docker push mcfatem/blogs-mcfatem:latest
```
The `perl...` line runs a text substitution that opens the project's `config.toml` file, parses it looking for a string that matches `build = ` followed by an integer.  The substitution increments that interger by one and puts the result back into an updated `config.toml` file.  The result is eventually the `Build 14`, or whatever number, that you see in the blog's page header/sidebar.  

The rest of the _push_update.sh_ script is responsible for building a new docker image, logging in to _Docker Hub_, tagging the new image as the `:latest` version of _blogs-mcfatem_, and pushing that new tagged image to my _Docker Hub_ account where _Watchtower_ can do its thing.

# Adding the Theme (and Theme Component) as Submodules

The blog now uses TWO themes, one main and one "theme component" to aid in search.  The component theme is a fork of my own, created to remedy one issue I bumped into with HTML escape codes in returned search results.  Clone these two themes, or pull them in as submodules if you like:
```
git submodule add -f https://github.com/vaga/hugo-theme-m10c.git themes/m10c
git submodule add -f https://github.com/kaushalmodi/hugo-search-fuse-js.git themes/hugo-search-fuse-js

```

# Juan Treminio's Original README.md <a name="original-Juan"></a>

For several years this blog was generated using the PHP static site generator
[Sculpin](https://sculpin.io/). I switched to [Grav](https://getgrav.org/)
before deciding it was not for me. My blog does not contain dynamic data that
requires PHP processing, and static HTML with JS is fine.

One of the issues I had with Grav was its requirement of both a PHP-FPM and
Nginx/Apache service to properly serve content.

After researching available options, I decided to switch to the amazing
[Hugo](https://gohugo.io/).

Hugo has several benefits over other generators:

* completely static output is generated from Markdown/HTML files,
* a single Go binary with no outside dependencies, or a container can be used
    to generate static files,
* tons of themes,
* only requires a webserver for production deployment (Nginx/Apache)

## Our goals

Today I will walk you through the complete process of setting up a static
website that you can deploy new versions with a simple `git push`.

Pushing to your repo will trigger an automated build process that will generate
minified HTML/CSS/JS files, package them in an Nginx image, add a new image to
[Docker Hub](https://hub.docker.com/), deploy a new container on your host and
automatically generate and maintain free SSL certificates using
[Let's Encrypt](https://letsencrypt.org/).

The process outlined here is what I have created and use for this blog,
[jtreminio.com](https://jtreminio.com). Each new build and deployment currently
takes around a few minutes and is completely automated.

The only prerequisite is you have Docker installed on your local machine.
All other dependencies will be in Docker containers.

## Technology and services used

We will configure and run several technologies, including:

* [Hugo](https://gohugo.io/) for static site generator,
* [Ansible](https://www.ansible.com/) for configuring the server,
* [Docker](https://www.docker.com/) for containers,
* [Traefik](https://traefik.io/) for routing traffic to correct container,
    and automatic SSL certificates,
* [Watchtower](https://github.com/v2tec/watchtower) for keeping latest Docker
    image running on your site.
* [Let's Encrypt](https://letsencrypt.org/) for free, automated SSL certificate.

Everything that is used is completely free and open sourced, other than the
host. If you are in need of a host I can recommend
[Digital Ocean](https://www.digitalocean.com/?refcode=475274cc0939) [^1].
The basic $5/month plan will be more than enough. If you have your own host you
would prefer to use, by all means use it!

## Configure server

First we need to install Docker, Traefik and Watchtower on the server.

I have created a
[simple Ansible-based configuration](https://github.com/jtreminio/docker-bootstrap)
that

* installs Docker,
* opens ports `80`, `443` and `8080` on firewall (optional),
* adds Traefik and configures Let's Encrypt support,
* creates a Watchtower container.

The only things you must configure are all handled by creating a `.env` file
and filling out the following:

{{% table %}}
name                | description
                --- | ---
SERVER_IP           | IP address of server
SSH_USER            | SSH username, "root" on Ubuntu
SSH_PRIVATE_KEY     | Path to SSH private key on your machine
LE_EMAIL            | Email to use for Let's Encrypt
{{% /table %}}


### Run Ansible

You can start Ansible by running `./init` in the root of the repo directory.

It will create an Ansible container on your local machine that will connect to
and configure your defined remote servers.

The local Ansible container is removed once it finishes running.

If all goes well you should see something similar to

    PLAY RECAP **********************************************
    remote     : ok=8   changed=8   unreachable=0    failed=0

The important part is `failed=0`.

If you go to your blog's URL you will see an invalid certificate warning.

This is fine! We have not actually created the blog container and Traefik has
not generated an SSL certificate for it yet.


## Setting up Hugo

Next we will get Hugo running on our local machine.

I have created a
[Hugo bootstrap repo](https://github.com/jtreminio/hugoBasicExample) that comes
with some tools already added.

All you need to do is clone two repos:

```bash
git clone https://github.com/jtreminio/hugoBasicExample.git
cd hugoBasicExample
git clone https://github.com/nanxiaobei/hugo-paper.git \
    themes/hugo-paper
```

And you can start the Hugo server:

```bash
./bin/hugo-server
```

Now open http://localhost:1313/ and you will see a fully working Hugo blog.

Feel free to explore Hugo in more detail by visiting
[gohugo.io](https://gohugo.io/).

### Manual deployment process steps

With a single command Hugo takes all your HTML/Markdown content and generates
static files in `/public`.

You can see this process by running

```bash
./bin/hugo-publish
```

You will see your Markdown posts in HTML files, nested within directories that
match your blog structure. Hugo also copies over all CSS/JS/etc files that are
in your root `/static` or the theme's.

You _could_ take all this static content and deploy to production as-is, but
we can run some minify tools to get the file sizes down.

Hugo does no post-processing and everything must be done by third-party tools.
I have added a minify script that you can run with:

```bash
./bin/minify
```

It takes all HTML, CSS and JS files and minifies them down to a much smaller
size.

Finally, you can run an Nginx container to make sure your site looks properly.

This local Nginx container will be exactly the same as what you deploy to
production:

```bash
./bin/nginx
```

All these steps can be run manually, but that is a waste of time. Better to
automate the process!

## Docker multi-stage builds

Our end goal is to automate the 3 steps above and end up with a single, tiny
image we can deploy to our production server (automatically).

Docker recently came out with
[multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/).

It means you can create a single `Dockerfile` with as many sequential stages as
you need to generate a single, final image.

[I have created a Dockerfile](https://github.com/jtreminio/hugoBasicExample/blob/master/Dockerfile)
which takes the 3 steps above and runs through them. If you create the image
on your computer you will end up with a single, tiny container at the end:

```bash
$ docker image build -t hugo-test .
Sending build context to Docker daemon  1.383MB
Step 1/17 : FROM alpine/git
 ---> 1e76d5809b62
Step 2/17 : COPY . /data
 ---> a473877e4ad9
Step 3/17 : WORKDIR /data
 ---> Running in 6e1b6e2796a4
Removing intermediate container 6e1b6e2796a4
 ---> 1fcaafec077f
Step 4/17 : RUN rm -rf themes/*
 ---> Running in 020d0c4f303f
Removing intermediate container 020d0c4f303f
 ---> 00a81909f7a0
Step 5/17 : RUN git clone https://github.com/nanxiaobei/hugo-paper.git themes/hugo-paper
 ---> Running in 4d7c71cd51ac
Cloning into 'themes/hugo-paper'...
Removing intermediate container 4d7c71cd51ac
 ---> 5e67ef78f4b8
Step 6/17 : FROM skyscrapers/hugo:0.46
 ---> 434ff241d9e8
Step 7/17 : COPY --from=0 /data /data
 ---> 3d27347872c5
Step 8/17 : WORKDIR /data
 ---> Running in f0875071a444
Removing intermediate container f0875071a444
 ---> ca8120476886
Step 9/17 : RUN hugo
 ---> Running in e2b6817fe000

                   | EN
+------------------+----+
  Pages            | 12
  Paginator pages  |  0
  Non-page files   |  0
  Static files     |  2
  Processed images |  0
  Aliases          |  0
  Sitemaps         |  1
  Cleaned          |  0

Total in 15 ms
Removing intermediate container e2b6817fe000
 ---> cc2be3328f07
Step 10/17 : FROM mysocialobservations/docker-tdewolff-minify
 ---> 43c3688d88ad
Step 11/17 : COPY --from=1 /data/public /data/public
 ---> 144634f56841
Step 12/17 : WORKDIR /data
 ---> Running in 404cb0f24509
Removing intermediate container 404cb0f24509
 ---> d0a02742aa3c
Step 13/17 : RUN minify --recursive --verbose         --match=\.*.js$
                        --type=js         --output public/         public/
 ---> Running in 38f21d784856
INFO: use mimetype text/javascript
INFO: expanding directory public/ recursively
INFO: minify input file public/js/custom.js
INFO: minify to output directory public/
INFO: ( 68.167µs,   32 B,  49.2%, 954 kB/s) - public/js/custom.js
INFO: 3.055423ms total
Removing intermediate container 38f21d784856
 ---> d0d80a7d1ab1
Step 14/17 : RUN minify --recursive --verbose         --match=\.*.css$
                        --type=css         --output public/         public/
 ---> Running in 81e9840eb053
INFO: use mimetype text/css
INFO: expanding directory public/ recursively
INFO: minify input file public/css/style.css
INFO: minify to output directory public/
INFO: (389.209µs, 6.0 kB, 100.0%,  15 MB/s) - public/css/style.css
INFO: 3.797968ms total
Removing intermediate container 81e9840eb053
 ---> 80108c675341
Step 15/17 : RUN minify --recursive --verbose         --match=\.*.html$
                        --type=html         --output public/         public/
 ---> Running in d0c1c70b3e80
INFO: use mimetype text/html
INFO: expanding directory public/ recursively
INFO: minify 30 input files
INFO: minify to output directory public/
INFO: (283.292µs, 2.2 kB,  99.7%, 7.6 MB/s) - public/404.html
INFO: (192.584µs, 3.4 kB,  99.8%,  18 MB/s) - public/about/index.html
INFO: (286.917µs, 3.7 kB,  99.8%,  13 MB/s) - public/categories/development/index.html
INFO: (     68µs,  275 B, 100.0%, 4.0 MB/s) - public/categories/development/page/1/index.html
INFO: (219.375µs, 3.7 kB,  99.8%,  17 MB/s) - public/categories/golang/index.html
INFO: ( 56.709µs,  260 B, 100.0%, 4.6 MB/s) - public/categories/golang/page/1/index.html
INFO: (253.918µs, 2.7 kB,  99.8%,  11 MB/s) - public/categories/index.html
INFO: ( 56.625µs,  239 B, 100.0%, 4.2 MB/s) - public/categories/page/1/index.html
INFO: (272.709µs, 5.8 kB,  99.9%,  21 MB/s) - public/index.html
INFO: ( 68.126µs,  206 B, 100.0%, 3.0 MB/s) - public/page/1/index.html
INFO: (1.140128ms,  56 kB, 100.0%,  49 MB/s) - public/post/creating-a-new-theme/index.html
INFO: (487.084µs,  15 kB, 100.0%,  30 MB/s) - public/post/goisforlovers/index.html
INFO: (317.792µs, 5.8 kB,  99.9%,  18 MB/s) - public/post/hugoisforlovers/index.html
INFO: (252.542µs, 5.2 kB,  99.9%,  21 MB/s) - public/post/index.html
INFO: (349.251µs,  11 kB,  99.9%,  31 MB/s) - public/post/migrate-from-jekyll/index.html
INFO: (     77µs,  221 B, 100.0%, 2.9 MB/s) - public/post/page/1/index.html
INFO: (317.834µs, 3.8 kB,  99.8%,  12 MB/s) - public/tags/development/index.html
INFO: ( 80.792µs,  257 B, 100.0%, 3.2 MB/s) - public/tags/development/page/1/index.html
INFO: (351.584µs, 3.8 kB,  99.8%,  11 MB/s) - public/tags/go/index.html
INFO: ( 68.083µs,  230 B, 100.0%, 3.4 MB/s) - public/tags/go/page/1/index.html
INFO: (280.542µs, 3.8 kB,  99.8%,  14 MB/s) - public/tags/golang/index.html
INFO: ( 69.042µs,  242 B, 100.0%, 3.5 MB/s) - public/tags/golang/page/1/index.html
INFO: (255.334µs, 3.0 kB,  99.8%,  12 MB/s) - public/tags/hugo/index.html
INFO: ( 68.417µs,  236 B, 100.0%, 3.4 MB/s) - public/tags/hugo/page/1/index.html
INFO: (221.125µs, 3.7 kB,  99.8%,  17 MB/s) - public/tags/index.html
INFO: ( 81.125µs,  221 B, 100.0%, 2.7 MB/s) - public/tags/page/1/index.html
INFO: (198.083µs, 2.9 kB,  99.8%,  15 MB/s) - public/tags/templates/index.html
INFO: (118.167µs,  251 B, 100.0%, 2.1 MB/s) - public/tags/templates/page/1/index.html
INFO: (    242µs, 2.9 kB,  99.8%,  12 MB/s) - public/tags/themes/index.html
INFO: (  67.75µs,  242 B, 100.0%, 3.6 MB/s) - public/tags/themes/page/1/index.html
INFO: 112.866806ms total
Removing intermediate container d0c1c70b3e80
 ---> f31a796feec7
Step 16/17 : FROM nginx:alpine
 ---> 36f3464a2197
Step 17/17 : COPY --from=2 /data/public /usr/share/nginx/html
 ---> 5c0ffab7f6be
Successfully built 5c0ffab7f6be
Successfully tagged hugo-test:latest

```

Inside this single `Dockerfile` are 4 `FROM` sections. What Docker actually
ends up doing is creating 3 intermediary images, and one final image. The final
image contains nothing but what you explicitly `COPY` into it, and the end
result is a tiny image:

```bash
$ docker image ls
REPOSITORY  <... snip ...>  SIZE
<none>      <... snip ...>  262MB
hugo-test   <... snip ...>  18.8MB
<none>      <... snip ...>  106MB
<none>      <... snip ...>  25.1MB
```

This tiny image is what we end up deploying to production. It contains Nginx
and all the static, minified files.

You can test it yourself by running:

```bash
docker container run --rm -it -p 8080:80 hugo-test
```

and going to http://localhost:8080

## Docker Hub Automated Builds

After you have played around a bit with Hugo, commit any changes you have made
and push to a public repo on Github.

In our next steps we will get the Docker Hub to do the exact same process as
above whenever we push a new change to Github.

If you do not yet have an account, create one at
[hub.docker.com](https://hub.docker.com/).

We are now going to grant the Docker Hub to access our Github repos and add
hooks.

This simply means whenever a commit is pushed to the repo, Github will notify
the Docker Hub and it will automatically create a new image for us.

Go to
[Linked Accounts & Services](https://hub.docker.com/account/authorized-services/)
and follow the directions.

Next, go to the
[Automated Builds](https://hub.docker.com/add/automated-build/github/) page
and click
[Create Auto-build Github](https://hub.docker.com/add/automated-build/github/github/orgs/).

From there you can find the repo you created earlier.

{{% notice yellow %}}
There are currently two bugs with the Docker Hub GUI when creating an automated
build.

1. The repository you create for the automated build must not exist on
    Docker Hub. For example, my Hub username is _jtreminio_ and my repo's name
    is _jtreminio.com_
    ([found here](https://hub.docker.com/r/jtreminio/jtreminio.com/)). Using
    [the GUI found here](https://hub.docker.com/add/automated-build/github/github/orgs/)
    the Hub will auto-populate the fields for you, even if you already have a
    repo by that name! Either change the name on this page or delete your
    existing repo. This is on the _Docker Hub_, **not** on _Github_!
2. The URL you end up in, _after_
    [the GUI found here](https://hub.docker.com/add/automated-build/github/github/orgs/),
    may be _incorrect_! For me it generated a URL that ended with
    `/github/form/jtreminio/jtreminio.com/?namespace=github`. This _silently_
    fails when you submit the form. The `?namespace=` part should actually
    contain your Docker Hub username! I had to change my URL to
    `/github/form/jtreminio/jtreminio.com/?namespace=jtreminio`
{{% /notice %}}

After you follow the instructions you will find the Docker Hub repo page now
includes several more options than before, including _Dockerfile_,
_Build Details_, and _Build Settings_.

If you go to _Build Settings_ you can manually start your first build by
clicking _Trigger_ on the right side of the page. This may take a few minutes.

## Starting your blog

Once the first build is finished on the Docker Hub we can create the initial
container for our blog on our server.

SSH into your server and run the following:

```bash
NAME=jtreminio_com
HOST=jtreminio.com
IMAGE="jtreminio/jtreminio.com"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=traefik_webgateway \
    --label traefik.frontend.rule=Host:${HOST} \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network traefik_webgateway \
    --restart always \
    ${IMAGE}
```

Make sure to change `NAME`, `HOST` and `IMAGE` to your own information!

A few things will now happen:

1. The container with your website inside will start,
2. Traefik detects this new container and automatically generates a new, free
    SSL certificate from Let's Encrypt. It will continue monitoring this
    certificate and renew it long before it expires, all without you needing to
    worry about it.
3. Watchtower takes note of this new container, but does nothing right now.

If you go to your website URL you will see your blog up and running with a
brand new SSL certificate!

## Watchtower

So what exactly does Watchtower do? If you run

```bash
docker container logs watchtower
```

you may not see anything very interesting at first. The magic happens when you
make changes to your website, commit and push to Github, and after the Docker
Hub automatically creates a new image of your website.

Watchtower polls the Docker Hub every few minutes to detect if any of the
containers you are currently running have new image versions. Once Docker Hub
finishes creating the new image with the latest changes of your website,
Watchtower will automatically download the image, gracefully shut down your
blog container and immediately restart it with the new image, and your new
changes.

Here is what the logs show when this happens:

```bash
root@docker:/opt# docker container logs -f watchtower
time="2018-08-09T00:28:50Z" level=info msg="First run: 2018-08-09 00:33:50 +0000 UTC"

// ...

time="2018-08-09T00:33:53Z" level=info msg="Found new jtreminio/jtreminio.com:latest image (sha256:5a8c9299091b6892753128792a6d6c90f26dd27ed10c5286b3fc8f0b8799c503)"
time="2018-08-09T00:33:57Z" level=info msg="Stopping /jtreminio_com (ebae9539acfcedf2279115f2c19ebddaf3c34271aa5d048142c6b90d091bf987) with SIGTERM"
time="2018-08-09T00:33:58Z" level=info msg="Creating /jtreminio_com"
```

Watchtower can monitor any number of containers and is the final piece in our
automated puzzle.

## Wrapping up

Today you learned how to utilize free, open source tools to automate your blog
deployment process.

While Docker Hub automated builds may not be suitable for more complex
requirements, it can easily meet what we created today.

No more FTP, nor more pulling from repo directly from your server. Automating
this boring and error-prone process helps lift a small weight off of your
shoulders and lets you focus on what you enjoy doing best: writing about things
you love.

Until next time, this is Señor PHP Developer Juan Treminio wishing you adios!

[^1]: Affiliate link, help support this free blog!

# Original Docksal 'Example Hugo Project' README.md <a name="original-Docksal"></a>

## Initializing

```
fin init
```

Will initialize new site, append a test content and compile the site.

Your new site will be instantly available at `http://static.$VIRTUAL_HOST`

## Development

To develop a Hugo project you need Hugo running in a server mode ([Hugo Quickstart guide](https://gohugo.io/getting-started/quick-start/) for more details).

```
fin develop
```

Starts a Hugo server. The server will be available at `http://$VIRTUAL_HOST`.
Updates as you edit, reload the page to see your changes.

**NOTE:** once started, the Hugo server will run, blocking the console. Kill it with `Ctrl-C`, when you are done.

## Compiling static site

```
fin compile
```

Will re-compile static site into `public` folder. It is available at `http://static.$VIRTUAL_HOST`
