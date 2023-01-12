---
title: "Migrating CATPAW Development to Azure"
publishdate: 2023-01-11
draft: false
tags:
  - migration
  - CATPAW
  - Azure
  - Reclaim Cloud
  - Python
  - Flask
  - VSCode
content_updated:   
---

Portions of this post build on concepts introduced in [Managing Azure](/posts/130-Managing-Azure/).  

## CATPAW - Computer-Aided Thinking, Primarily about Writing

From the CATPAW home screen...

{{% original %}}
In many ways, CATPAW is an online book about writing style--a guide to the choices we make in writing that connect us to our readers.

Rather than setting out rules to follow, CATPAW will help you make informed choices in context. The site accomplishes that goal in three ways:

  -  It explains the choices writers face.
  -  It uses computational tools to help you examine your own writing, letting you see what choices you have already made and what you might want to do differently.
  -  It places these choices in the context of advice from other prominent guides to writing.
{{% /original %}}

### Technical Notes

CATPAW is a [Python Flask](https://flask.palletsprojects.com/en/2.2.x/#) web application that employs a number of Python packages including [nltk: the Natural Language Toolkit](https://www.nltk.org/). 

### Project History

CATPAW was created by [Professor Erik Simpson](https://www.grinnell.edu/user/simpsone) with initial programming assistance from [Alina Guha](https://www.linkedin.com/in/alinaguha) and myself.  Throughout its history, CATPAW development and collaboration has engaged a `git` workflow with code updates posted to GitHub private repositories.  

#### Initial Development and Deployment to Azure

The first CATPAW code repository is/was https://github.com/alinejg/catpaw.  This repo was initially deployed to the web via _Azure_ under a "trial" account owned by Alina.  When the trial subscription ended we took steps to move the deployment from _Azure_ to _Reclaim Cloud_ to avoid accumulating fees on Alina's _Azure_ account.  

The `README.md` file from the aforementioned original project documents early development and the move to _Reclaim Cloud_.  That original `README.md` was exported to a file named `README-original.pdf` that's stored in our current development repo [CATPAW-Azure](#catpaw-azure) below.  The PDF is available for download in this post's [Attachments](#attachments) section for convenience.  

## CATPAW Deployment to Reclaim Cloud

Deployment to _Reclaim Cloud_ provided us with very few options, and all of them incurred fees throughout the development lifecycle.  Fortunately, the fees were not too significant and they were covered with budget and credits secured by the [DLAC](https://www.grinnell.edu/academics/centers-programs/ctla/dlac).   

Our deployment to _Reclaim Cloud_ also encountered two technical challenges:  

1) Due to the nature of _Flask_ and its built-in webserver, we had to maintain two different versions of the code, one for the _local_/_development_ websever, and a second copy for any _remote_/_deployed_ using a [wsgi](https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface) interface.  A pair of `.sh` scripts were created to manually switch between versions.  Specific differences between versions are documented in the aforementioned `README-original.pdf` shown above. 

2) Recently, the addition of new _nltk_ elements and a [pandas.DataFrame](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html) object introduced a configuration where the code would run _locally_, but the modified _wsgi_ version would not successfully deploy to _Reclaim Cloud_.   

## CATPAW-Azure

While addressing technical problem #2, above, we discovered that returning to _Azure_ might provide a more flexible and free, or very low-cost, deployment alternative to _Reclaim Cloud_, and new [_Azure_ VSCode extensions](https://code.visualstudio.com/docs/azure/extensions) could be leveraged to simplify the move.  Furthermore, these _VSCode_ extensions provide nearly seemless integration with [Azure App Service](https://azure.microsoft.com/en-us/products/app-service/), and most importantly, **there is no need to maintain separate _local_ and _wsgi_ versions of code when deploying to _Azure_**.  Yay!

A search of the web for "azure python flask" returned a host of promising articles and I choose to create a new _CATPAW_ project repo, [https://github.com/Digital-Grinnell/catpaw-azure](https://github.com/Digital-Grinnell/catpaw-azure), and to develop it using the guidance found in [Deploying Flask web app on Microsoft Azure.](https://medium.datadriveninvestor.com/deploying-flask-web-app-on-microsoft-azure-89cea17e9114), and later in [Quickstart: Deploy a Python (Django or Flask) web app to Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/quickstart-python).  

The original description of [https://github.com/Digital-Grinnell/catpaw-azure](https://github.com/Digital-Grinnell/catpaw-azure) was:

  A restart of CATPAW work from 2022, this time destined for dev deployment in Azure App Service. 

The `README.md` file from the _development_ branch of [https://github.com/Digital-Grinnell/catpaw-azure](https://github.com/Digital-Grinnell/catpaw-azure) explains some of the repositories' early history and it can be downloaded here as `README-catpaw-azure.pdf`.  

{{% attachments %}}

---

I'm sure there will be more here soon, but for now... that's a wrap.
