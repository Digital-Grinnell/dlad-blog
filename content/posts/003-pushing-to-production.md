---
date: 2018-11-20
title: Pushing This Blog to Production
---

[Juan Treminio's blog post](https://jtreminio.com/blog/setting-up-a-static-site-with-hugo-and-push-to-deploy/) does a nice job of covering the steps necessary to engage [Watchtower](https://github.com/v2tec/watchtower), [GitHub](https://github.com/), and an automated build configuration in [Docker Hub](https://hub.docker.com/).  The entire process can be used to push your initial [Hugo](https://gohugo.io/) project to production, watch for changes in your GitHub project repo, compile the changes, build a new Docker image, and automatically push it to production.  Like I said, it's an awesome workflow, and there's no need to repeat much of it here.  However, I will provide some insight into issues we encountered, and the solutions we employed.

Please open [Juan's blog post](https://jtreminio.com/blog/setting-up-a-static-site-with-hugo-and-push-to-deploy/) and focus on the section that begins like so:

{{% original %}}

## Docker Hub Automated Builds

After you have played around a bit with Hugo, commit any changes you have made
and push to a public repo on Github.
{{% /original %}}

Work your way through the `Docker Hub Automated Builds` section, and if you run into problems return here and have a look at the last section of this post.

## Troubleshooting - My Experience

I honestly had lots of problems creating an automated build of this blog...

I was also under a time-crunch to get this blog into production so I found a relatively simple way to do so without engaging automatic builds; I created a new Docker Hub repository and pushed the image created in Juan's `Manual deployment process steps` to that repository. I started by creating a new Docker Hub repository with the same name as my project, `blogs-McFateM`.  **An important note: Docker Hub will not accept uppercase letters in repository names, so as you can see above, I converted all uppercase to lowercase**. The result of this step, for me, was an empty [https://hub.docker.com/r/mcfatem/blogs-mcfatem/](https://hub.docker.com/r/mcfatem/blogs-mcfatem/).

The remaining steps in my '*emergency-push*' process were all run from my local machine, with a terminal open to my project directory.  The necessary commands were:

```
docker login
docker tag hugo-test mcfatem/blogs-mcfatem:latest
docker push mcfatem/blogs-mcfatem:latest
```
A little explanation of the commands...

- `docker login` - Requests your Docker Hub account credentials so that your terminal session can communicate with Docker Hub.

- `docker tag...` - Essentially renames your local image, the one created previously as `hugo-test`, to match your account and project name.  In my case the account is `mcfatem`, my Docker Hub username, and the project is `blogs-McFateM`.  

- `docker push...` - This command pushes the newly renamed image to your Docker Hub repository, and tags the image as `:latest`.  This last part, the '*latest*' tag, is important because early on we set *Traefik* up on our production server to look for images tagged as '*latest*'.  If you give your image a different tag, it won't work properly.

If you've successfully completed the automated build setup, or my '*emergency-push*' process, then the next step is to launch your project in production.

## Launching Your Project

You now have a working Docker image resting comfortably in Docker Hub.  This final step will launch your project as a container on your production host. Juan's section covers this nicely.  It begins like so:

{{% original %}}
## Starting your blog

Once the first build is finished on the Docker Hub we can create the initial
container for our blog on our server.

SSH into your server and run the following:

```
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
{{% /original %}}

For this blog, I saved the applicable commands [in this gist](https://gist.github.com/McFateM/b40b3d03e25a552d95b17f175ce82a59) where there is one notable change, in the `traefik.frontend.rule` label.  Unlike Juan's command set, my label specifies both a `Host` and a `PathPrefixStrip` argument. The `PathPrefixStrip:/blogs/McFateM` tells *Traefik* to listen for a 'complete' address with a path prefix, so `https://static.grinnell.edu/blogs/McFateM`.  The rule sends all such requests to the `blogs-mcfatem` 'backend' container, and strips the path prefix, `/blogs/McFateM`, off before doing so.  

And that's a wrap.  Until next time...
