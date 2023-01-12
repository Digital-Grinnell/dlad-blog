---
title: "Another Sync to Rootstalk Production (DigitalOcean) with Dev"
publishdate: 2022-11-07
draft: false
tags:
  - Rootstalk
  - sync
  - production
  - DigitalOcean
supersedes: posts/116-Sync-Rootstalk-Production-(DO)-with-Dev
---

My goal for this afternoon, November 7, 2022, was to find repeat a process last performed almost a year ago on December 22, 2021, to synchronize changes in the development copy of _Rootstalk_ (the `main` branch https://github.com/Digital-Grinnell/rootstalk) with our production deployment (the `main` branch of https://github.com/Digital-Grinnell/rootstalk-DO) to _DigitalOcean_.  This should be a simple repeat of the process documented in [Sync Rootstalk Production (DigitalOcean) with Dev](/posts/116-sync-rootstalk-production-do-with-dev/).  As before, I used guidance found in [How To Merge Between Two Local Repositories](https://stackoverflow.com/questions/21360077/how-to-merge-between-two-local-repositories) to accomplish this.

Note: Our `staging` site cast from the `main` branch of https://github.com/Digital-Grinnell/rootstalk, an _Azure_ static app, can be accessed via https://icy-tree-020380010.azurestaticapps.net.  

## The Workflow

I've captured the inputs and output of the workflow below.  Like before, the process basically involved adding a new local remote named `dev` to my existing `rootstalk-DO` local repository, and doing a `git fetch` of that new remote.  Everything in the `code block` that follows is as-it-was-executed on my _Grinnell College_ MacBook...  

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main›
╰─$ git pull
Already up to date.
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main›
╰─$ cd ../rootstalk-DO
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git pull
Already up to date.
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git remote add dev ../rootstalk
error: remote dev already exists.
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git fetch dev                  
remote: Enumerating objects: 2270, done.
remote: Counting objects: 100% (2268/2268), done.
remote: Compressing objects: 100% (1472/1472), done.
remote: Total 2042 (delta 1503), reused 771 (delta 539), pack-reused 0
Receiving objects: 100% (2042/2042), 11.17 MiB | 14.61 MiB/s, done.
Resolving deltas: 100% (1503/1503), completed with 165 local objects.
From ../rootstalk
 * [new branch]      2022-spring -> dev/2022-spring
 * [new branch]      develop     -> dev/develop
 * [new branch]      document    -> dev/document
   4b3e513..2d34f28  main        -> dev/main
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git merge dev/main
Merge made by the 'ort' strategy.
 .github/workflows/azure-static-web-apps-delightful-stone-01bd98310.yml               |    4 +-
 .github/workflows/azure-static-web-apps-thankful-flower-0a2308810.yml                |   45 +
 README.md                                                                            |   45 +
 assets/sass/_custom.scss                                                             |   49 +-
 config.toml                                                                          |   23 +-
 content/_index.html                                                                  |    4 +-
 content/about/_index.md                                                              |    7 +-
 content/admin/_index.md                                                              |    1 +
 content/images/headers/peace-rock.jpg                                                |  Bin 84108 -> 0 bytes
 content/images/headers/travel-by-starlight.jpg                                       |  Bin 34296 -> 0 bytes
 content/images/volume-iv-issue-2/andelson-bee.jpg                                    |  Bin 531838 -> 0 bytes
 content/images/volume-iv-issue-2/clayton-bee.jpg                                     |  Bin 315767 -> 0 bytes
 content/images/volume-iv-issue-2/damian-and-tony.jpg                                 |  Bin 38545 -> 0 bytes
 content/images/volume-iv-issue-2/finding-the-lost-duck-1.jpg                         |  Bin 320981 -> 0 bytes
 content/images/volume-iv-issue-2/finding-the-lost-duck-2.jpg                         |  Bin 301526 -> 0 bytes
 content/images/volume-iv-issue-2/finding-the-lost-duck-3.jpg                         |  Bin 177709 -> 0 bytes
 content/images/volume-iv-issue-2/finding-the-lost-duck-4.jpg                         |  Bin 557999 -> 0 bytes
 content/images/volume-iv-issue-2/fox-grain.jpg                                       |  Bin 1530487 -> 0 bytes
 content/images/volume-iv-issue-2/from-my-table-to-yours-1.jpg                        |  Bin 268054 -> 0 bytes
 content/images/volume-iv-issue-2/from-my-table-to-yours-2.jpg                        |  Bin 547021 -> 0 bytes
 content/images/volume-iv-issue-2/hayworth-wetland.jpg                                |  Bin 1191865 -> 0 bytes
 content/images/volume-iv-issue-2/hazelwood-cemetery-2.jpg                            |  Bin 2029144 -> 0 bytes
 content/images/volume-iv-issue-2/hazelwood-cemetery.jpg                              |  Bin 337219 -> 0 bytes
 content/images/volume-iv-issue-2/hernandez-fenceline.jpg                             |  Bin 2719311 -> 0 bytes
 content/images/volume-iv-issue-2/hooded-merganser.jpg                                |  Bin 1535264 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-basketball.jpg                               |  Bin 739935 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-family.jpg                                   |  Bin 673144 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-farm.jpg                                     |  Bin 575791 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-horses.jpg                                   |  Bin 289206 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-oxhide-school.jpg                            |  Bin 1370393 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-roster.jpg                                   |  Bin 230465 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-scholarship.jpg                              |  Bin 863175 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-school-bus.jpg                               |  Bin 513591 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-siblings.jpg                                 |  Bin 478142 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-triplets.jpg                                 |  Bin 988310 -> 0 bytes
 content/images/volume-iv-issue-2/janzen-vigor-dish.jpg                               |  Bin 422872 -> 0 bytes
 content/images/volume-iv-issue-2/john-lawrence-hanson.jpg                            |  Bin 3527896 -> 0 bytes
 content/images/volume-iv-issue-2/keith-kozloff-1.jpg                                 |  Bin 505404 -> 0 bytes
 content/images/volume-iv-issue-2/keith-kozloff-2.jpg                                 |  Bin 588554 -> 0 bytes
 content/images/volume-iv-issue-2/keith-kozloff-3.jpg                                 |  Bin 665952 -> 0 bytes
 content/images/volume-iv-issue-2/keith-kozloff-4.jpg                                 |  Bin 365534 -> 0 bytes
 content/images/volume-iv-issue-2/keith-kozloff-5.jpg                                 |  Bin 613776 -> 0 bytes
 content/images/volume-iv-issue-2/keith-kozloff-6.jpg                                 |  Bin 364544 -> 0 bytes
 content/images/volume-iv-issue-2/keith-kozloff-7.jpg                                 |  Bin 696227 -> 0 bytes
 content/images/volume-iv-issue-2/kristine-heykants-1.jpg                             |  Bin 4211427 -> 0 bytes
 content/images/volume-iv-issue-2/kristine-heykants-2.jpg                             |  Bin 1569044 -> 0 bytes
 content/images/volume-iv-issue-2/kristine-heykants-3.jpg                             |  Bin 1498524 -> 0 bytes
 content/images/volume-iv-issue-2/kristine-heykants-4.jpg                             |  Bin 1891155 -> 0 bytes
 content/images/volume-iv-issue-2/mueller-after.jpg                                   |  Bin 697146 -> 0 bytes
 content/images/volume-iv-issue-2/mueller-before.jpg                                  |  Bin 392732 -> 0 bytes
 content/images/volume-iv-issue-2/mueller-chickens.jpg                                |  Bin 499203 -> 0 bytes
 content/images/volume-iv-issue-2/mueller-pano.jpg                                    |  Bin 325490 -> 0 bytes
 content/images/volume-iv-issue-2/mural.jpg                                           |  Bin 204844 -> 0 bytes
 content/images/volume-iv-issue-2/peace-rock-byron-2.jpg                              |  Bin 899233 -> 0 bytes
 content/images/volume-iv-issue-2/peace-rock-byron-john.jpg                           |  Bin 644450 -> 0 bytes
 content/images/volume-iv-issue-2/peace-rock-byron.jpg                                |  Bin 666094 -> 0 bytes
 content/images/volume-iv-issue-2/peace-rock-cyclone.jpg                              |  Bin 272603 -> 0 bytes
 content/images/volume-iv-issue-2/peace-rock-lauren-edwards.jpg                       |  Bin 1039828 -> 0 bytes
 content/images/volume-iv-issue-2/pieta-brown-1.jpg                                   |  Bin 668327 -> 0 bytes
 content/images/volume-iv-issue-2/pieta-brown-2.jpg                                   |  Bin 77390 -> 0 bytes
 content/images/volume-iv-issue-2/roots-of-stone-1.jpg                                |  Bin 317478 -> 0 bytes
 content/images/volume-iv-issue-2/roots-of-stone-2.jpg                                |  Bin 874572 -> 0 bytes
 content/images/volume-iv-issue-2/roots-of-stone-3.jpg                                |  Bin 204256 -> 0 bytes
 content/images/volume-iv-issue-2/roots-of-stone-4.jpg                                |  Bin 589157 -> 0 bytes
 content/images/volume-iv-issue-2/roots-of-stone-5.jpg                                |  Bin 427110 -> 0 bytes
 content/images/volume-iv-issue-2/saunders-loon.jpg                                   |  Bin 491834 -> 0 bytes
 content/images/volume-iv-issue-2/saunders-oriole.jpg                                 |  Bin 387016 -> 0 bytes
 content/images/volume-iv-issue-2/saunders-woodduck.jpg                               |  Bin 679156 -> 0 bytes
 content/images/volume-iv-issue-2/schoenmaker-starlight.jpg                           |  Bin 564211 -> 0 bytes
 content/images/volume-iv-issue-2/this-old-house.jpg                                  |  Bin 821435 -> 0 bytes
 content/past-issues/volume-i-issue-1/.pending/andelson.md                            | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/crowley-images.md                      | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/darrah.md                              | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/editorial-staff.md                     | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/enshayan.md                            | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/ferrell.md                             | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/filler-material.md                     | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/howe-katz.md                           | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/koether.md                             | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/larsen-schulte-tyndall.md              | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/mcdonough.md                           | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/stone-closeup.md                       | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/.pending/williams.md                            | 1897 +++++++++++++++++++++++++++++++
 content/past-issues/volume-i-issue-1/_index.md                                       |   11 +-
 content/past-issues/volume-i-issue-1/andelson-note.md                                |   37 +
 content/past-issues/volume-i-issue-1/crowley-closeup.md                              |   52 +
 content/past-issues/volume-i-issue-1/dean.md                                         |   73 ++
 content/past-issues/volume-i-issue-1/ikerd.md                                        |  118 ++
 content/past-issues/volume-i-issue-1/ottenstein.md                                   |   93 ++
 content/past-issues/volume-i-issue-1/swander-1.md                                    |   43 +
 content/past-issues/volume-i-issue-1/swander-2.md                                    |   56 +
 content/past-issues/volume-i-issue-1/swander-3.md                                    |   49 +
 content/past-issues/volume-ii-issue-1/.pending/filler-material-UNDONE.md             | 1488 +++++++++++++++++++++++++
 content/past-issues/volume-ii-issue-1/_index.md                                      |   11 +-
 content/past-issues/volume-ii-issue-1/editor.md                                      |   38 +
 content/past-issues/volume-ii-issue-1/farewell-richard.md                            |   45 +
 content/past-issues/volume-ii-issue-1/hayworth-photos.md                             |   43 +
 content/past-issues/volume-ii-issue-1/heath.md                                       |   57 +
 content/past-issues/volume-ii-issue-1/kirschenmann.md                                |  148 +++
 content/past-issues/volume-ii-issue-1/lahay.md                                       |  133 +++
 content/past-issues/volume-ii-issue-1/mcilrath.md                                    |  199 ++++
 content/past-issues/volume-ii-issue-1/moffett-1.md                                   |   47 +
 content/past-issues/volume-ii-issue-1/moffett-2.md                                   |   94 ++
 content/past-issues/volume-ii-issue-1/mutel.md                                       |  136 +++
 content/past-issues/volume-ii-issue-1/scanbridge.md                                  |   29 +
 content/past-issues/volume-ii-issue-1/stowe.md                                       |  122 ++
 content/past-issues/volume-ii-issue-1/whittaker.md                                   |   64 ++
 content/past-issues/volume-ii-issue-1/wolf.md                                        |   40 +
 content/past-issues/volume-ii-issue-2/.pending/duncombe-mills.md                     | 3002 ++++++++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-ii-issue-2/.pending/kuhn.md                               | 3002 ++++++++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-ii-issue-2/.pending/non-article-media-1.md                | 3002 ++++++++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-ii-issue-2/.pending/non-article-media-2.md                | 3002 ++++++++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-ii-issue-2/.pending/snow.md                               | 3002 ++++++++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-ii-issue-2/.pending/weeks.md                              | 3002 ++++++++++++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-ii-issue-2/_index.md                                      |   12 +-
 content/past-issues/volume-ii-issue-2/arena.md                                       |   59 +
 content/past-issues/volume-ii-issue-2/atmore.md                                      |  112 ++
 content/past-issues/volume-ii-issue-2/birds.md                                       |   99 ++
 content/past-issues/volume-ii-issue-2/carl.md                                        |   53 +
 content/past-issues/volume-ii-issue-2/dubbeldbee-kuhn.md                             |   34 +
 content/past-issues/volume-ii-issue-2/duncombe-mills.md                              |   28 +
 content/past-issues/volume-ii-issue-2/editor.md                                      |   68 ++
 content/past-issues/volume-ii-issue-2/harris-love.md                                 |   63 ++
 content/past-issues/volume-ii-issue-2/herrnstadt.md                                  |   47 +
 content/past-issues/volume-ii-issue-2/jiminez.md                                     |  151 +++
 content/past-issues/volume-ii-issue-2/johnson.md                                     |  135 +++
 content/past-issues/volume-ii-issue-2/kaiser.md                                      |   87 ++
 content/past-issues/volume-ii-issue-2/kincaid.md                                     |  297 +++++
 content/past-issues/volume-ii-issue-2/kyaruzi.md                                     |  158 +++
 content/past-issues/volume-ii-issue-2/snow.md                                        |   85 ++
 content/past-issues/volume-ii-issue-2/thomasch-1.md                                  |   41 +
 content/past-issues/volume-ii-issue-2/thomasch-2.md                                  |  210 ++++
 content/past-issues/volume-ii-issue-2/wannamaker.md                                  |   84 ++
 content/past-issues/volume-ii-issue-2/water-dance.md                                 |   52 +
 content/past-issues/volume-ii-issue-2/weeks.md                                       |  280 +++++
 content/past-issues/volume-iii-issue-1/.pending/aresty-marek.md                      |    1 +
 content/past-issues/volume-iii-issue-1/.pending/birds.md                             |    1 +
 content/past-issues/volume-iii-issue-1/.pending/cavanaugh.md                         |    1 +
 content/past-issues/volume-iii-issue-1/.pending/evans.md                             |    1 +
 content/past-issues/volume-iii-issue-1/.pending/gray.md                              |    1 +
 content/past-issues/volume-iii-issue-1/.pending/griffin.md                           |    1 +
 content/past-issues/volume-iii-issue-1/.pending/haldy.md                             |    1 +
 content/past-issues/volume-iii-issue-1/.pending/lee.md                               |    1 +
 content/past-issues/volume-iii-issue-1/.pending/meanders.md                          |    1 +
 content/past-issues/volume-iii-issue-1/.pending/melis.md                             |    1 +
 content/past-issues/volume-iii-issue-1/.pending/non-article-media.md                 |    1 +
 content/past-issues/volume-iii-issue-1/.pending/prindaville.md                       |    1 +
 content/past-issues/volume-iii-issue-1/.pending/publisher.md                         |    1 +
 content/past-issues/volume-iii-issue-1/.pending/queathem.md                          |    1 +
 content/past-issues/volume-iii-issue-1/.pending/saunders.md                          |    1 +
 content/past-issues/volume-iii-issue-1/.pending/wiewiora.md                          |    1 +
 content/past-issues/volume-iii-issue-1/.pending/woodward.md                          |    1 +
 content/past-issues/volume-iii-issue-1/_index.md                                     |    8 +-
 content/past-issues/volume-iii-issue-1/aresty-marek.md                               |   64 ++
 content/past-issues/volume-iii-issue-1/cavanaugh.md                                  |   64 ++
 content/past-issues/volume-iii-issue-1/evans.md                                      |   72 ++
 content/past-issues/volume-iii-issue-1/gray.md                                       |  123 +++
 content/past-issues/volume-iii-issue-1/griffin.md                                    |  364 ++++++
 content/past-issues/volume-iii-issue-1/haldy.md                                      |   65 ++
 content/past-issues/volume-iii-issue-1/lee.md                                        |   87 ++
 content/past-issues/volume-iii-issue-1/meanders.md                                   |   63 ++
 content/past-issues/volume-iii-issue-1/melis.md                                      |   24 +
 content/past-issues/volume-iii-issue-1/non-article-media.md                          |   25 +
 content/past-issues/volume-iii-issue-1/prindaville.md                                |   35 +
 content/past-issues/volume-iii-issue-1/publisher.md                                  |   34 +
 content/past-issues/volume-iii-issue-1/queathem.md                                   |   34 +
 content/past-issues/volume-iii-issue-1/saunders.md                                   |   78 ++
 content/past-issues/volume-iii-issue-1/wiewiora.md                                   |  212 ++++
 content/past-issues/volume-iii-issue-1/woodward.md                                   |   25 +
 content/past-issues/volume-iii-issue-2/.pending/abdulkarim-pending.md                |    1 +
 content/past-issues/volume-iii-issue-2/.pending/aschittino-pending.md                |    1 +
 content/past-issues/volume-iii-issue-2/.pending/bergman-pending.md                   |    1 +
 content/past-issues/volume-iii-issue-2/.pending/birds-of-the-prairie-pending.md      |    1 +
 content/past-issues/volume-iii-issue-2/.pending/brosseau-pending.md                  |    1 +
 content/past-issues/volume-iii-issue-2/.pending/cain-pending.md                      |    1 +
 content/past-issues/volume-iii-issue-2/.pending/editor-pending.md                    |    1 +
 content/past-issues/volume-iii-issue-2/.pending/fellows-pending.md                   |    1 +
 content/past-issues/volume-iii-issue-2/.pending/filler-material.md                   |    1 +
 content/past-issues/volume-iii-issue-2/.pending/gaunt-pending.md                     |    1 +
 content/past-issues/volume-iii-issue-2/.pending/hanson-pending.md                    |    1 +
 content/past-issues/volume-iii-issue-2/.pending/maher-pending.md                     |    1 +
 content/past-issues/volume-iii-issue-2/.pending/moffett-pending.md                   |    1 +
 content/past-issues/volume-iii-issue-2/.pending/neems-pending.md                     |    1 +
 content/past-issues/volume-iii-issue-2/.pending/rosburg-pending.md                   |    1 +
 content/past-issues/volume-iii-issue-2/.pending/running-pending.md                   |    1 +
 content/past-issues/volume-iii-issue-2/.pending/schwartz-pending.md                  |    1 +
 content/past-issues/volume-iii-issue-2/.pending/shukla-pending.md                    |    1 +
 content/past-issues/volume-iii-issue-2/.pending/stowe-pending.md                     |    1 +
 content/past-issues/volume-iii-issue-2/_index.md                                     |    5 +-
 content/past-issues/volume-iii-issue-2/abdulkarim.md                                 |    1 +
 content/past-issues/volume-iii-issue-2/aschittino.md                                 |    3 +-
 content/past-issues/volume-iii-issue-2/bergman.md                                    |    1 +
 content/past-issues/volume-iii-issue-2/birds-of-the-prairie.md                       |   39 +-
 content/past-issues/volume-iii-issue-2/brosseau.md                                   |  221 ++--
 content/past-issues/volume-iii-issue-2/cain.md                                       |   15 +-
 content/past-issues/volume-iii-issue-2/editor.md                                     |   14 +-
 content/past-issues/volume-iii-issue-2/fellows.md                                    |   65 +-
 content/past-issues/volume-iii-issue-2/gaunt.md                                      |    1 +
 content/past-issues/volume-iii-issue-2/hanson.md                                     |    7 +-
 content/past-issues/volume-iii-issue-2/maher.md                                      |    7 +-
 content/past-issues/volume-iii-issue-2/moffett.md                                    |    1 +
 content/past-issues/volume-iii-issue-2/neems.md                                      |    1 +
 content/past-issues/volume-iii-issue-2/publisher.md                                  |   15 +-
 content/past-issues/volume-iii-issue-2/rosburg.md                                    |    1 +
 content/past-issues/volume-iii-issue-2/running.md                                    |   30 +-
 content/past-issues/volume-iii-issue-2/schwartz.md                                   |    3 +-
 content/past-issues/volume-iii-issue-2/shukla.md                                     |    3 +-
 content/past-issues/volume-iii-issue-2/stowe.md                                      |    1 +
 content/past-issues/volume-iv-issue-1/.not-ready/mutel.md                            |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/bernal-pending.md                 |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/birds-pending.md                  |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/burt-pending.md                   |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/chirdon-pending.md                |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/clark-pending.md                  |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/dunham-pending.md                 |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/evans-pending.md                  |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/freeberg-pending.md               |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/jackson-pending.md                |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/kugel-pending.md                  |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/lewis-beck-pending.md             |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/luftig-pending.md                 |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/moffett-pending.md                |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/munoz-pending.md                  |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/mutel-pending.md                  |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/publisher-pending.md              |    1 +
 content/past-issues/volume-iv-issue-1/.pending-new/rideout-pending.md                |    1 +
 content/past-issues/volume-iv-issue-1/.pending/arena.md                              | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/atmore.md                             | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/birds.md                              | 2453 +++++++++++++++++++++++------------------
 content/past-issues/volume-iv-issue-1/.pending/burt-pending.md                       |    1 +
 content/past-issues/volume-iv-issue-1/.pending/carl.md                               | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/chirdon-pending.md                    |    1 +
 content/past-issues/volume-iv-issue-1/.pending/chirdon.md                            |    1 +
 content/past-issues/volume-iv-issue-1/.pending/clark.md                              |    2 +
 content/past-issues/volume-iv-issue-1/.pending/dubbeldbee-kuhn.md                    | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/duncombe-mills.md                     | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/dunham-pending.md                     |    1 +
 content/past-issues/volume-iv-issue-1/.pending/editor.md                             | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/evans-pending.md                      |    1 +
 content/past-issues/volume-iv-issue-1/.pending/freeburg.md                           |    1 +
 content/past-issues/volume-iv-issue-1/.pending/harris-love.md                        | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/herrnstadt.md                         | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/jackson-pending.md                    |    1 +
 content/past-issues/volume-iv-issue-1/.pending/jiminez.md                            | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/johnson.md                            | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/kaiser.md                             | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/kincaid.md                            | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/kugel-pending.md                      |    1 +
 content/past-issues/volume-iv-issue-1/.pending/kuhn.md                               | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/kyaruzi.md                            | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/lewis-beck.md                         |    1 +
 content/past-issues/volume-iv-issue-1/.pending/luftig.md                             |    1 +
 content/past-issues/volume-iv-issue-1/.pending/moffett.md                            |    1 +
 content/past-issues/volume-iv-issue-1/.pending/munoz.md                              |    1 +
 content/past-issues/volume-iv-issue-1/.pending/mutel.md                              |    1 +
 content/past-issues/volume-iv-issue-1/.pending/publisher.md                          |    1 +
 content/past-issues/volume-iv-issue-1/.pending/rideout.md                            |    1 +
 content/past-issues/volume-iv-issue-1/.pending/snow.md                               | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/thomasch-1.md                         | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/thomasch-2.md                         | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/wannamaker.md                         | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/.pending/weeks.md                              | 2484 +++++++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-iv-issue-1/_index.md                                      |    5 +-
 content/past-issues/volume-iv-issue-1/bernal.md                                      |   13 +-
 content/past-issues/volume-iv-issue-1/birds.md                                       |    9 +-
 content/past-issues/volume-iv-issue-1/burt-volume-iv-issue-1.md                      |    1 +
 content/past-issues/volume-iv-issue-1/chirdon.md                                     |    1 +
 content/past-issues/volume-iv-issue-1/clark.md                                       |   63 +-
 content/past-issues/volume-iv-issue-1/dunham.md                                      | 1351 +++--------------------
 content/past-issues/volume-iv-issue-1/editor.md                                      |    1 +
 content/past-issues/volume-iv-issue-1/evans-volume-iv-issue-1.md                     |   45 +-
 content/past-issues/volume-iv-issue-1/freeberg.md                                    |   48 +-
 content/past-issues/volume-iv-issue-1/jackson.md                                     |   19 +-
 content/past-issues/volume-iv-issue-1/kugel.md                                       |    1 +
 content/past-issues/volume-iv-issue-1/lewis-beck.md                                  |   14 +-
 content/past-issues/volume-iv-issue-1/luftig.md                                      |  863 +++------------
 content/past-issues/volume-iv-issue-1/moffett.md                                     |    5 +-
 content/past-issues/volume-iv-issue-1/munoz.md                                       |   19 +-
 content/past-issues/volume-iv-issue-1/mutel.md                                       |   18 +-
 content/past-issues/volume-iv-issue-1/publisher.md                                   |    9 +-
 content/past-issues/volume-iv-issue-1/rideout.md                                     |    3 +-
 content/past-issues/volume-iv-issue-2/_index.md                                      |    7 +-
 content/past-issues/volume-iv-issue-2/birds-of-the-prairie-vol-iv-issue-2.md         |   11 +-
 content/past-issues/volume-iv-issue-2/closeup-keith-kozloff.md                       |    3 +-
 content/past-issues/volume-iv-issue-2/closeup-kristine-heykants.md                   |    9 +-
 content/past-issues/volume-iv-issue-2/editors-note-VolIV_Issue2.md                   |   10 +-
 content/past-issues/volume-iv-issue-2/finding-the-lost-duck.md                       |  393 ++-----
 content/past-issues/volume-iv-issue-2/from-my-table-to-yours.md                      |    3 +-
 content/past-issues/volume-iv-issue-2/gnosis.md                                      |    5 +-
 content/past-issues/volume-iv-issue-2/growing-up-in-kansas.md                        |  419 ++-----
 content/past-issues/volume-iv-issue-2/johansson-his-ambassador.md                    |    3 +-
 content/past-issues/volume-iv-issue-2/lac-la-biche-mission.md                        |    5 +-
 content/past-issues/volume-iv-issue-2/making-room.md                                 |    5 +-
 content/past-issues/volume-iv-issue-2/manoylov-peaches-meet-corn.md                  |    6 +-
 content/past-issues/volume-iv-issue-2/night-as-controlled-prairie-fire.md            |   24 +-
 content/past-issues/volume-iv-issue-2/ode-to-the-honey-bee.md                        |   25 +-
 content/past-issues/volume-iv-issue-2/open-door.md                                   |   16 +-
 content/past-issues/volume-iv-issue-2/peace-rock.md                                  |  199 +---
 content/past-issues/volume-iv-issue-2/pieta-brown-in-concert.md                      |   38 +-
 content/past-issues/volume-iv-issue-2/publishers-note-VolIV_Issue2.md                |   19 +-
 content/past-issues/volume-iv-issue-2/roadtrip.md                                    |  613 +++--------
 content/past-issues/volume-iv-issue-2/roots-of-stone.md                              |  316 ++----
 content/past-issues/volume-iv-issue-2/roots-talk-podcast-ep-3.md                     |   20 +-
 content/past-issues/volume-iv-issue-2/roots-talk-podcast-ep-4.md                     |   20 +-
 content/past-issues/volume-iv-issue-2/this-old-house.md                              |   22 +-
 content/past-issues/volume-iv-issue-2/travel-by-starlight.md                         |   15 +-
 content/past-issues/volume-iv-issue-2/two-poems-bill-graeser.md                      |   18 +-
 content/past-issues/volume-iv-issue-2/worthless-rocks.md                             |   60 -
 content/past-issues/volume-v-issue-1/.american-bison.md                              |    3 +-
 content/past-issues/volume-v-issue-1/.american-mink.md                               |    1 +
 content/past-issues/volume-v-issue-1/.virginia-opossum.md                            |    3 +-
 content/past-issues/volume-v-issue-1/.white-tailed-deer.md                           |    3 +-
 content/past-issues/volume-v-issue-1/_index.md                                       |    7 +-
 content/past-issues/volume-v-issue-1/a-place-to-call-home.md                         |    3 +-
 content/past-issues/volume-v-issue-1/building-the-agricultural-city.md               |    9 +-
 content/past-issues/volume-v-issue-1/cheyenne-bottoms.md                             |    7 +-
 content/past-issues/volume-v-issue-1/closeup-regan-golden.md                         |    7 +-
 content/past-issues/volume-v-issue-1/community-commons-ecological-restoration.md     |   19 +-
 content/past-issues/volume-v-issue-1/editors-note-VolV_Issue1.md                     |    1 +
 content/past-issues/volume-v-issue-1/extraction-roots-energy-plains.md               |    7 +-
 content/past-issues/volume-v-issue-1/first-taste-of-freedom.md                       |    3 +-
 content/past-issues/volume-v-issue-1/healing-the-smallest-casualty.md                |    1 +
 content/past-issues/volume-v-issue-1/jumping-into-the-void.md                        |    5 +-
 content/past-issues/volume-v-issue-1/little-prairie-on-the-freeway.md                |    3 +-
 content/past-issues/volume-v-issue-1/mammals-of-the-prairie.md                       |   11 +-
 content/past-issues/volume-v-issue-1/my-integrated-life-pt-1.md                      |   39 +-
 content/past-issues/volume-v-issue-1/on-the-changing-nature-of-the-obituary.md       |    9 +-
 content/past-issues/volume-v-issue-1/publishers-note-VolV-Issue1.md                  |    7 +-
 content/past-issues/volume-v-issue-1/roots-talk-podcast-ep-5.md                      |    1 +
 content/past-issues/volume-v-issue-1/the-hottest-car-in-town.md                      |    1 +
 content/past-issues/volume-v-issue-1/two-poems-john-grey.md                          |    1 +
 content/past-issues/volume-v-issue-1/two-poems-richard-luftig.md                     |    3 +-
 content/past-issues/volume-v-issue-1/two-poems-rodney-nelson.md                      |   11 +-
 content/past-issues/volume-v-issue-1/welcoming-the-world-to-our-farm.md              |    1 +
 content/past-issues/volume-v-issue-1/what-do-you-think-community-is.md               |    3 +-
 content/past-issues/volume-v-issue-1/worthless-rocks.md                              |   18 +-
 content/past-issues/volume-v-issue-2/.pending/behar.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/boyce.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/brandt.md                              | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/brew.md                                | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/brown.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/clarke-curtis.md                       | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/cohen.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/curtis.md                              | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/editor.md                              | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/filler-material.md                     | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/goodnature.md                          | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/hanson.md                              | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/jain.md                                | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/lewis-beck.md                          | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/mcbee.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/moffett.md                             | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/neems.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/podcast.md                             | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/publisher.md                           | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/sarnat.md                              | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/snodgrass.md                           | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/stowe.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/.pending/white.md                               | 2251 +++++++++++++++++++++++++++++++++++++
 content/past-issues/volume-v-issue-2/_index.md                                       |   17 +
 content/past-issues/volume-v-issue-2/behar.md                                        |   47 +
 content/past-issues/volume-v-issue-2/boyce.md                                        |   99 ++
 content/past-issues/volume-v-issue-2/brandt.md                                       |   87 ++
 content/past-issues/volume-v-issue-2/brew.md                                         |   86 ++
 content/past-issues/volume-v-issue-2/brown.md                                        |  363 ++++++
 content/past-issues/volume-v-issue-2/clarke-curtis.md                                |  226 ++++
 content/past-issues/volume-v-issue-2/cohen.md                                        |   45 +
 content/past-issues/volume-v-issue-2/cover.jpg                                       |  Bin 0 -> 758661 bytes
 content/past-issues/volume-v-issue-2/cover.png                                       |  Bin 0 -> 1381926 bytes
 content/past-issues/volume-v-issue-2/editor.md                                       |   31 +
 content/past-issues/volume-v-issue-2/filler-material.md                              |   35 +
 content/past-issues/volume-v-issue-2/goodnature.md                                   |   44 +
 content/past-issues/volume-v-issue-2/hanson.md                                       |   65 ++
 content/past-issues/volume-v-issue-2/jain.md                                         |   92 ++
 content/past-issues/volume-v-issue-2/lewis-beck.md                                   |   79 ++
 content/past-issues/volume-v-issue-2/mcbee.md                                        |   34 +
 content/past-issues/volume-v-issue-2/moffett.md                                      |   52 +
 content/past-issues/volume-v-issue-2/neems.md                                        |   50 +
 content/past-issues/volume-v-issue-2/podcast.md                                      |   24 +
 content/past-issues/volume-v-issue-2/publisher.md                                    |   65 ++
 content/past-issues/volume-v-issue-2/sarnat.md                                       |  220 ++++
 content/past-issues/volume-v-issue-2/snodgrass.md                                    |   35 +
 content/past-issues/volume-v-issue-2/stowe.md                                        |   78 ++
 content/past-issues/volume-v-issue-2/white.md                                        |   87 ++
 content/past-issues/volume-vi-issue-1/Schaefer.md                                    |    9 +-
 content/past-issues/volume-vi-issue-1/_index.md                                      |   11 +-
 content/past-issues/volume-vi-issue-1/adair.md                                       |    3 +-
 content/past-issues/volume-vi-issue-1/andelson.md                                    |    1 +
 content/past-issues/volume-vi-issue-1/baechtel.md                                    |    3 +-
 content/past-issues/volume-vi-issue-1/beck.md                                        |    9 +-
 content/past-issues/volume-vi-issue-1/beisner.md                                     |    1 +
 content/past-issues/volume-vi-issue-1/brew.md                                        |    1 +
 content/past-issues/volume-vi-issue-1/brown.md                                       |   59 +-
 content/past-issues/volume-vi-issue-1/buck.md                                        |    7 +-
 content/past-issues/volume-vi-issue-1/dean.md                                        |    3 +-
 content/past-issues/volume-vi-issue-1/drobney.md                                     |    3 +-
 content/past-issues/volume-vi-issue-1/fatehpuria.md                                  |    3 +-
 content/past-issues/volume-vi-issue-1/fatehpuria2.md                                 |    7 +-
 content/past-issues/volume-vi-issue-1/goldberg.md                                    |    1 +
 content/past-issues/volume-vi-issue-1/hansen.md                                      |    3 +-
 content/past-issues/volume-vi-issue-1/kim.md                                         |    3 +-
 content/past-issues/volume-vi-issue-1/kurtz.md                                       |    3 +-
 content/past-issues/volume-vi-issue-1/moffet.md                                      |    5 +-
 content/past-issues/volume-vi-issue-1/payne.md                                       |   11 +-
 content/past-issues/volume-vi-issue-1/perez.md                                       |    1 +
 content/past-issues/volume-vi-issue-1/potter.md                                      |    1 +
 content/past-issues/volume-vi-issue-1/segner.md                                      |    7 +-
 content/past-issues/volume-vi-issue-1/snouffer.md                                    |    7 +-
 content/past-issues/volume-vi-issue-1/teigland.md                                    |    5 +-
 content/past-issues/volume-vii-issue-1/_index.md                                     |   11 +-
 content/past-issues/volume-vii-issue-1/andelson-maya.md                              |    1 +
 content/past-issues/volume-vii-issue-1/andelson.md                                   |    5 +-
 content/past-issues/volume-vii-issue-1/arneson.md                                    |    5 +-
 content/past-issues/volume-vii-issue-1/baechtel.md                                   |    5 +-
 content/past-issues/volume-vii-issue-1/carr.md                                       |    1 +
 content/past-issues/volume-vii-issue-1/commers.md                                    |    1 +
 content/past-issues/volume-vii-issue-1/devany.md                                     |    5 +-
 content/past-issues/volume-vii-issue-1/doherty.md                                    |   12 +-
 content/past-issues/volume-vii-issue-1/getahun.md                                    |    9 +-
 content/past-issues/volume-vii-issue-1/goodall.md                                    |    1 +
 content/past-issues/volume-vii-issue-1/keleher.md                                    |   13 +-
 content/past-issues/volume-vii-issue-1/kreutzian.md                                  |    9 +-
 content/past-issues/volume-vii-issue-1/meulemans.md                                  |   17 +-
 content/past-issues/volume-vii-issue-1/miller.md                                     |   17 +-
 content/past-issues/volume-vii-issue-1/ohlenbusch.md                                 |    5 +-
 content/past-issues/volume-vii-issue-1/sherpa.md                                     |    1 +
 content/past-issues/volume-vii-issue-1/tibatemwa.md                                  |    1 +
 content/past-issues/volume-vii-issue-1/yuan.md                                       |    1 +
 content/past-issues/volume-vii-issue-2/_index.md                                     |   18 +
 content/{ => past-issues}/volume-vii-issue-2/andelson.md                             |    7 +-
 content/{ => past-issues}/volume-vii-issue-2/baechtel.md                             |    7 +-
 content/{ => past-issues}/volume-vii-issue-2/bower.md                                |   14 +-
 content/{ => past-issues}/volume-vii-issue-2/boyce.md                                |    1 +
 content/{ => past-issues}/volume-vii-issue-2/clotfelter.md                           |    1 +
 content/{ => past-issues}/volume-vii-issue-2/cover.png                               |  Bin
 content/{ => past-issues}/volume-vii-issue-2/endangered-animals.md                   |    1 +
 content/{ => past-issues}/volume-vii-issue-2/johnson.md                              |   16 +-
 content/{ => past-issues}/volume-vii-issue-2/kouchi.md                               |    1 +
 content/{ => past-issues}/volume-vii-issue-2/ojendyk.md                              |   11 +-
 content/{ => past-issues}/volume-vii-issue-2/ottenstein.md                           |    9 +-
 content/{ => past-issues}/volume-vii-issue-2/rootstalk_leaf.svg                      |    0
 content/{ => past-issues}/volume-vii-issue-2/ross.md                                 |    7 +-
 content/{ => past-issues}/volume-vii-issue-2/taylor.md                               |    1 +
 content/script.sh                                                                    |   14 +
 content/submit/_index.md                                                             |    3 +-
 content/volume-vii-issue-2/_index.md                                                 |    9 -
 content/volume-viii-issue-1/.pending/_master.md                                      | 2524 ++++++++++++++++++++++++++++++++++++++++++
 content/volume-viii-issue-1/_index.md                                                |   17 +
 content/volume-viii-issue-1/agpoon.md                                                |   74 ++
 content/volume-viii-issue-1/bradley.md                                               |   73 ++
 content/volume-viii-issue-1/buck.md                                                  |   42 +
 content/volume-viii-issue-1/burchit.md                                               |   76 ++
 content/volume-viii-issue-1/burt.md                                                  |   79 ++
 content/volume-viii-issue-1/chen.md                                                  |   63 ++
 content/volume-viii-issue-1/cover.png                                                |  Bin 0 -> 1185260 bytes
 content/volume-viii-issue-1/gaddis.md                                                |  123 +++
 content/volume-viii-issue-1/henry.md                                                 |  162 +++
 content/volume-viii-issue-1/hootstein.md                                             |   87 ++
 content/volume-viii-issue-1/horan.md                                                 |   48 +
 content/volume-viii-issue-1/kessel.md                                                |  114 ++
 content/volume-viii-issue-1/lewis-beck.md                                            |  212 ++++
 content/volume-viii-issue-1/macmoran.md                                              |  111 ++
 content/volume-viii-issue-1/mcgary-adams-dubow-fay-stindt-schaefer.md                |  298 +++++
 content/volume-viii-issue-1/munoz.md                                                 |   54 +
 content/volume-viii-issue-1/obrien.md                                                |  136 +++
 content/volume-viii-issue-1/publisher.md                                             |   76 ++
 content/volume-viii-issue-1/taylor.md                                                |   65 ++
 content/volume-viii-issue-1/thompson.md                                              |  127 +++
 content/volume-viii-issue-1/trissell.md                                              |   71 ++
 content/volume-viii-issue-1/woodpeckers-of-the-prairie.md                            |  148 +++
 ArticleType-and-Tag-Values.md => documentation/ArticleType-and-Tag-Values.md         |    3 +
 Automated-Testing.md => documentation/Automated-Testing.md                           |    0
 Git-Workflow-in-Windows.md => documentation/Git-Workflow-in-Windows.md               |    0
 Migration-to-Azure.md => documentation/Migration-to-Azure.md                         |    0
 PUSH-TO-PRODUCTION.md => documentation/PUSH-TO-PRODUCTION.md                         |    0
 documentation/README.md                                                              |  108 ++
 STRUCTURE-Rules.md => documentation/STRUCTURE-Rules.md                               |    0
 Visual-Proofreading.md => documentation/Visual-Proofreading.md                       |    0
 alina-git-workflow.md => documentation/alina-git-workflow.md                         |    0
 pdf-to-markdown.md => documentation/pdf-to-markdown.md                               |    0
 revised-editor-git-workflow.md => documentation/revised-editor-git-workflow.md       |   18 +-
 documentation/shared-mac-editor-git-workflow.md                                      |   30 +
 editors-prefatory-text-template.md                                                   |    1 +
 layouts/_default/baseof.html                                                         |    1 +
 layouts/_default/list.html                                                           |   22 +-
 layouts/_default/single.html                                                         |   21 +-
 layouts/shortcodes/audio_azure.html                                                  |    2 +-
 layouts/shortcodes/dropcap.html                                                      |    3 +
 layouts/shortcodes/figure_azure.html                                                 |   23 +-
 layouts/shortcodes/indent-with-attribution.html                                      |    9 +
 layouts/shortcodes/indent.html                                                       |    4 +
 layouts/shortcodes/video_azure.html                                                  |    4 +-
 link-format.js                                                                       |    7 +
 resources/_gen/assets/scss/sass/styles.scss_5bac553973685aab030dcdbdaeaab6f8.content |    2 +-
 resources/_gen/assets/scss/sass/styles.scss_5bac553973685aab030dcdbdaeaab6f8.json    |    2 +-
 static/announcement.md                                                               |    1 +
 static/images/generic-01.png                                                         |  Bin 0 -> 163222 bytes
 themes/rootstalkzen/layouts/partials/meta.html                                       |    2 +-
 themes/rootstalkzen/layouts/partials/styles.html                                     |    2 +-
 499 files changed, 158639 insertions(+), 5269 deletions(-)
 create mode 100644 .github/workflows/azure-static-web-apps-thankful-flower-0a2308810.yml
 delete mode 100644 content/images/headers/peace-rock.jpg
 delete mode 100644 content/images/headers/travel-by-starlight.jpg
 delete mode 100644 content/images/volume-iv-issue-2/andelson-bee.jpg
 delete mode 100644 content/images/volume-iv-issue-2/clayton-bee.jpg
 delete mode 100644 content/images/volume-iv-issue-2/damian-and-tony.jpg
 delete mode 100644 content/images/volume-iv-issue-2/finding-the-lost-duck-1.jpg
 delete mode 100644 content/images/volume-iv-issue-2/finding-the-lost-duck-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/finding-the-lost-duck-3.jpg
 delete mode 100644 content/images/volume-iv-issue-2/finding-the-lost-duck-4.jpg
 delete mode 100644 content/images/volume-iv-issue-2/fox-grain.jpg
 delete mode 100644 content/images/volume-iv-issue-2/from-my-table-to-yours-1.jpg
 delete mode 100644 content/images/volume-iv-issue-2/from-my-table-to-yours-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/hayworth-wetland.jpg
 delete mode 100644 content/images/volume-iv-issue-2/hazelwood-cemetery-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/hazelwood-cemetery.jpg
 delete mode 100644 content/images/volume-iv-issue-2/hernandez-fenceline.jpg
 delete mode 100644 content/images/volume-iv-issue-2/hooded-merganser.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-basketball.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-family.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-farm.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-horses.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-oxhide-school.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-roster.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-scholarship.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-school-bus.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-siblings.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-triplets.jpg
 delete mode 100644 content/images/volume-iv-issue-2/janzen-vigor-dish.jpg
 delete mode 100644 content/images/volume-iv-issue-2/john-lawrence-hanson.jpg
 delete mode 100644 content/images/volume-iv-issue-2/keith-kozloff-1.jpg
 delete mode 100644 content/images/volume-iv-issue-2/keith-kozloff-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/keith-kozloff-3.jpg
 delete mode 100644 content/images/volume-iv-issue-2/keith-kozloff-4.jpg
 delete mode 100644 content/images/volume-iv-issue-2/keith-kozloff-5.jpg
 delete mode 100644 content/images/volume-iv-issue-2/keith-kozloff-6.jpg
 delete mode 100644 content/images/volume-iv-issue-2/keith-kozloff-7.jpg
 delete mode 100644 content/images/volume-iv-issue-2/kristine-heykants-1.jpg
 delete mode 100644 content/images/volume-iv-issue-2/kristine-heykants-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/kristine-heykants-3.jpg
 delete mode 100644 content/images/volume-iv-issue-2/kristine-heykants-4.jpg
 delete mode 100644 content/images/volume-iv-issue-2/mueller-after.jpg
 delete mode 100644 content/images/volume-iv-issue-2/mueller-before.jpg
 delete mode 100644 content/images/volume-iv-issue-2/mueller-chickens.jpg
 delete mode 100644 content/images/volume-iv-issue-2/mueller-pano.jpg
 delete mode 100644 content/images/volume-iv-issue-2/mural.jpg
 delete mode 100644 content/images/volume-iv-issue-2/peace-rock-byron-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/peace-rock-byron-john.jpg
 delete mode 100644 content/images/volume-iv-issue-2/peace-rock-byron.jpg
 delete mode 100644 content/images/volume-iv-issue-2/peace-rock-cyclone.jpg
 delete mode 100644 content/images/volume-iv-issue-2/peace-rock-lauren-edwards.jpg
 delete mode 100644 content/images/volume-iv-issue-2/pieta-brown-1.jpg
 delete mode 100644 content/images/volume-iv-issue-2/pieta-brown-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/roots-of-stone-1.jpg
 delete mode 100644 content/images/volume-iv-issue-2/roots-of-stone-2.jpg
 delete mode 100644 content/images/volume-iv-issue-2/roots-of-stone-3.jpg
 delete mode 100644 content/images/volume-iv-issue-2/roots-of-stone-4.jpg
 delete mode 100644 content/images/volume-iv-issue-2/roots-of-stone-5.jpg
 delete mode 100644 content/images/volume-iv-issue-2/saunders-loon.jpg
 delete mode 100644 content/images/volume-iv-issue-2/saunders-oriole.jpg
 delete mode 100644 content/images/volume-iv-issue-2/saunders-woodduck.jpg
 delete mode 100644 content/images/volume-iv-issue-2/schoenmaker-starlight.jpg
 delete mode 100644 content/images/volume-iv-issue-2/this-old-house.jpg
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/andelson.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/crowley-images.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/darrah.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/editorial-staff.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/enshayan.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/ferrell.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/filler-material.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/howe-katz.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/koether.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/larsen-schulte-tyndall.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/mcdonough.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/stone-closeup.md
 create mode 100644 content/past-issues/volume-i-issue-1/.pending/williams.md
 create mode 100644 content/past-issues/volume-i-issue-1/andelson-note.md
 create mode 100644 content/past-issues/volume-i-issue-1/crowley-closeup.md
 create mode 100644 content/past-issues/volume-i-issue-1/dean.md
 create mode 100644 content/past-issues/volume-i-issue-1/ikerd.md
 create mode 100644 content/past-issues/volume-i-issue-1/ottenstein.md
 create mode 100644 content/past-issues/volume-i-issue-1/swander-1.md
 create mode 100644 content/past-issues/volume-i-issue-1/swander-2.md
 create mode 100644 content/past-issues/volume-i-issue-1/swander-3.md
 create mode 100644 content/past-issues/volume-ii-issue-1/.pending/filler-material-UNDONE.md
 create mode 100644 content/past-issues/volume-ii-issue-1/editor.md
 create mode 100644 content/past-issues/volume-ii-issue-1/farewell-richard.md
 create mode 100644 content/past-issues/volume-ii-issue-1/hayworth-photos.md
 create mode 100644 content/past-issues/volume-ii-issue-1/heath.md
 create mode 100644 content/past-issues/volume-ii-issue-1/kirschenmann.md
 create mode 100644 content/past-issues/volume-ii-issue-1/lahay.md
 create mode 100644 content/past-issues/volume-ii-issue-1/mcilrath.md
 create mode 100644 content/past-issues/volume-ii-issue-1/moffett-1.md
 create mode 100644 content/past-issues/volume-ii-issue-1/moffett-2.md
 create mode 100644 content/past-issues/volume-ii-issue-1/mutel.md
 create mode 100644 content/past-issues/volume-ii-issue-1/scanbridge.md
 create mode 100644 content/past-issues/volume-ii-issue-1/stowe.md
 create mode 100644 content/past-issues/volume-ii-issue-1/whittaker.md
 create mode 100644 content/past-issues/volume-ii-issue-1/wolf.md
 create mode 100644 content/past-issues/volume-ii-issue-2/.pending/duncombe-mills.md
 create mode 100644 content/past-issues/volume-ii-issue-2/.pending/kuhn.md
 create mode 100644 content/past-issues/volume-ii-issue-2/.pending/non-article-media-1.md
 create mode 100644 content/past-issues/volume-ii-issue-2/.pending/non-article-media-2.md
 create mode 100644 content/past-issues/volume-ii-issue-2/.pending/snow.md
 create mode 100644 content/past-issues/volume-ii-issue-2/.pending/weeks.md
 create mode 100644 content/past-issues/volume-ii-issue-2/arena.md
 create mode 100644 content/past-issues/volume-ii-issue-2/atmore.md
 create mode 100644 content/past-issues/volume-ii-issue-2/birds.md
 create mode 100644 content/past-issues/volume-ii-issue-2/carl.md
 create mode 100644 content/past-issues/volume-ii-issue-2/dubbeldbee-kuhn.md
 create mode 100644 content/past-issues/volume-ii-issue-2/duncombe-mills.md
 create mode 100644 content/past-issues/volume-ii-issue-2/editor.md
 create mode 100644 content/past-issues/volume-ii-issue-2/harris-love.md
 create mode 100644 content/past-issues/volume-ii-issue-2/herrnstadt.md
 create mode 100644 content/past-issues/volume-ii-issue-2/jiminez.md
 create mode 100644 content/past-issues/volume-ii-issue-2/johnson.md
 create mode 100644 content/past-issues/volume-ii-issue-2/kaiser.md
 create mode 100644 content/past-issues/volume-ii-issue-2/kincaid.md
 create mode 100644 content/past-issues/volume-ii-issue-2/kyaruzi.md
 create mode 100644 content/past-issues/volume-ii-issue-2/snow.md
 create mode 100644 content/past-issues/volume-ii-issue-2/thomasch-1.md
 create mode 100644 content/past-issues/volume-ii-issue-2/thomasch-2.md
 create mode 100644 content/past-issues/volume-ii-issue-2/wannamaker.md
 create mode 100644 content/past-issues/volume-ii-issue-2/water-dance.md
 create mode 100644 content/past-issues/volume-ii-issue-2/weeks.md
 create mode 100644 content/past-issues/volume-iii-issue-1/aresty-marek.md
 create mode 100644 content/past-issues/volume-iii-issue-1/cavanaugh.md
 create mode 100644 content/past-issues/volume-iii-issue-1/evans.md
 create mode 100644 content/past-issues/volume-iii-issue-1/gray.md
 create mode 100644 content/past-issues/volume-iii-issue-1/griffin.md
 create mode 100644 content/past-issues/volume-iii-issue-1/haldy.md
 create mode 100644 content/past-issues/volume-iii-issue-1/lee.md
 create mode 100644 content/past-issues/volume-iii-issue-1/meanders.md
 create mode 100644 content/past-issues/volume-iii-issue-1/melis.md
 create mode 100644 content/past-issues/volume-iii-issue-1/non-article-media.md
 create mode 100644 content/past-issues/volume-iii-issue-1/prindaville.md
 create mode 100644 content/past-issues/volume-iii-issue-1/publisher.md
 create mode 100644 content/past-issues/volume-iii-issue-1/queathem.md
 create mode 100644 content/past-issues/volume-iii-issue-1/saunders.md
 create mode 100644 content/past-issues/volume-iii-issue-1/wiewiora.md
 create mode 100644 content/past-issues/volume-iii-issue-1/woodward.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/abdulkarim.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/aschittino.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/bergman.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/birds-of-the-prairie.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/brosseau.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/cain.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/editor.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/fellows.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/gaunt.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/hanson.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/maher.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/moffett.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/neems.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/publisher.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/rosburg.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/running.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/schwartz.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/shukla.md
 mode change 100755 => 100644 content/past-issues/volume-iii-issue-2/stowe.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/arena.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/atmore.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/carl.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/dubbeldbee-kuhn.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/duncombe-mills.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/editor.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/harris-love.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/herrnstadt.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/jiminez.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/johnson.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/kaiser.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/kincaid.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/kuhn.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/kyaruzi.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/snow.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/thomasch-1.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/thomasch-2.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/wannamaker.md
 create mode 100644 content/past-issues/volume-iv-issue-1/.pending/weeks.md
 delete mode 100644 content/past-issues/volume-iv-issue-2/worthless-rocks.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/behar.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/boyce.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/brandt.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/brew.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/brown.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/clarke-curtis.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/cohen.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/curtis.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/editor.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/filler-material.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/goodnature.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/hanson.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/jain.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/lewis-beck.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/mcbee.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/moffett.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/neems.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/podcast.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/publisher.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/sarnat.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/snodgrass.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/stowe.md
 create mode 100644 content/past-issues/volume-v-issue-2/.pending/white.md
 create mode 100644 content/past-issues/volume-v-issue-2/_index.md
 create mode 100644 content/past-issues/volume-v-issue-2/behar.md
 create mode 100644 content/past-issues/volume-v-issue-2/boyce.md
 create mode 100644 content/past-issues/volume-v-issue-2/brandt.md
 create mode 100644 content/past-issues/volume-v-issue-2/brew.md
 create mode 100644 content/past-issues/volume-v-issue-2/brown.md
 create mode 100644 content/past-issues/volume-v-issue-2/clarke-curtis.md
 create mode 100644 content/past-issues/volume-v-issue-2/cohen.md
 create mode 100644 content/past-issues/volume-v-issue-2/cover.jpg
 create mode 100644 content/past-issues/volume-v-issue-2/cover.png
 create mode 100644 content/past-issues/volume-v-issue-2/editor.md
 create mode 100644 content/past-issues/volume-v-issue-2/filler-material.md
 create mode 100644 content/past-issues/volume-v-issue-2/goodnature.md
 create mode 100644 content/past-issues/volume-v-issue-2/hanson.md
 create mode 100644 content/past-issues/volume-v-issue-2/jain.md
 create mode 100644 content/past-issues/volume-v-issue-2/lewis-beck.md
 create mode 100644 content/past-issues/volume-v-issue-2/mcbee.md
 create mode 100644 content/past-issues/volume-v-issue-2/moffett.md
 create mode 100644 content/past-issues/volume-v-issue-2/neems.md
 create mode 100644 content/past-issues/volume-v-issue-2/podcast.md
 create mode 100644 content/past-issues/volume-v-issue-2/publisher.md
 create mode 100644 content/past-issues/volume-v-issue-2/sarnat.md
 create mode 100644 content/past-issues/volume-v-issue-2/snodgrass.md
 create mode 100644 content/past-issues/volume-v-issue-2/stowe.md
 create mode 100644 content/past-issues/volume-v-issue-2/white.md
 create mode 100644 content/past-issues/volume-vii-issue-2/_index.md
 rename content/{ => past-issues}/volume-vii-issue-2/andelson.md (98%)
 rename content/{ => past-issues}/volume-vii-issue-2/baechtel.md (91%)
 rename content/{ => past-issues}/volume-vii-issue-2/bower.md (95%)
 rename content/{ => past-issues}/volume-vii-issue-2/boyce.md (97%)
 rename content/{ => past-issues}/volume-vii-issue-2/clotfelter.md (99%)
 rename content/{ => past-issues}/volume-vii-issue-2/cover.png (100%)
 rename content/{ => past-issues}/volume-vii-issue-2/endangered-animals.md (98%)
 rename content/{ => past-issues}/volume-vii-issue-2/johnson.md (92%)
 rename content/{ => past-issues}/volume-vii-issue-2/kouchi.md (99%)
 rename content/{ => past-issues}/volume-vii-issue-2/ojendyk.md (78%)
 rename content/{ => past-issues}/volume-vii-issue-2/ottenstein.md (89%)
 rename content/{ => past-issues}/volume-vii-issue-2/rootstalk_leaf.svg (100%)
 rename content/{ => past-issues}/volume-vii-issue-2/ross.md (99%)
 rename content/{ => past-issues}/volume-vii-issue-2/taylor.md (99%)
 create mode 100644 content/script.sh
 delete mode 100644 content/volume-vii-issue-2/_index.md
 create mode 100644 content/volume-viii-issue-1/.pending/_master.md
 create mode 100644 content/volume-viii-issue-1/_index.md
 create mode 100644 content/volume-viii-issue-1/agpoon.md
 create mode 100644 content/volume-viii-issue-1/bradley.md
 create mode 100644 content/volume-viii-issue-1/buck.md
 create mode 100644 content/volume-viii-issue-1/burchit.md
 create mode 100644 content/volume-viii-issue-1/burt.md
 create mode 100644 content/volume-viii-issue-1/chen.md
 create mode 100644 content/volume-viii-issue-1/cover.png
 create mode 100644 content/volume-viii-issue-1/gaddis.md
 create mode 100644 content/volume-viii-issue-1/henry.md
 create mode 100644 content/volume-viii-issue-1/hootstein.md
 create mode 100644 content/volume-viii-issue-1/horan.md
 create mode 100644 content/volume-viii-issue-1/kessel.md
 create mode 100644 content/volume-viii-issue-1/lewis-beck.md
 create mode 100644 content/volume-viii-issue-1/macmoran.md
 create mode 100644 content/volume-viii-issue-1/mcgary-adams-dubow-fay-stindt-schaefer.md
 create mode 100644 content/volume-viii-issue-1/munoz.md
 create mode 100644 content/volume-viii-issue-1/obrien.md
 create mode 100644 content/volume-viii-issue-1/publisher.md
 create mode 100644 content/volume-viii-issue-1/taylor.md
 create mode 100644 content/volume-viii-issue-1/thompson.md
 create mode 100644 content/volume-viii-issue-1/trissell.md
 create mode 100644 content/volume-viii-issue-1/woodpeckers-of-the-prairie.md
 rename ArticleType-and-Tag-Values.md => documentation/ArticleType-and-Tag-Values.md (95%)
 rename Automated-Testing.md => documentation/Automated-Testing.md (100%)
 rename Git-Workflow-in-Windows.md => documentation/Git-Workflow-in-Windows.md (100%)
 rename Migration-to-Azure.md => documentation/Migration-to-Azure.md (100%)
 rename PUSH-TO-PRODUCTION.md => documentation/PUSH-TO-PRODUCTION.md (100%)
 create mode 100644 documentation/README.md
 rename STRUCTURE-Rules.md => documentation/STRUCTURE-Rules.md (100%)
 rename Visual-Proofreading.md => documentation/Visual-Proofreading.md (100%)
 rename alina-git-workflow.md => documentation/alina-git-workflow.md (100%)
 rename pdf-to-markdown.md => documentation/pdf-to-markdown.md (100%)
 rename revised-editor-git-workflow.md => documentation/revised-editor-git-workflow.md (63%)
 create mode 100644 documentation/shared-mac-editor-git-workflow.md
 create mode 100644 editors-prefatory-text-template.md
 create mode 100644 layouts/shortcodes/dropcap.html
 create mode 100644 layouts/shortcodes/indent-with-attribution.html
 create mode 100644 layouts/shortcodes/indent.html
 create mode 100644 link-format.js
 create mode 100644 static/announcement.md
 create mode 100644 static/images/generic-01.png
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git status
On branch main
Your branch is ahead of 'origin/main' by 228 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ hugo server
Start building sites …
hugo v0.101.0+extended darwin/arm64 BuildDate=unknown
WARN 2022/11/07 12:59:32 .File.UniqueID on zero object. Wrap it in if or with: {{ with .File }}{{ .UniqueID }}{{ end }}

                   | EN
-------------------+------
  Pages            | 394
  Paginator pages  |  23
  Non-page files   | 114
  Static files     |  29
  Processed images |   0
  Aliases          |  72
  Sitemaps         |   1
  Cleaned          |   0

Built in 485 ms
Watching for changes in /Users/mcfatem/GitHub/rootstalk-DO/{archetypes,assets,content,layouts,static,themes}
Watching for config changes in /Users/mcfatem/GitHub/rootstalk-DO/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at //localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

At this point I interrupted the process from a year ago to look for any ill-effects in my `http://localhost:1313` rendering of the code.  I was looking especially at the contents of the `config.toml` file and the page footer in the rendered site.

**The local site looks GREAT!**  There are no longer any issues with the footer that I can see, and [About Us](http://localhost:1313/about/) properly shows the latest development repo information.  Best of all is the appearance of `Volume VIII, Issue 1` as the "Current Issue" from Spring 2022!  So all I can say is... Keep Calm, and Carry On! 

```
^C%
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$ git push
Enumerating objects: 2271, done.
Counting objects: 100% (2269/2269), done.
Delta compression using up to 8 threads
Compressing objects: 100% (509/509), done.
Writing objects: 100% (2043/2043), 11.17 MiB | 9.76 MiB/s, done.
Total 2043 (delta 1503), reused 2042 (delta 1503), pack-reused 0
remote: Resolving deltas: 100% (1503/1503), completed with 165 local objects.
To https://github.com/Digital-Grinnell/rootstalk-DO
   6a2667b..3f252f9  main -> main
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk-DO ‹main›
╰─$
```

## The Bad News

Unlike the last time, there is NONE!  I was worried that my _DigitalOcean_ configuration still deploys to what I thought would be a defunct address, `rootstalk.grinnell.rocks`, but again that appears to do no harm because [Rootstalk](https://rootstalk.grinnell.edu) appears to be working just as it should.

## The Good News

The good news is simple... IT WORKED!  [_Rootstalk_](https://rootstalk.grinnell.edu) is now up-to-date, with the minor issue reported above, and the deployment to _DigitalOcean_ was automatic, as intended.  The message I see in my _DigitalOcean_ dashboard says:

```
Nov 07 2022
LIVE
Digital-Grinnell's deployment went live

    Trigger: Digital-Grinnell pushed 3f252f9 to Digital-Grinnell/rootstalk-DO/main

01:09:55 PM - 4m 0s build
```

And that's a wrap.  Until next time, Keep Calm, Carry On, stay safe and wash your hands! :smile:
