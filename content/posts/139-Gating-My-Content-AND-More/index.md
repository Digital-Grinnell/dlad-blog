---
title: Gating My Content & More - Parts 1 and 2
publishDate: 2023-02-06T18:19:53-06:00
last_modified_at: 2023-02-09T11:44:38
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
  subdir: Building-Wieting-Guild-Pages
---  

# A Blended Approach

It's a new month, February 2023 that is, and this the first part of follow-up to last month's post in my personal blog, namely [Gating My Content](https://blog.summittdweller.com/posts/2023/01/gating-content/).  Now, rather than trying to "gate" some of the content in the [Wieting Theatre website](https://wieting.tamatoledo.com), I'm going to start a new site, with characteristics listed below, and include only the protected portion of the Wieting's content.  

I call this a "blended" approach because it will, at least initially, leverage and blend guidance and elements from many of the resources I've captured at https://www.one-tab.com/page/iyQVdlpSRICO67Mue7Cb_Q.  

{{% box %}}
This post originally documented the creation of an _11ty_ site based on the [NEAT Starter Template](https://github.com/surjithctly/neat-starter), and some of the illustrations here may include references to it.  However, after the _11ty_ site was created I found a starter tutorial and site template better suited to my needs.  So, I have a [new OneTab page](https://www.one-tab.com/page/iyQVdlpSRICO67Mue7Cb_Q) which includes [A Deep Dive Into Eleventy Static Site Generator](https://www.smashingmagazine.com/2021/03/eleventy-static-site-generator/) with an associated starter/template that I'll be using in place of the [NEAT Starter Template](https://github.com/surjithctly/neat-starter).  
{{% /box %}}

## Features

As you'll see in the [OneTab](https://www.one-tab.com/) page listed above, the new site will feature:  

  1)  An [11ty](https://www.11ty.dev/) site following <strike>this [NEAT Starter Template](https://github.com/surjithctly/neat-starter)</strike> [A Deep Dive Into Eleventy Static Site Generator](https://www.smashingmagazine.com/2021/03/eleventy-static-site-generator/),
  2)  Deployed as an [Azure Static Web App](https://azure.microsoft.com/en-us/products/app-service/static),
  3)  Customization to populate the site with Wieting Theatre Guild information,
  4)  Using [StatiCrypt CLI](https://robinmoisson.github.io/staticrypt/) to protect pages,
  5)  From a [GitHub Action](https://github.com/Jack-alope/staticrypt-github-actions/blob/main/.github/workflows/encrypt.yml), and
  6)  Perhaps some integration with [Netlify CMS in _Azure_](https://github.com/jahlen/hugo-azure-static-webapp) instead of _Netlify.com_.  

# With Better Documentation

As steps are taken, I'll try to capture what I used, and why, along with a detailed history of those steps.  In fact, I'm going to try using [Creating-Better-Documentation](/posts/138-creating-better-documentation/) to record everything I do on this screen from start-to-finish.  Wish me luck.     

{{% box %}}
This post will cover features 1 and 2 from the list above.  Subsequent posts in this blog will address features 3 through 6.

In the figures below, <span style="color:yellow; font-weight:bold">yellow</span> box annotations mark elements that need attention or need to be checked, while <span style="color:red; font-weight:bold;">red</span> box annotations mark elements that need input of some kind.   
{{% /box %}}

## Building a Local 11ty Site

I started the build process using the <strike>[NEAT Starter Template](https://github.com/surjithctly/neat-starter)</strike> [Smol-11ty-Starter](https://github.com/5t3ph/smol-11ty-starter.git) to create a new local `git` project.  See _Figure 1_ below. 

{{% figure title="Create a local clone of the `Smol-11ty-Starter` template" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0017.png" %}} 

In my case, I choose to name my new project `wieting-guild-pages` rather than using the default name.  The full command in my case was: `git clone https://github.com/5t3ph/smol-11ty-starter.git wieting-guild-pages`.  

{{% figure title="Give the local clone an sppropriate name" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0025.png" %}} 

Change directory (`cd`) into the new project directory.  

{{% figure title="Change directory into the new project" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0028.png" %}}  

If I intended to create a _public_ code repository I could have "forked" the [Smol-11ty-Starter](https://github.com/5t3ph/smol-11ty-starter.git) project and cloned my local from that fork, but the [SummittDweller/wieting-guild-pages](https://github.com/SummittDweller/wieting-guild-pages) needed to be _private_ so I used the following process instead.  Why?  Because you can't create a _private_ repo from a fork.  

So, I began by removing the local repo's association with [Smol-11ty-Starter](https://github.com/5t3ph/smol-11ty-starter.git) using `rm -fr .git` as shown in _Figure 4_ below.  

{{% figure title="Remove the local repo's `.git` directory" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0034.png" %}}  

Time to launch _VScode_.  On my Mac that's simply: `code .`.  

{{% figure title="Launch _VSCode_" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0037.png" %}}  

I like to have a terminal, attached to my project workspace, running inside _VSCode_.  So, in _VSCode_ that's `Command - Shift - P` to open the command pallette, then select `Terminal: Create New Terminal (In Active Workspace)` to open a terminal within the _VSCode_ project as you see below in _Figure 6_ and _Figure 7_.  

{{% figure title="Attaching a terminal to my project in _VSCode_" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0137.png" %}}  

{{% figure title="A project terminal in _VSCode_" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0038.png" %}}  

## Creating a New GitHub Project

Next, I returned to my _GitHub_ tab and select the upper-right `+` drop-down to create a `New repository`.  I gave the new repo a `Repository name`, `Description`, chose to make it `Private`, did NOT elect to `Add a README file`, and clicked `Create repository`, as you see in _Figure 7_ below.  

{{% figure title="Creating a new, private _GitHub_ repo" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0081.png" %}}  

The new repo comes with instructions for proceeding with the project.  

{{% figure title="New repo status and instructions" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0084.png" %}}  

From the project's _VSCode_ terminal I executed the commands as instructed by the new _GitHub_ repo window, beginning with `git init`.  

{{% figure title="Initialze the local project with `git init`" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0149.png" %}} 

Then `git add .` instead of `git add README.md` as instructed.  I do this to add ALL of the project files to staging becase we need to commit everything, not just the `README.md` file.  

{{% figure title="`git add .` to stage ALL files for commit" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0152.png" %}}  

Next, I copied and pasted the remaining commands from the instructions into the terminal.  The complete command block includes:  

```
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/SummittDweller/wieting-guild-pages.git
git push -u origin main
```

The terminal should respond with output like you see in _Figure 13_ below.  

{{% figure title="Copy/paste the remaining `git` commands" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0159.png" %}}  

{{% figure title="Output from `git push...`" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0161.png" %}} 

Now it was time to make an initial build and run the starter project as instructed in step 2 of the project's [Quick Start](https://github.com/5t3ph/smol-11ty-starter#quick-start) instructions.  

{{% figure title="Install `npm` dependencies" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0171.png" %}}  

My install detected a number of vulnerabilities, presumably because of the starter project's age, so I followed the advice provided in the `npm install` output and ran a `npm audit fix` command as you see below.  

{{% figure title="Using `npm audit fix` as suggested" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0179.png" %}}  

Next, continuing the starter project's quick start instructions I executed `npm run build` to build our first instance of the _11ty_ project.  Note in the output that the command is building the _11ty_ site in the `public` directory.  This information will be needed later in the process.  

{{% figure title="Build the _11ty_ project" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0188.png" %}}  

Since the `build` was a success I continued with the quick start by running `npm run start` to launch a local instance of the site.  As you see in _Figure 18_, the local site becomes available in our web browser at `http://localhost:8080` and multiple links to visit the site are provided.  

{{% figure title="Launch a local instance of the site using `npm run start`" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0194.png" %}}  

{{% figure title="Follow a provided link to open the site in your browser" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0198.png" %}}  

Our inital local site is now visible in our browser, and it looks good!  I used `CTRL-C` in the _VSCode_ terminal to stop the local site as you see in _Figure 20_ below.  

{{% figure title="Initial local site" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0201.png" %}}  

{{% figure title="`CTRL-C` stops the local `11ty` web server" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0203.png" %}}  

## Creating the Azure Static Web App

Next, I returned to my _Azure_ portal to create a new _Azure Static Web App_ from our new repo.  The process begins by navigating a browser window to the _Azure_ portal and `Azure services`, `Static Web Apps`, and `+ Create` as shown below in _Figure 21_.     

{{% figure title="Initial steps to create an _Azure Static Web App_" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0216.png" %}}  

I gave my web app a name, in this case `wieting-guild-pages`, which matches the name of my _GitHub_ repo.  Matching these names is recommended, but NOT a requirement!  Other parameters of the app are as shown in _Figure 22_ below.   

{{% figure title="Web app name and parameters" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0228.png" %}}  

In the lower half of the `Create Static Web App` screen the required selections for `Organization`, `Repository`, `Branch` and `Build presents` are as shown in _Figure 23_.  Leave the default values for `App location` and `Api location`, and specify an `Output location` of `public`.  You may recall that in _Figure 16_ we saw that `public` is the name of the folder where the `11ty` site is built.  

Click `Review + create` to proceed.   

{{% figure title="Complete static app parameters" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0258.png" %}}  

The _Azure_ window should change to reflect that the new app is being validated and the `Create` button in the lower-left corner becomes available once validation is complete.  Clicking the `Create` button shown in _Figure 24_ starts the creation and deployment process.  

{{% figure title="App validation and creation" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0274.png" %}}  

The _Azure_ portal screen for the new app shows `...Deployment is in progress`.  The deployment could take a minute or two.  

{{% figure title="Deployment is in progress" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0277.png" %}}  

Once the initial deployment is complete the window will change to indicate the progress.  An option to `Pin to dashboard` is displayed and I recommend doing so.  Then click `Go to resource`.  

{{% figure title="Deployment is complete" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0280.png" %}}  

`Go to resource` opens the app's overview page where you should see key information as marked with yellow boxes in _Figure 27_ below.  Use the `URL` link on the right to open the new _Azure_ web app site in your browser.  

{{% figure title="New app overview and link" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0291.png" %}}  

The site should open in your browser but it may not display any content.  Instead you may see a warning page indicating that the site/app is ready, but has no content.  This is because the initial deployment of the app wasn't preceeded by an `npm build` command.  To force a rebuild you should visit the local project in _VSCode_, make a change to some piece of content, and commit/push that change to _GitHub_.  Each time you complete a change sequence like that the `GitHub Action` that was created earlier (see the `Edit workflow` link in _Figure 27_ above) will automatically build and re-deploy the app.  

## Pushing Changes to Rebuild the Site

I began this part of the workflow by returning to my _VSCode_ project terminal where I did a `git pull` command to update the local repo with any remote changes.  This should pull in one critical addition to the project, the `GitHub Action` workflow `.yml` file as you can see in _Figure 28_ below.  

{{% figure title="`git pull` remote changes" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0307.png" %}}  

I choose to open the `index.md` file in the project's `./src` directory -- this is essentially the site's "home" page as markdown content -- where I changed the original title to "Wieting Guild Pages".  

{{% figure title="Changing the `title:` in `/src/index.md`" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0319.png" %}}  

With the change completed I moved into the _VSCode_ terminal for a typical `git add .`, `git commit -m...` and `git push` command sequence as shown in _Figure 30_ below.  

{{% figure title="Add, commit and push the changes" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0333.png" %}}  

I immediately switched back to my _Azure_ app's overview screen where I clicked on the `GitHub Action runs` link under  `Deployment history`.  That opens a window showing the _GitHub_ project's `Actions` tab where a spinning yellow dot in front of the commit name (in this case it was `First push to rebuild`) indicates that the _GitHub Action_ workflow is underway.  

{{% figure title="Using the `GitHub Action runs` link to view progress" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0342.png" %}}  

{{% figure title="GitHub Action workflow in progress" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0345.png" %}}  

When the yellow spinning dot turns to a green checkmark, as you see in _Figure 33_, the _GitHub Action_ is complete and was a success.    

{{% figure title="GitHub Action was successful" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0386.png" %}}  

Now, returning to the app's _Azure_ overview shows a `Browse` button and an address/link to the newly deployed site on the right.  Clicking either of these elements should open the new site.  

{{% figure title="Opening the site from the app's overview screen" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0403.png" %}}  

The edits shown previously in _Figure 30_ should now be visible in the updated site.  Huzzah!  🎉  

{{% figure title="Success!" src="https://sddocs.blob.core.windows.net/documentation/Building-Wieting-Guild-Pages/0404.png" %}}  

---

I hope you find portions of this very detailed post to be useful.  I'm sure there will soon be some follow-up to this, but for this installment... That's a wrap!  


