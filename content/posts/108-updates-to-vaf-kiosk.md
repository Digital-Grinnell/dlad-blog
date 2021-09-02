---
title: "Updates to VAF-Kiosk"
publishDate: 2021-08-26
lastmod: 2021-09-02T14:52:15-05:00
draft: false
tags:
  - VAF
  - kiosk
  - update
  - Google
  - Analytics
---

On Thursday, August 26, 2021, updates to a new iPad destined for the VAF (Visualizing Abolition and Freedom) installing in the Grinnell's HSSC were completed.  As of this writing the iPad has not been re-installed, but Facilities Management has been contacted to schedule that event soon.

## New DigitalOcean Deployment

Due to small differences between the aspect ratio and resolution of the old versus new devices, the kiosk site had to be re-designed.  Changes were also necessary to help ensure that users of the kiosk could not "escape" from the VAF screens and cause havoc by surfing the internet.  As a result, a new *private* [https://github.com/Digital-Grinnell/vafvaf-kiosk](https://github.com/Digital-Grinnell/vaf) repository was created and eventually deployed for kiosk use ONLY via DigitalOcean's _App_ platform.  The new kiosk site is deployed to [https://vaf-kiosk-2021-xjmpc.ondigitalocean.app/](https://vaf-kiosk-2021-xjmpc.ondigitalocean.app/).

Note that the `README.md` document in the new *private* repo is woefully outdated.

## New Analytics

It should also be noted that the new deployment includes an updated _Google Analytics_ v4 tracking code, and that analytics are available, with valid login credentials, at [https://analytics.google.com/analytics/web/?authuser=1#/p284309057/reports/reportinghub](https://analytics.google.com/analytics/web/?authuser=1#/p284309057/reports/reportinghub).  

And that's a wrap. Until next time...
