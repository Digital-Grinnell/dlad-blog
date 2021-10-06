---
title: "Moving Static Sites to Azure"
publishDate: 2021-09-13
lastmod: 2021-09-15T08:11:50-0500
draft: false
tags:
  - static
  - Azure
superseded_by: posts/112-moving-static-sites-to-GitHub-Pages
---

On Thursday, September 9, 2021, I discovered that [Azure](https://azure.microsoft.com/en-us/), Microsoft's offering of host/cloud services for Open Source developers, and a favored partner of Grinnell's IT department, had come up with a _Static Web App_ deployment scheme that allegedly would rival what I've been using at _DigitalOcean_. So, I first tried to migrate my very simple `Static Landing Page` _Hugo_ static site to a new home on _Azure_.  The process wasn't quite as slick and easy as at _DigitalOcean_, but _Azure_ does nicely leverage [GitHub Actions](https://github.com/features/actions), and the process wasn't too difficult to grasp.

As of this writing I'm attempting to follow-up by moving my professional blog, formerly https://static.grinnell.edu/blogs-McFateM/, to a new _Azure_ home.  

{{% annotation %}}
Moving my blog turned out to be just as easy as the landing page.  The entire process took just an hour or so.  Some cleanup of hard-coded links and similar data is still pending, but for the most part the experience has been almost as good as what I did at _DigitalOcean_.
{{% /annotation %}}

## My First Azure Account

Encouraged by the ITS Department, I registered my first _Azure_ account under my `mcfatem@grinnell.edu` email address on March 20, 2020.  That account was registered under the college's existing "home" organization named `Grinnell College`, also identified as `GRINCO.ONMICROSOFT.COM`.  Because my first year of "free" services under that account had long expired, in September 2021 I elected to open a new account as indicated below.

## A New Azure Account and Portal

Nothing of any consequence was ever created under my `mcfatem@grinnell.edu` _Azure_ account, the services I needed were not available back in early 2020.  So, that account still exists but has nothing of value in it at this time.

As mentioned above, on 2021-09-09, I created a new _Azure_ account, also under the `Grinnell College` organization umbrella.  This account is registered to my `digital@grinnell.edu` email address. Unlike my earlier account, this one has a [Portal](https://portal.azure.com/#home) with some actual content.

## Static Landing Page

The sole occupant, so far, of my _Azure_ [Portal](https://portal.azure.com/#home) is named [static-landing-page]( ) and clicking on its link and toggling on the JSON view (a handy feature) shows these details:

```
{
    "id": "/subscriptions/609af5e3-a5d8-4ff9-968f-6524767a4dbe/resourceGroups/Static.Grinnell.edu-Resources/providers/Microsoft.Web/staticSites/static-landing-page",
    "name": "static-landing-page",
    "type": "Microsoft.Web/staticSites",
    "location": "Central US",
    "tags": {},
    "properties": {
        "defaultHostname": "victorious-river-0bf860d10.azurestaticapps.net",
        "repositoryUrl": "https://github.com/Digital-Grinnell/static-landing-page",
        "branch": "main",
        "customDomains": [],
        "privateEndpointConnections": [],
        "stagingEnvironmentPolicy": "Enabled",
        "allowConfigFileUpdates": true,
        "contentDistributionEndpoint": "https://content-dm1.infrastructure.azurestaticapps.net",
        "keyVaultReferenceIdentity": "SystemAssigned",
        "userProvidedFunctionApps": [],
        "provider": "GitHub",
        "enterpriseGradeCdnStatus": "Disabled",
        "publicNetworkAccess": null
    },
    "sku": {
        "name": "Free",
        "tier": "Free"
    }
}
```

As you can see above, this app responds to a canonical URL of [https://victorious-river-0bf860d10.azurestaticapps.net](https://victorious-river-0bf860d10.azurestaticapps.net) and its built from a _GitHub_ repo at [https://github.com/Digital-Grinnell/static-landing-page](https://github.com/Digital-Grinnell/static-landing-page).  That is a private repository.

You may also note that when this JSON structure was dumped the site had NO "customDomains".  Before long I hope that ITS can alias our old `https://static.grinnell.edu` address to point here.

## This Blog on Azure

Next step, posting and hosting this blog in my new _Azure_ account.  As soon as that is done I'll be back here to provide some details...

Done.  So, here are the details, again in JSON format:

```
{
    "id": "/subscriptions/609af5e3-a5d8-4ff9-968f-6524767a4dbe/resourceGroups/Static.Grinnell.edu-Resources/providers/Microsoft.Web/staticSites/dlad-blog",
    "name": "dlad-blog",
    "type": "Microsoft.Web/staticSites",
    "location": "Central US",
    "properties": {
        "defaultHostname": "ashy-hill-086e62810.azurestaticapps.net",
        "repositoryUrl": "https://github.com/Digital-Grinnell/dlad-blog",
        "branch": "main",
        "customDomains": [],
        "privateEndpointConnections": [],
        "stagingEnvironmentPolicy": "Enabled",
        "allowConfigFileUpdates": true,
        "contentDistributionEndpoint": "https://content-dm1.infrastructure.azurestaticapps.net",
        "keyVaultReferenceIdentity": "SystemAssigned",
        "userProvidedFunctionApps": [],
        "provider": "GitHub",
        "enterpriseGradeCdnStatus": "Disabled",
        "publicNetworkAccess": null
    },
    "sku": {
        "name": "Free",
        "tier": "Free"
    }
}
```

Please note the name and location of the _GitHub_ repo this newest edition is built from: [https://github.com/Digital-Grinnell/dlad-blog](https://github.com/Digital-Grinnell/dlad-blog).  This is also a private repository.  The only problem I encountered when I moved my repo to this location was that all my posts inherited new commit dates, and all have the same commit date, so my automatic sorting by commit date (see the `enableGitInfo = true` setting in `config.toml`) went bonkers.  I've since disabled that sort until I can get my repository commit history back to what it was before the move.

### Important Notes!

So, the deployment of my blog took a few iterations that do not all appear here. In my last deployment I found the `key` to making things work the first time, and I captured some screens along the way.

First, in order to create a new `Static Web App` you have to "find" the right form.  Use the search feature to do so, like this:

{{% figure title="Specifying an Azure Static Web App" src="/images/post-109/post-109-azure-static.png" %}}

Then, in the case of a _Hugo_ static site, after you have identified your project repository you need to select _Hugo_ from a list.  Unlike _DigitalOcean_, this is by-no-means "automatic", so be sure you set your `Build Presets` to "Hugo", like so:

{{% figure title="The Key to Hugo" src="/images/post-109/post-109-azure-hugo.png" %}}

The other "App", "API", and "Output" fields can all be left to the defaults as shown above.

## VAF - Public Facing

This is the `public-facing`, aka `not-the-kiosk` version of _Visualizing Abolition and Freedom_ (VAF).  Note that it is built from the `public-facing` branch of [https://github.com/Digital-Grinnell/vaf](https://github.com/Digital-Grinnell/vaf)!

```
{
    "id": "/subscriptions/609af5e3-a5d8-4ff9-968f-6524767a4dbe/resourceGroups/Static.Grinnell.edu-Resources/providers/Microsoft.Web/staticSites/vaf-public-facing",
    "name": "vaf-public-facing",
    "type": "Microsoft.Web/staticSites",
    "location": "Central US",
    "properties": {
        "defaultHostname": "victorious-field-065e3d110.azurestaticapps.net",
        "repositoryUrl": "https://github.com/Digital-Grinnell/vaf",
        "branch": "public-facing",
        "customDomains": [],
        "privateEndpointConnections": [],
        "stagingEnvironmentPolicy": "Enabled",
        "allowConfigFileUpdates": true,
        "contentDistributionEndpoint": "https://content-dm1.infrastructure.azurestaticapps.net",
        "keyVaultReferenceIdentity": "SystemAssigned",
        "userProvidedFunctionApps": [],
        "provider": "GitHub",
        "enterpriseGradeCdnStatus": "Disabled",
        "publicNetworkAccess": null
    },
    "sku": {
        "name": "Free",
        "tier": "Free"
    }
}
```

## VAF - Kiosk Version

This is the `kiosk` version of _Visualizing Abolition and Freedom_ (VAF), not the public-facing internet web site.  Note that it is built from the `main` branch of [https://github.com/Digital-Grinnell/vaf](https://github.com/Digital-Grinnell/vaf)!

```
{
    "id": "/subscriptions/609af5e3-a5d8-4ff9-968f-6524767a4dbe/resourceGroups/Static.Grinnell.edu-Resources/providers/Microsoft.Web/staticSites/vaf-kiosk",
    "name": "vaf-kiosk",
    "type": "Microsoft.Web/staticSites",
    "location": "Central US",
    "properties": {
        "defaultHostname": "green-beach-045641410.azurestaticapps.net",
        "repositoryUrl": "https://github.com/Digital-Grinnell/vaf",
        "branch": "main",
        "customDomains": [],
        "privateEndpointConnections": [],
        "stagingEnvironmentPolicy": "Enabled",
        "allowConfigFileUpdates": true,
        "contentDistributionEndpoint": "https://content-dm1.infrastructure.azurestaticapps.net",
        "keyVaultReferenceIdentity": "SystemAssigned",
        "userProvidedFunctionApps": [],
        "provider": "GitHub",
        "enterpriseGradeCdnStatus": "Disabled",
        "publicNetworkAccess": null
    },
    "sku": {
        "name": "Free",
        "tier": "Free"
    }
}
```

## Rootstalk

Last, but not least, there's _Rootstalk_!  Note that it is built from the `main` branch of a new _GitHub_ repo at [https://github.com/Digital-Grinnell/rootstalk](https://github.com/Digital-Grinnell/rootstalk)!  Note that it should be given a `.grinnell.edu` address of `rootstalk-DEV` for now... I'm not quite ready to make it the public-facing edition of the digital magazine just yet.

```
{
    "id": "/subscriptions/609af5e3-a5d8-4ff9-968f-6524767a4dbe/resourceGroups/Static.Grinnell.edu-Resources/providers/Microsoft.Web/staticSites/rootstalk",
    "name": "rootstalk",
    "type": "Microsoft.Web/staticSites",
    "location": "Central US",
    "properties": {
        "defaultHostname": "icy-tree-020380010.azurestaticapps.net",
        "repositoryUrl": "https://github.com/Digital-Grinnell/rootstalk",
        "branch": "main",
        "customDomains": [],
        "privateEndpointConnections": [],
        "stagingEnvironmentPolicy": "Enabled",
        "allowConfigFileUpdates": true,
        "contentDistributionEndpoint": "https://content-dm1.infrastructure.azurestaticapps.net",
        "keyVaultReferenceIdentity": "SystemAssigned",
        "userProvidedFunctionApps": [],
        "provider": "GitHub",
        "enterpriseGradeCdnStatus": "Disabled",
        "publicNetworkAccess": null
    },
    "sku": {
        "name": "Free",
        "tier": "Free"
    }
}
```

## Summary of Aliases

This table from https://gist.github.com/Digital-Grinnell/707c5c30b2a046e638b1e645a796838d#gistcomment-3893281 might come in handy...

| Site's Azure Address | .grinnell.edu Alias |
| --- | --- |
| https://victorious-field-065e3d110.azurestaticapps.net | vaf.grinnell.edu |
| https://green-beach-045641410.azurestaticapps.net | vaf-kiosk.grinnell.edu |
| https://ashy-hill-086e62810.azurestaticapps.net | dlad-blog.grinnell.edu |
| https://victorious-river-0bf860d10.azurestaticapps.net | static.grinnell.edu |  
| https://icy-tree-020380010.azurestaticapps.net | rootstalk-DEV.grinnell.edu |

That's all... for now.
