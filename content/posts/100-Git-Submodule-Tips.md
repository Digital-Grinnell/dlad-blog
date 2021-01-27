---
title: Git Submodule Tips
date: 2021-01-27T12:10:25-06:00
publishdate: 2021-01-25
draft: false
emoji: true
tags:
    - Git
    - Submodule
    - Workflow
    - Commit
---

I seem to have a never-ending struggle with **git submodules**. Today, I need to add some new features to one of my submodules in a non-ISLE project, but I've elected to post this here because this blog is relatively easy to search. I also feel fortunate to have found [Mastering Git Submodules](https://medium.com/@porteneuve/mastering-git-submodules-34c65e940407) from [Christophe Porteneuve](https://medium.com/@porteneuve).

So, what I need to do now is update some submodule code, commit, and push that change back to its remote. I will also want to subsequentmly update a pair of projects that use the submodule so they are referencing the newest submodule code.

In case Christophe's post ever disappers, here's the key portion that I need right now...

{{% original %}}
## Updating a Submodule Inside Container Code

  1. git submodule update --remote --rebase -- path/to/module
  2. cd path/to/module
  3. Local work, testing, eventually staging
  4. git commit -am "Update to central submodule: blah blah"
  5. git push
  6. cd -
  7. git commit -am "Updated submodule X to: blah blah"

{{% /original %}}

## Updating a Project To Use Latest Submodule Code

Shortly after updating my submodule code and pushing that to _GitHub_, I naturally wanted to update one or two of my projects to use that latest version of the submodule.  Hmmm, what's the best way to do that?  Luckily I found [this reply](https://intellipaat.com/community/9971/git-update-submodule-to-latest-commit-on-origin?show=19616#a19616) and the guidance there worked nicely.  In case the post or reply is ever lost, here's the important parts:

{{% original %}}
The git submodule update command actually tells git that you simply want your submodules to each check out the commit already mentioned in the index of the superproject.

If you want to update your submodules to the most recent commit available from their remote, you'll try this directly within the submodules.

So in summary:

  ```
  # Get the submodule initially
  git submodule add ssh://bla submodule_dir
  git submodule init
  # Time passes, submodule upstream is updated and you now want to update
  # Change to the submodule directory
  cd submodule_dir
  # Checkout desired branch
  git checkout master
  # Update
  git pull
  # Get back to your project root
  cd...
  # now the submodules are in the state you wanted, so
  git commit -am "Pulled down update to submodule_dir"
  ```
{{% /original %}}

And that's a wrap.  Hope this helps others as much as it helped me.
