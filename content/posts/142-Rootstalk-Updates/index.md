---
title: Rootstalk Updates 
publishDate: 2023-03-17T08:25:09-05:00
last_modified_at: 2023-03-17T09:10:23
draft: false
description: Miscelaneous updates from March 2023.
tags:
  - Rootstalk
  - Azure
  - DigitalOcean
  - Matomo
azure:
  dir: 
  subdir: 
---  

# Concerning DigitalOcean

I took steps yesterday to push an update of _Rootstalk_ to our production "starter" project on _DigitalOcean_ (_DO_), and my intent was to make this the last such deployment on _DO_.  I had been thinking for sometime about moving _Rootstalk_ production to _Azure App Service_ where _Rootstalk_ is currently developed.  However, after moving my "personal" `digital@Grinnell.edu` _Azure_ account to "pay-as-you-go" status, the projected monthly cost of services shot up from less than $1/month (mostly for object storage) to something closer to $10 or $15/month.  

Consequently, since the "starter" edition of _Rootstalk_ on _DO_ costs NOTHING (other elements of the libraries' account with _DO_ make the "starter" free to use), and seems to perform just fine, I've elected to leave _Rootstalk_ production as it is on _DO_ for the forseeable future.  

# Concerning Azure  

Meanwhile, I will be taking steps to move billing for my _Azure_ account from my personal pocketbook to a formal Grinnell College Libraries credit card (as approved by the Library more than a month ago).  In order to minimize the impact of that move, I will eliminate the deployment of the [Rootstalk GitHub project's](https://github.com/Digital-Grinnell/rootstalk) `main` branch in an effort to reduce future _Azure_ fees.  Going forward this will remove the [https://icy-tree-020380010.azurestaticapps.net/](https://icy-tree-020380010.azurestaticapps.net/) deployment of _Rootstalk_. Rest assured that test and evaluation (staging) deployment of the project's `develop` branch will still be available as an _Azure App Service_ at [https://thankful-flower-0a2308810.1.azurestaticapps.net/](https://thankful-flower-0a2308810.1.azurestaticapps.net/).  

The _Azure_ development changes described above are now reflected in the [project's README.md](https://github.com/Digital-Grinnell/rootstalk#readme) file.  

# Matomo On the Scene  

In addition to the aforementioned project deployment and account changes, analytics are now being provided for _Rootstalk_, both production and `develop` instances, via a new [Matomo](https://matomo.org) analytics server with a dashboard at [https://analytics.summittservices.com](https://analytics.summittservices.com).   

---

That's all folks... for now.  


