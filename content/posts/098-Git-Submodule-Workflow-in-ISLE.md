---
title: Git Submodule Workflow in ISLE
date: 2020-12-07T18:23:02-06:00
draft: false
emoji: true
tags:
    - Git
    - Submodule
    - Workflow
    - ISLE
---

In the past few days I've attempted to update the "staging" copy of _Digital.Grinnell_ at [https://dg-staging.grinnell.edu](https://dg-staging.grinnell.edu) and learned a valuable lesson regarding workflow around _Git_ and _submodules_. Specifically, I found the following resource to be most helpful:

  - [https://intellipaat.com/community/9971/git-update-submodule-to-latest-commit-on-origin](https://intellipaat.com/community/9971/git-update-submodule-to-latest-commit-on-origin)

In case that post ever disappers, here's the gist of it...

{{% original %}}
The `git submodule update` command actually tells git that you simply want your submodules to each check out the commit already mentioned in the index of the superproject.

If you want to update your submodules to the most recent commit available from their remote, you'll try this directly within the submodules.

So in summary:

    # Get the submodule initially
    git submodule add ssh://bla submodule_dir
    git submodule init
    # Time passes, submodule upstream is updated
    # and you now want to update
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


Or, if you're a busy person:

    git submodule foreach git pull origin master

{{% /original %}}

And that's a... break.  When I return I hope to add some DG specifics.
