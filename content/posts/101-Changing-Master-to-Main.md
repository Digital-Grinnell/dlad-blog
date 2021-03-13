---
title: Changing Master to Main
date: 2021-01-26T11:04:43-06:00
publishdate: 2021-01-25
draft: false
emoji: true
tags:
    - Git
    - master
    - main
    - inclusive
---

In hindsight, this really should have been post number 100 in the blog, or perhaps it should have happened even earlier. In any event it's high-time I made this move and captured the process.  In June 2020 the good folks at _GitHub_ announced that they would begin removing references to _master_ as a small step forward in removing divisive language in tech. The change dictates that the default branch name of future repositories should be **main** in place of _master_. 

Today, I am dictating that the same should be true for **ALL** of my repositories, old and new alike.  Besides, I find it very confusing to have some defaults using one name while others do not.  To begin this transformation of old to new, I elected to start here with [this blog](https://static.grinnell.edu/blogs/McFateM).

## Moving `master` to `main`
In support of this effort I went looking for sound guidance and found [5 steps to change GitHub default branch from master to main](https://stevenmortimer.com/5-steps-to-change-github-default-branch-from-master-to-main/).  In case that post ever disappears, here are the key elements:

{{% original %}}

All commands

```
# Step 1 
# create main branch locally, taking the history from master
git branch -m master main

# Step 2 
# push the new local main branch to the remote repo (GitHub) 
git push -u origin main

# Step 3
# switch the current HEAD to the main branch
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main

# Step 4
# change the default branch on GitHub to main
# https://docs.github.com/en/github/administering-a-repository/setting-the-default-branch

# Step 5
# delete the master branch on the remote
git push origin --delete master
```

{{% /original %}}

## If `main` Already Exists

In cases, like this blog, where a `main` branch already exists, a couple of preemptive steps must be taken.  I found some useful and brief [TL;DR version](https://www.freecodecamp.org/news/how-to-delete-a-git-branch-both-locally-and-remotely/) guidance, and here again are the key parts:

{{% original %}}
TL;DR version

```
// delete branch locally
git branch -d localBranchName

// delete branch remotely
git push origin --delete remoteBranchName
```

{{% /original %}}

And that's a wrap.  Until next time, I hope this encourages others to take similar action.
