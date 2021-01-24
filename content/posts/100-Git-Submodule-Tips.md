---
title: Git Submodule Tips
date: 2021-01-24T16:50:42-06:00
draft: false
emoji: true
tags:
    - Git
    - Submodule
    - Workflow
    - Commit
---

I seem to have a never-ending struggle with **git submodules**. Today, I need to add some new features to one of my submodules in a non-ISLE project, but I've elected to post this here because this blog is relatively easy to search. I also feel fortunate to have found [this nice comprehensive resource](https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407) from [Christophe Porteneuve](https://medium.com/@porteneuve).

So, what I need to do now is update some submodule code, commit, and push that change back to its remote. I will also want to subsequentmly update a pair of projects that use the submodule so they are referencing the newest submodule code. 

In case Christophe's post ever disappers, here's the key portion that I need right now...

{{% original %}}
## Updating a Submodule Inside Container Code

  1. git submodule update —-remote —-rebase —- path/to/module
  2. cd path/to/module
  3. Local work, testing, eventually staging
  4. git commit -am “Update to central submodule: blah blah”
  5. git push
  6. cd -
  7. git commit -am “Updated submodule X to: blah blah”
    
{{% /original %}}

And that's a wrap.  Hope this helps others as much as it helped me.
