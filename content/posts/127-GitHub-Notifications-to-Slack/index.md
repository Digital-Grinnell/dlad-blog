---
title: "Pushing GitHub Notifications to Slack"
publishdate: 2022-10-05
draft: false
tags:
  - GitHub
  - Slack
  - notifications
---

Lately I've lamented that all incoming emails to @grinnell.edu addresses pass through a _URLDefense_ / _Proofpoint_ agent that sanitizes all clickable links as a safety/security precaution.  In the case of emails automatically dispatched by _GitHub_ the "butchering" of such messages leaves me with an almost useles notification, one that's so badly bloated that I typically choose to ignore it.  Clearly, that's not how notifications are suppsoed to be handled.

## Example of a Butchered Email

To help make my point I'll share a small portion of a relatively small email notification below.  Yes, I used the term "small" more than once in that last sentence.  Why?  Because this is a tiny example compared to some that I've received lately.

```
From: Digital Grinnell <noreply@github.com>
Date: Wednesday, October 5, 2022 at 10:05 AM
To: Digital <Digital@grinnell.edu>, O'Connor, Michael (Mikey) <oconnorm@grinnell.edu>
Subject: [Digital-Grinnell/rootstalk] dada8b: Added cover.png for spring-2022 issue

  Branch: refs/heads/main
  Home:   https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_Digital-2DGrinnell_rootstalk&d=DwICaQ&c=HUrdOLg_tCr0UMeDjWLBOM9lLDRpsndbROGxEKQRFzk&r=D8E-oGNaPT9srWV6jE8UP5unsmKEmmHEH-tzgmjBvLk&m=PxA-gY8Zp47fU9OAwKk5FS-WDskxWx5Ds811Ur96m2fR1d-9W6-SolFNKVJ3ie7F&s=99LzMdHVnq9emX5VBUv5OtRzZ81iaCQmseS437hauKo&e=  
  Commit: dada8bd78f0e4ed646ea4ba4e07f9557ee666363
      https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_Digital-2DGrinnell_rootstalk_commit_dada8bd78f0e4ed646ea4ba4e07f9557ee666363&d=DwICaQ&c=HUrdOLg_tCr0UMeDjWLBOM9lLDRpsndbROGxEKQRFzk&r=D8E-oGNaPT9srWV6jE8UP5unsmKEmmHEH-tzgmjBvLk&m=PxA-gY8Zp47fU9OAwKk5FS-WDskxWx5Ds811Ur96m2fR1d-9W6-SolFNKVJ3ie7F&s=XOT9lo9k0F7SsJQ3SmQcxpTdJGOWvjzwrQmffHzZp4A&e=  
  Author: Digital-Grinnell <digital@grinnell.edu>
  Date:   2022-10-05 (Wed, 05 Oct 2022)

  Changed paths:
    A content/volume-viii-issue-1/cover.png

  Log Message:
  -----------
  Added cover.png for spring-2022 issue


  Commit: d4d12b4cc67f415b549fd38d294217c232778a5b
      https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_Digital-2DGrinnell_rootstalk_commit_d4d12b4cc67f415b549fd38d294217c232778a5b&d=DwICaQ&c=HUrdOLg_tCr0UMeDjWLBOM9lLDRpsndbROGxEKQRFzk&r=D8E-oGNaPT9srWV6jE8UP5unsmKEmmHEH-tzgmjBvLk&m=PxA-gY8Zp47fU9OAwKk5FS-WDskxWx5Ds811Ur96m2fR1d-9W6-SolFNKVJ3ie7F&s=Uf6BJsdOR914O0kqZcJQ_xz_qBJUpZBpqDFVIbaD6HM&e=  
  Author: Digital Grinnell <digital@grinnell.edu>
  Date:   2022-10-05 (Wed, 05 Oct 2022)

  Changed paths:
    A content/volume-viii-issue-1/cover.png

  Log Message:
  -----------
  Merge pull request #29 from Digital-Grinnell/2022-spring

Added cover.png for spring-2022 issue


Compare: https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_Digital-2DGrinnell_rootstalk_compare_327c81e44589...d4d12b4cc67f&d=DwICaQ&c=HUrdOLg_tCr0UMeDjWLBOM9lLDRpsndbROGxEKQRFzk&r=D8E-oGNaPT9srWV6jE8UP5unsmKEmmHEH-tzgmjBvLk&m=PxA-gY8Zp47fU9OAwKk5FS-WDskxWx5Ds811Ur96m2fR1d-9W6-SolFNKVJ3ie7F&s=7lxwCBl_cGynsG6a2WnM54-jwgLTD7muzEi4hnR6e98&e= 
```

## The Slack Alternative

The same notification as it appears in the `Rootstalk.dev` channel in _Slack_ looks like this:

{{% figure title="Example Notification in Slack" src="/images/post-127/example-github-notification-in-slack.png" %}} 

Now, that's much better; don't you agree?

In the image it's important to note that such notifications always appear in the `Apps` section of the workspace, and inside the `GitHub` app specifically.

## Installing the Integration

The agent that makes this kind of GitHub-to-Slack notification possible is itself a GitHub project called [integrations/slack](https://github.com/integrations/slack).  In that repo's `README.md` file there's a link to [Install the GitHub integration for Slack](https://slack.com/apps/A01BP7R4KNY-github).  I successfully followed that link, the process took about 10 minutes, to install the integration into my Slack's [Rootstalk.dev](https://rootstalk-dev.slack.com) workspace.  Some _Duo_ authentication was necessary but overall the process was simple and straightforward.

## No More Bloated Emails from GitHub

The project's current [Vivero](https://vivero.sites.grinnell.edu/) fellow was able to repeat much the same install process on their workstation in about the same amount of time at our weekly _Rootstalk_ check-in meeting this morning.  Now both of us receive these notifications so I've removed our email addresses from the _GitHub_ repo's `Settings` and `Email notifications` configuration.  Hence, no more bloated notification emails from _GitHub_!
