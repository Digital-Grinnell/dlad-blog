---
title: Adding a Custom 404 Page in Hugo
publishDate: 2023-02-16T13:07:31-06:00
last_modified_at: 2023-02-17T10:18:58
draft: false
description: "_Rootstalk_ could really use a custom 404 page.  So let's do it."
tags:
  - Hugo
  - Rootstalk
  - custom
  - 404
  - Azure 
  - API
azure:
  dir: https://sddocs.blob.core.windows.net/documentation
  subdir: 
---  

The task _du jour_ is to being, and perhaps complete, the process of adding a custom 404 page to _Rootstalk_.  

Thus far I've found a couple of promising resources to guide the effort:  

  - [Custom 404 Page](https://gohugo.io/templates/404/)
  - [Custom 404 pages in Hugo done right](https://moonbooth.com/hugo/custom-404/)

In particular, I'm focusing on "Option 2" in the "...done right" document, and the "Azure Static Web App" portion of the first document.   

## Need a New Azure API Key?

Early in this journey I found that I could not deploy changes to [https://thankful-flower-0a2308810.1.azurestaticapps.net](https://thankful-flower-0a2308810.1.azurestaticapps.net) from the `develop` branch of the code because of an invalid or missing API key.  I turned to [Reset deployment tokens in Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/deployment-token-management) to try and remedy that.  

Alas, that didn't fix things.  The error in my "Build and Deploy Job" log in GitHub says... 

```
App Directory Location: '/' was found.
Looking for event info
The content server has rejected the request with: BadRequest
Reason: No matching Static Web App was found or the api key was invalid.
```

I'm going to remove the `azurestaticwebapp.config.json` file and try again.  Yes, that worked.  So, maybe I put that file in the wrong place?  Also, I am able to switch into the `main` branch of the _Rootstalk_ code, where there is no `azurestaticwebapp.config.json`, and the deployment workflow is successful there.   Time for some more web research.   

## Duh!

Ok, scratch that last section.  It turns out that the _GitHub Action_ that returned the error was an old one desinged to deploy a branch that no longer exists.  The custom 404 page has been working all along on https://thankful-flower-0a2308810.1.azurestaticapps.net/.  In fact, if you try and open something like https://thankful-flower-0a2308810.1.azurestaticapps.net/bogus, an address that doesn't work, you can see the new custom 404.  

## The Real Problem

So, my aim with this is to return a custom 404 page **when an external link, one outside of _Rootstalk_, does NOT work**.  That is apparently a very different ball of wax, so more research is needed.  

---

I'm sure there will soon be much more here, but for this installment... That's a wrap!  


