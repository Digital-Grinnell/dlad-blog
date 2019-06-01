---
date: 2018-11-29
title: Bypassing Docker Hub Auto-Build
---

One of the really cool things I like about the workflow documented in [Juan Treminio's blog post](https://jtreminio.com/blog/setting-up-a-static-site-with-hugo-and-push-to-deploy/) is the ability to setup auto-build in Docker Hub.  Unfortunately, that comes at a cost.  Docker Hub's 'free' account option will support only one parallel auto-build, so if you have more than one project you'd like to auto-build at Docker Hub you'll need to pay for an account.  The current cost is, I think, $7/month for an account that will handle up to 5 parallel auto-build projects.  That's not horrible, but for now I just have this one project with a few more that are on-the-horizon.  So, in the case of this blog I'm going to bypass auto-build and just document the process I'll use to update and push this blog to production.  I touched on it in [my previous post](https://static.grinnell.edu/blogs/McFateM/post/pushing-to-production/) and pertinent portions of that post are reproduced here...

{{% original %}}
I created a new Docker Hub repository and pushed the image created in Juan's `Manual deployment process steps` to that repository. I started by creating a new Docker Hub repository with the same name as my project, `blogs-McFateM`.  **An important note: Docker Hub will not accept uppercase letters in repository names, so as you can see above, I converted all uppercase to lowercase**. The result of this step, for me, was an empty [https://hub.docker.com/r/mcfatem/blogs-mcfatem/](https://hub.docker.com/r/mcfatem/blogs-mcfatem/).

The remaining steps in my '*emergency-push*' process were all run from my local machine, with a terminal open to my project directory.  The necessary commands were:

```
docker image build -t hugo-test .     # <-- executed from my project directory, builds a new up-to-date image
docker login
docker tag hugo-test mcfatem/blogs-mcfatem:latest
docker push mcfatem/blogs-mcfatem:latest
```
A little explanation of the commands...

- `docker login` - Requests your Docker Hub account credentials so that your terminal session can communicate with Docker Hub.

- `docker tag...` - Essentially renames your local image, the one created previously as `hugo-test`, to match your account and project name.  In my case the account is `mcfatem`, my Docker Hub username, and the project is `blogs-McFateM`.  

- `docker push...` - This command pushes the newly renamed image to your Docker Hub repository, and tags the image as `:latest`.  This last part, the '*latest*' tag, is important because early on we set *Traefik* up on our production server to look for images tagged as '*latest*'.  If you give your image a different tag, it won't work properly.
{{% /original %}}

Assuming all of the above worked properly, I should now have a fresh Docker 'image' of this blog tagged as `:latest` in Docker Hub and waiting to be deployed.  What's still *hella* cool about this whole process is that **Watchtower is still watching** and is NOT dependent upon auto-build.  So, within a few minutes of my `docker push...` command my **live** blog is *automagically* updated!

And that's a wrap.  Until next time...
