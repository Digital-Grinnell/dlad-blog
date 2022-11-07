---
title: "Sync Rootstalk Production (DigitalOcean) with Dev"
publishdate: 2021-12-22
draft: false
tags:
  - Rootstalk
  - sync
  - production
  - DigitalOcean
superseded_by: posts/132-Another-Sync-Rootstalk-Production-(DO)-with-Dev
---

My goal for this morning, December 22, 2021, was to find a process I could reliably use to synchronize changes in the development copy of _Rootstalk_ (the `main` branch https://github.com/Digital-Grinnell/rootstalk) with our production deployment (the `main` branch of https://github.com/Digital-Grinnell/rootstalk-DO) to _DigitalOcean_.  I used guidance found in [How To Merge Between Two Local Repositories](https://stackoverflow.com/questions/21360077/how-to-merge-between-two-local-repositories) to accomplish this with mixed results.

Note: Our `staging` site cast from the `main` branch of https://github.com/Digital-Grinnell/rootstalk, an _Azure_ static app, can be accessed via https://icy-tree-020380010.azurestaticapps.net.  

## The Workflow

I've captured the inputs and output of the workflow below.  The process basically involved adding a new local remote named `dev` to my existing `rootstalk-DO` local repository, and doing a `git fetch` of that new remote.  Everything in the `code block` that follows is as-it-was-executed on my _Grinnell College_ MacBook...  

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ cd ../rootstalk
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main›
╰─$ git pull
Already up to date.
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main›
╰─$ cd ../rootstalk-DO
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git remote add dev ../rootstalk
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git fetch dev
remote: Enumerating objects: 664, done.
remote: Counting objects: 100% (664/664), done.
remote: Compressing objects: 100% (616/616), done.
remote: Total 624 (delta 471), reused 1 (delta 0), pack-reused 0
Receiving objects: 100% (624/624), 23.39 MiB | 30.87 MiB/s, done.
Resolving deltas: 100% (471/471), completed with 30 local objects.
From ../rootstalk
 * [new branch]      gokcebel      -> dev/gokcebel
 * [new branch]      main          -> dev/main
 * [new branch]      mcfate        -> dev/mcfate
 * [new branch]      sep-23-mcfate -> dev/sep-23-mcfate
 * [new branch]      v4i2          -> dev/v4i2
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git merge dev/main
Removing content/past-issues/volume-vii-issue-1/rootstalk_leaf.svg:Zone.Identifier
Removing content/past-issues/volume-vi-issue-1/rootstalk_leaf.svg:Zone.Identifier
Removing content/images/rootstalk_leaf.svg:Zone.Identifier
Removing assets/sass/_custom.scss:Zone.Identifier
Removing Workflow Text.pdf:Zone.Identifier
Removing Workflow Diagrams.zip:Zone.Identifier
Merge made by the 'recursive' strategy.
 .github/workflows/azure-static-web-apps-delightful-stone-01bd98310.yml                      |   45 +
 .github/workflows/azure-static-web-apps-icy-tree-020380010.yml                              |   45 +
 .hugo_build.lock                                                                            |    0
 Git-Workflow-in-Windows.md                                                                  |  119 +++
 Meeting Notes.docx => Meeting-Notes.docx                                                    |  Bin
 Workflow Diagrams.zip:Zone.Identifier                                                       |    4 -
 Workflow Text.pdf:Zone.Identifier                                                           |    4 -
 Workflow-Diagrams/1.png                                                                     |  Bin 0 -> 247700 bytes
 Workflow-Diagrams/10.png                                                                    |  Bin 0 -> 1892560 bytes
 Workflow-Diagrams/11.png                                                                    |  Bin 0 -> 970248 bytes
 Workflow-Diagrams/2.png                                                                     |  Bin 0 -> 1313699 bytes
 Workflow-Diagrams/3.png                                                                     |  Bin 0 -> 1060465 bytes
 Workflow-Diagrams/4.png                                                                     |  Bin 0 -> 1020743 bytes
 Workflow-Diagrams/5.png                                                                     |  Bin 0 -> 1419989 bytes
 Workflow-Diagrams/6.png                                                                     |  Bin 0 -> 1372473 bytes
 Workflow-Diagrams/7.png                                                                     |  Bin 0 -> 1251133 bytes
 Workflow-Diagrams/8.png                                                                     |  Bin 0 -> 1438089 bytes
 Workflow-Diagrams/9.png                                                                     |  Bin 0 -> 1233239 bytes
 Workflow Text.pdf => Workflow-Text.pdf                                                      |  Bin
 alina-git-workflow.md                                                                       |   10 +-
 assets/sass/_custom.scss                                                                    |    6 +
 assets/sass/_custom.scss:Zone.Identifier                                                    |    3 -
 complex-pdf-to-markdown.py                                                                  |  273 ++++++
 config.toml                                                                                 |    4 +-
 content/images/rootstalk_leaf.svg:Zone.Identifier                                           |    3 -
 content/past-issues/volume-iv-issue-1/.not-ready/mutel.md                                   |   31 +
 content/past-issues/volume-iv-issue-1/.pending-new/bernal-pending.md                        | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/birds-pending.md                         | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/burt-pending.md                          | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/chirdon-pending.md                       | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/clark-pending.md                         | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/dunham-pending.md                        | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/evans-pending.md                         | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/freeberg-pending.md                      | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/jackson-pending.md                       | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/kugel-pending.md                         | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/lewis-beck-pending.md                    | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/luftig-pending.md                        |  738 +++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/moffett-pending.md                       | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/munoz-pending.md                         | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/mutel-pending.md                         | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending-new/publisher-pending.md                     |   25 +
 content/past-issues/volume-iv-issue-1/.pending-new/rideout-pending.md                       | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/birds.md                                     | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/burt-pending.md                              | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/chirdon-pending.md                           |  103 +++
 content/past-issues/volume-iv-issue-1/.pending/chirdon.md                                   |  103 +++
 content/past-issues/volume-iv-issue-1/.pending/clark.md                                     | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/dunham-pending.md                            | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/evans-pending.md                             | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/freeburg.md                                  | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/jackson-pending.md                           | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/kugel-pending.md                             |   28 +
 content/past-issues/volume-iv-issue-1/.pending/lewis-beck.md                                | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/luftig.md                                    | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/moffett.md                                   | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/munoz.md                                     | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/mutel.md                                     | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/publisher.md                                 | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/rideout.md                                   | 2185 ++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/2017-fall.yml                                         |   22 +
 content/past-issues/volume-iv-issue-1/_index.md                                             |    6 +-
 content/past-issues/volume-iv-issue-1/bernal.md                                             |   67 ++
 content/past-issues/volume-iv-issue-1/birds.md                                              |   70 ++
 content/past-issues/volume-iv-issue-1/burt-volume-iv-issue-1.md                             |   38 +
 content/past-issues/volume-iv-issue-1/chirdon.md                                            |  103 +++
 content/past-issues/volume-iv-issue-1/clark.md                                              |   73 ++
 content/past-issues/volume-iv-issue-1/dunham.md                                             | 1333 +++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/editor.md                                             |   33 +
 content/past-issues/volume-iv-issue-1/evans-volume-iv-issue-1.md                            |  122 +++
 Workflow Diagrams.zip => content/past-issues/volume-iv-issue-1/evans-volume-iv-issue-1.pdf  |  Bin 13221882 -> 11043734 bytes
 content/past-issues/volume-iv-issue-1/freeberg.md                                           |   93 ++
 content/past-issues/volume-iv-issue-1/jackson.md                                            |  105 +++
 content/past-issues/volume-iv-issue-1/kugel.md                                              |   19 +
 content/past-issues/volume-iv-issue-1/lewis-beck.md                                         |  132 +++
 content/past-issues/volume-iv-issue-1/luftig.md                                             |  738 +++++++++++++++
 content/past-issues/volume-iv-issue-1/moffett.md                                            |  109 +++
 content/past-issues/volume-iv-issue-1/munoz.md                                              |   26 +
 content/past-issues/volume-iv-issue-1/mutel.md                                              |   32 +
 content/past-issues/volume-iv-issue-1/publisher.md                                          |   25 +
 content/past-issues/volume-iv-issue-1/rideout.md                                            |   69 ++
 content/past-issues/volume-iv-issue-2/_index.md                                             |    2 +-
 content/past-issues/volume-iv-issue-2/birds-of-the-prairie-vol-iv-issue-2.md                |   21 +-
 content/past-issues/volume-iv-issue-2/closeup-keith-kozloff.md                              |   23 +-
 content/past-issues/volume-iv-issue-2/closeup-kristine-heykants.md                          |   19 +-
 content/past-issues/volume-iv-issue-2/editors-note-VolIV_Issue2.md                          |    5 +-
 content/past-issues/volume-iv-issue-2/finding-the-lost-duck.md                              |   13 +-
 content/past-issues/volume-iv-issue-2/from-my-table-to-yours.md                             |   13 +-
 content/past-issues/volume-iv-issue-2/gnosis.md                                             |    7 +-
 content/past-issues/volume-iv-issue-2/growing-up-in-kansas.md                               |   31 +-
 content/past-issues/volume-iv-issue-2/johansson-his-ambassador.md                           |  860 +++++++++++++++++
 .../past-issues/volume-iv-issue-2/{his-ambassador.md => johansson-his-ambassador.md.save}   |   11 +-
 content/past-issues/volume-iv-issue-2/lac-la-biche-mission.md                               |   13 +-
 content/past-issues/volume-iv-issue-2/making-room.md                                        |    9 +-
 .../past-issues/volume-iv-issue-2/{peaches-meet-corn.md => manoylov-peaches-meet-corn.md}   |   51 +-
 content/past-issues/volume-iv-issue-2/two-poems-bill-graeser.md                             |    8 +-
 content/past-issues/volume-vi-issue-1/rootstalk_leaf.svg:Zone.Identifier                    |    3 -
 content/past-issues/volume-vii-issue-1/rootstalk_leaf.svg:Zone.Identifier                   |    3 -
 layouts/_default/list.html                                                                  |   22 +-
 layouts/_default/single.html                                                                |   60 +-
 layouts/index.html                                                                          |   26 +-
 layouts/shortcodes/audio_azure.html                                                         |    7 +
 layouts/shortcodes/figure_azure.html                                                        |   44 +
 layouts/shortcodes/video_azure.html                                                         |   38 +
 pdf-to-markdown.py                                                                          |   58 ++
 resources/_gen/assets/scss/sass/styles.scss_5bac553973685aab030dcdbdaeaab6f8.content        |    2 +-
 resources/_gen/assets/scss/sass/styles.scss_5bac553973685aab030dcdbdaeaab6f8.json           |    2 +-
 107 files changed, 69337 insertions(+), 138 deletions(-)
 create mode 100644 .github/workflows/azure-static-web-apps-delightful-stone-01bd98310.yml
 create mode 100644 .github/workflows/azure-static-web-apps-icy-tree-020380010.yml
 create mode 100644 .hugo_build.lock
 create mode 100644 Git-Workflow-in-Windows.md
 rename Meeting Notes.docx => Meeting-Notes.docx (100%)
 delete mode 100644 Workflow Diagrams.zip:Zone.Identifier
 delete mode 100644 Workflow Text.pdf:Zone.Identifier
 create mode 100644 Workflow-Diagrams/1.png
 create mode 100644 Workflow-Diagrams/10.png
 create mode 100644 Workflow-Diagrams/11.png
 create mode 100644 Workflow-Diagrams/2.png
 create mode 100644 Workflow-Diagrams/3.png
 create mode 100644 Workflow-Diagrams/4.png
 create mode 100644 Workflow-Diagrams/5.png
 create mode 100644 Workflow-Diagrams/6.png
 create mode 100644 Workflow-Diagrams/7.png
 create mode 100644 Workflow-Diagrams/8.png
 create mode 100644 Workflow-Diagrams/9.png
 rename Workflow Text.pdf => Workflow-Text.pdf (100%)
 delete mode 100644 assets/sass/_custom.scss:Zone.Identifier
 create mode 100644 complex-pdf-to-markdown.py
 delete mode 100644 content/images/rootstalk_leaf.svg:Zone.Identifier
 create mode 100644 content/past-issues/volume-iv-issue-1/.not-ready/mutel.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/bernal-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/birds-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/burt-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/chirdon-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/clark-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/dunham-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/evans-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/freeberg-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/jackson-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/kugel-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/lewis-beck-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/luftig-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/moffett-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/munoz-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/mutel-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/publisher-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending-new/rideout-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/birds.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/burt-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/chirdon-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/chirdon.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/clark.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/dunham-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/evans-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/freeburg.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/jackson-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/kugel-pending.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/lewis-beck.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/luftig.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/moffett.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/munoz.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/mutel.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/publisher.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/rideout.md
 create mode 100755 content/past-issues/volume-iv-issue-1/2017-fall.yml
 create mode 100644 content/past-issues/volume-iv-issue-1/bernal.md
 create mode 100644 content/past-issues/volume-iv-issue-1/birds.md
 create mode 100644 content/past-issues/volume-iv-issue-1/burt-volume-iv-issue-1.md
 create mode 100644 content/past-issues/volume-iv-issue-1/chirdon.md
 create mode 100644 content/past-issues/volume-iv-issue-1/clark.md
 create mode 100644 content/past-issues/volume-iv-issue-1/dunham.md
 create mode 100644 content/past-issues/volume-iv-issue-1/editor.md
 create mode 100644 content/past-issues/volume-iv-issue-1/evans-volume-iv-issue-1.md
 rename Workflow Diagrams.zip => content/past-issues/volume-iv-issue-1/evans-volume-iv-issue-1.pdf (53%)
 mode change 100644 => 100755
 create mode 100644 content/past-issues/volume-iv-issue-1/freeberg.md
 create mode 100644 content/past-issues/volume-iv-issue-1/jackson.md
 create mode 100644 content/past-issues/volume-iv-issue-1/kugel.md
 create mode 100644 content/past-issues/volume-iv-issue-1/lewis-beck.md
 create mode 100644 content/past-issues/volume-iv-issue-1/luftig.md
 create mode 100644 content/past-issues/volume-iv-issue-1/moffett.md
 create mode 100644 content/past-issues/volume-iv-issue-1/munoz.md
 create mode 100644 content/past-issues/volume-iv-issue-1/mutel.md
 create mode 100644 content/past-issues/volume-iv-issue-1/publisher.md
 create mode 100644 content/past-issues/volume-iv-issue-1/rideout.md
 create mode 100644 content/past-issues/volume-iv-issue-2/johansson-his-ambassador.md
 rename content/past-issues/volume-iv-issue-2/{his-ambassador.md => johansson-his-ambassador.md.save} (99%)
 rename content/past-issues/volume-iv-issue-2/{peaches-meet-corn.md => manoylov-peaches-meet-corn.md} (76%)
 delete mode 100644 content/past-issues/volume-vi-issue-1/rootstalk_leaf.svg:Zone.Identifier
 delete mode 100644 content/past-issues/volume-vii-issue-1/rootstalk_leaf.svg:Zone.Identifier
 create mode 100644 layouts/shortcodes/audio_azure.html
 create mode 100644 layouts/shortcodes/figure_azure.html
 create mode 100644 layouts/shortcodes/video_azure.html
 create mode 100644 pdf-to-markdown.py
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git status
On branch main
Your branch is ahead of 'origin/main' by 87 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ hugo server
Start building sites …
hugo v0.87.0+extended darwin/arm64 BuildDate=unknown
WARN 2021/12/22 11:43:28 Page.Hugo is deprecated and will be removed in a future release. Use the global hugo function.
.File.UniqueID on zero object. Wrap it in if or with: {{ with .File }}{{ .UniqueID }}{{ end }}

                   | EN
-------------------+------
  Pages            | 256
  Paginator pages  |  10
  Non-page files   | 171
  Static files     |  27
  Processed images |   0
  Aliases          |  62
  Sitemaps         |   1
  Cleaned          |   0

Built in 605 ms
Watching for changes in /Users/mcfatem/GitHub/rootstalk-DO/{archetypes,assets,content,layouts,static,themes}
Watching for config changes in /Users/mcfatem/GitHub/rootstalk-DO/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at //localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
^C%
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git push
Enumerating objects: 702, done.
Counting objects: 100% (664/664), done.
Delta compression using up to 8 threads
Compressing objects: 100% (145/145), done.
Writing objects: 100% (624/624), 23.39 MiB | 1.31 MiB/s, done.
Total 624 (delta 472), reused 622 (delta 471), pack-reused 0
remote: Resolving deltas: 100% (472/472), completed with 30 local objects.
To https://github.com/Digital-Grinnell/rootstalk-DO
   90aa079..7a1c223  main -> main
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$
```

## The Bad News

The bad news here is two-fold:

1) I got the following email from _Azure_ indicating a failed deployment.  Why?  Well, because a GitHub Action from the `rootstalk` remote, one that's intended only to run in that repository's _Azure_ environment, got executed here in the new `rootstalk-DO` repository.  Fortunately, this does NO HARM.  

```
[Digital-Grinnell/rootstalk-DO] Run failed: Azure Static Web Apps CI/CD - main (7a1c223)
```

2) The production instance of _Rootstalk_ now displays a `© Rootstalk - from 'main'` footer at the bottom of every page.  Why?  Well, because the `config.toml` file from `rootstalk` found its way into `rootstalk-DO` and it defines the footer to display that way.  That display was intended to help us determine which branch of the `rootstalk` code is being displayed **in development**.

Perhaps I need to investigate a way to populate that `config.toml` variable at compile-time?  That would be sweet!     

## The Good News

The good news is simple... IT WORKED!  [_Rootstalk_](https://rootstalk.grinnell.edu) is now up-to-date, with the minor issue reported above, and the deployment to _DigitalOcean_ was automatic, as intended.  The message I see in my _DigitalOcean_ dashboard says:

```
Recent Activity

Dec 22 2021
LIVE
Digital-Grinnell's deployment went live

    Trigger: Digital-Grinnell pushed 7a1c223 to Digital-Grinnell/rootstalk-DO/main

11:45:15 AM
```

And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
