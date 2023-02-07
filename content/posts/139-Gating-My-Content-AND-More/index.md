---
title: Gating My Content & More - Parts 1 and 2
publishDate: 2023-02-06T18:19:53-06:00
last_modified_at: 2023-02-07T15:56:40
draft: false
description: My second attempt at gating content in Wieting.TamaToledo.com, sort of.
tags:
  - gating
  - authentication
  - NetlifyCMS
  - Wieting
  - StatiCrypt
  - Eleventy
  - 11ty
  - Azure
  - GitHub
  - oAuth
azure:  
  dir: https://sddocs.blob.core.windows.net/documentation  
  subdir: Creating-Azure-Static-Web-App  
---  

# A Blended Approach

It's a new month, February 2023 that is, and this the first part of follow-up to last month's post in my personal blog, namely [Gating My Content](https://blog.summittdweller.com/posts/2023/01/gating-content/).  Now, rather than trying to "gate" some of the content in the [Wieting Theatre website](https://wieting.tamatoledo.com), I'm going to start a new site, with characteristics listed below, and include only the protected portion of the Wieting's content.  

I call this a "blended" approach because it will, at least initially, leverage and blend guidance and elements from many of the resources I've captured at https://www.one-tab.com/page/uZbS4FxhQeCpAdmpNjnHAw.  

{{% box %}}
This post originally documented the creation of an _11ty_ site based on the [NEAT Starter Template](https://github.com/surjithctly/neat-starter), and most of the illustrations here include references to it.  However, after the _11ty_ site was created I found a starter tutorial and site template better suited to my needs.  So, I have a [new OneTab page](https://www.one-tab.com/page/6DzScWRTSkaO5xr7YGC2Hg) which includes [A Deep Dive Into Eleventy Static Site Generator](https://www.smashingmagazine.com/2021/03/eleventy-static-site-generator/) with an associated starter/template that I'll be using in place of the [NEAT Starter Template](https://github.com/surjithctly/neat-starter).  
{{% /box %}}

## Features

As you'll see in the [OneTab](https://www.one-tab.com/) page listed above, the new site will feature:  

  1)  An [11ty](https://www.11ty.dev/) site following ~this [NEAT Starter Template](https://github.com/surjithctly/neat-starter)~ [A Deep Dive Into Eleventy Static Site Generator](https://www.smashingmagazine.com/2021/03/eleventy-static-site-generator/),
  2)  Deployed as an [Azure Static Web App](https://azure.microsoft.com/en-us/products/app-service/static),
  3)  Using [StatiCrypt CLI](https://robinmoisson.github.io/staticrypt/) to protect pages,
  4)  From a [GitHub Action](https://github.com/Jack-alope/staticrypt-github-actions/blob/main/.github/workflows/encrypt.yml), and
  5)  Perhaps some integration with [Netlify CMS in _Azure_](https://github.com/jahlen/hugo-azure-static-webapp) instead of _Netlify.com_.  

# With Better Documentation

As steps are taken, I'll try to capture what I used, and why, along with a detailed history of those steps.  In fact, I'm going to try using [Creating-Better-Documentation](/posts/138-creating-better-documentation/) to record everything I do on this screen from start-to-finish.  Wish me luck.     

{{% box %}}
This post will cover features 1 and 2 from the list above.  Subsequent posts in this blog will address features 3 through 5.
{{% /box %}}

# Building a Local 11ty Site

I started the build process using the [NEAT Starter Template](https://github.com/surjithctly/neat-starter) to create a new local `git` project.  See _Figure 1_ below. 

{{% figure title="Create a Local Clone of the NEAT Template" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/0580.png" %}}  

In my case, I choose to name my new project `wieting-protected-content` rather than using the default name of `neat-starter`.  The root of the command is: `git clone https://github.com/surjithctly/neat-starter`.  

{{% figure title="Give the Local Clone An Appropriate Name" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/0680.png" %}} 

Change directory (`cd`) into the new project directory.  

{{% figure title="Change Directory Into the New Project" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/0700.png" %}}  

The `NEAT Starter` project still uses the old `master` branch name, change that branch name to `main` like so: `git branch -m master main`.  

{{% figure title="Change the Default Branch from Master to Main" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/0810.png" %}}  

Time to launch _VScode_.  On my Mac that's simply: `code .`.  

{{% figure title="Launch _VSCode_" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/0842.png" %}}  

I like to have a terminal, attached to my project workspace, running inside _VSCode_.  So, in _VSCode_ that's `Command - Shift - P` to open the command pallette, then select `Terminal: Create New Terminal (In Active Workspace)` as you see below.  

{{% figure title="Open a Terminal in _VSCode_" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/0870.png" %}}  

Inside the _VSCode_ terminal execute the project setup instructions included in the [surjithctly/neat-starter](https://github.com/surjithctly/neat-starter) `README.md` file.  Begin with `npm install`.  

{{% figure title="Install Dependencies with `npm`" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1030.png" %}}  

Next, execute `npm run build` as directed.  

{{% figure title="Build the Project" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1100.png" %}}  

Finally, execute `npm run start`.  

{{% figure title="Launch a Local 11ty Instance" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1115.png" %}}  

The `npm run start` command will launch a local webserver to compile and display your site.  The output from the command will display a couple of addresses to the local site, probably `http://localhost:3001` and `http://localhost:8080`.  

{{% figure title="Find the Local Site Address" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1155.png" %}}  

The first of the two addresses points to an instance of `Browsersync` where you can find information about the local webserver, including the actual address of the local `NEAT Starter`.   

{{% figure title="Visit the Local Site Using Browsersync" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1258.png" %}}  

{{% figure title="Open the NEAT Starter Site" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1280.png" %}}  

Examine the local `NEAT Starter` site, shown in _Figure 12_ above, to verify that it's working, and to get familiar with its components.  

# Save the Project in a New GitHub Repo

Having tested/verified the local site, it's now time to save your local work in a remote repository.  I choose _GitHub_ and my _SummittDweller_ account to store my project, and followed the instructions for a "new" project -- under the `+` drop-down and `New repository` selection) -- at [https://github.com/SummittDweller](https://github.com/SummittDweller).  

At [https://github.com/new][https://github.com/new] I entered the annotated parameters you see in _Figure 13_ below, before clicking the `Create repository` button.     

{{% figure title="Create a New Repo and Configure It" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1730.png" %}} 

After the new _GitHub_ repo is created I returned to the terminal in _VSCode_ and deleted the local `.git` directory there using: `rm -fr .git`.  This step disengages my local project from the old remote it was cloned from.  

{{% figure title="Remove the Local Repo's `.git` Directory" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1810.png" %}}  

Now, following the instructions that _GitHub_ provides after creation of a new repository, I reinitialized my local project using `git init`.  

{{% figure title="Reinitialize the Local Repo" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1837.png" %}}  

Since my local project already has a `README.md` file, and much more, I chose to stage ALL of the files within to be committed:  `git add .`.  This command takes the place of the `git add README.md` command that's suggested in the instructions from _GitHub_.    

{{% figure title="Stage All Files to be Committed" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1882.png" %}} 

Now, following the remaining instructions from _GitHub_ we will `git commit -m "first commit"` to commit everthing that is staged.  Then...  

{{% figure title="Commit the Repo" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1885.png" %}}  

...we set the remote branch name to `main`, add the _GitHub_ remote `origin` to the project, and `push` the commit, like so:

```
git branch -M main
git remote add origin https://github.com/SummittDweller/wieting-protected-content
git push -u origin main
```

{{% figure title="Set a New GitHub Remote and Push" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/1935.png" %}}  

# Engaging as an Azure Static Web App

Now it's finally time to create a new _Azure Static Web App_ from our project.  I followed the guidance provided in [Deploying an 11ty Site to Azure Static Web Apps](https://squalr.us/2021/05/deploying-an-11ty-site-to-azure-static-web-apps/) to do just that.  Thank you [squalrus](https://squalr.us/) for the excellent instruction!  

{{% figure title="Deploying an 11ty Site to Azure Static Web Apps" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2028.png" %}}  

I opened my _Azure_ portal at https://portal.azure.com/#home and selected the controls you see in _Figure 20_ to create a new _Static Web App_.  

{{% figure title="Creating a New Azure Static Web App" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2180.png" %}}  

I choose to create a new "Free" app in my account and an existing _Resource group_ housed in the _Central US_ region.   

{{% figure title="My Selections for the New App" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2250.png" %}}  

In the next three figures I instructed _Azure_ to deploy my new app from the _GitHub_ repo we created in the previous section of this document.  

{{% figure title="Deploying from My New GitHub Repo" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2350.png" %}}  

{{% figure title="Deploying the `main` Branch" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2376.png" %}}  

{{% figure title="Critical Selections as Directed By `squalrus`" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2594.png" %}}  

Clicking `Create` as shown below in _Figure 25_ produces a new status screen.  Check that the new app is being created, and deployed, using the correct parameters as seen in _Figure 26_ below.  

{{% figure title="Check the Deployment Parameters" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2762.png" %}}  

{{% figure title="Validating and Deploying the App" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2770.png" %}}  

As the deployment proceeds you should see the `Deployment is in progress` screen as shown in _Figure 27_ below.  Buttons are provided on the right to `Go to resource` and `Pin to dashboard`.  I recommend you at least pin the app to your _Azure_ dashboard now.  

{{% figure title="Deployment is in progress" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2788.png" %}}  

Once the deployment is complete you have additional opportunities to open the resource or pin the app to a dashboard.   

{{% figure title="Your deployment is complete" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2800.png" %}}  

Opening the resource takes you to an app status screen like the one in _Figure 29_ below.  Click the `Browse` button to open the live app.  

{{% figure title="App (resource) status" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2880.png" %}}  

The live app will appear in your browser with the canonical address of the new app shown as you see in _Figure 30_ below.  Note that in my case the app is "deployed" but still waiting on content, so the "NEAT Starter" site does not appear.  In order to force a new deployment, with "NEAT" content, I needed to push content changes to _GitHub_.   

{{% figure title="Your Azure Static Web App is live..." src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/2900.png" %}}  

Time to make some content changes and push them to _GitHub_ to trigger a new build.  

# Push Changes to Trigger a New _Azure_ Build

**Important!**  Before we work in our local project repo we need to `git pull` any/all changes.  So, returing to _VSCode_ and our project terminal do `git pull`.  Notice that we pulled in at least one change.  The file named in _Figure 31_ below is part of the project's `.github/workflows` directory; it's the _GitHub Action_ YAML file that _Azure_ created to control our build and deployment!   

**This _GitHub Action_ is what makes this process work!  Don't leave home without it!**  

{{% figure title="Important: `git pull` to grab our GitHub Action!" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/3045.png" %}}  

After the `git pull` let's find a bit of content to change for testing purposes.  In my case I choose to change the `author:` name and `date:` in the front matter of one post.   

{{% figure title="Changing Some Front Matter" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/3410.png" %}}  

With the changes saved we need to `git add`, `git commit...`, then `git push` our changes up to the _GitHub_ remote.  The `push` will trigger a new remote build of our app.  

{{% figure title="`git add`, `git commit...` and `git push`" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/3515.png" %}}  

To check on the build revist the _GitHub_ project and the `/actions` page.  In my case that's [https://github.com/SummittDweller/wieting-protected-content/actions](https://github.com/SummittDweller/wieting-protected-content/actions).  There you should see at least one "workflow run" with a spinning yellow "dot" on the left.  After some minutes the dot should stop spinning and turn green with a checkmark inside, that signals that your build is complete.  If the dot turns red then the build failed and you're provided with links to log files that can help you identify the problem.    

{{% figure title="Watch GitHub in action" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/3540.png" %}}  

If the aforementioned build was successfull, you can return to your _Azure_ portal, find the new app pinned there, click on it and use the `Browse` button you see in _Figure 35_ to open the deployed app in your web browser.  

{{% figure title="Browse to open the new app" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/3790.png" %}}  

I wanted to verify that my changes were indeed included in my app, so I navigated to the `Blog` link where the post at the top of the page reflects my `author:` and `date:` changes.  🎉  

{{% figure title="Success!" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App/3825.png" %}}  

---

I hope you find portions of this very detailed post to be useful.  I'm sure there will soon be some follow-up to this, but for this installment... That's a wrap!  
