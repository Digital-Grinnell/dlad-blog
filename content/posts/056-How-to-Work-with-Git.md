---
title: How to Work with Git
publishDate: 2019-11-19
lastmod: 2019-11-20T15:33:19-05:00
draft: false
emojiEnable: true
tags:
  - Git
  - GitHub
  - workflow
  - fork
  - clone
  - commit
  - origin
  - upstream
---

| Credits: This document is an abstraction of some [fine documentation](https://github.com/Islandora-Collaboration-Group/ISLE/wiki/How-to-Work-with-Git) authored and posted by my [ICG](https://github.com/Islandora-Collaboration-Group) colleague and friend, [David Keiser-Clark](https://github.com/dwk2). |
| --- |


## ICG Git Workflow: How to work with Git

| The examples in this document use my work with the Islandora Collaboration Group's (ICG) [ISLE-Drupal-Build-Tools](https://github.com/Islandora-Collaboration-Group/ISLE-Drupal-Build-Tools) repository, as well as [my fork](https://github.com/Digital-Grinnell/ISLE-Drupal-Build-Tools) and local clone of that repository. |
| --- |

| I recommend having a look at the [GitHub Glossary](https://help.github.com/en/github/getting-started-with-github/github-glossary) for a list of terms used frequently in this post, and many of the referenced documents. |
| --- |
| The terms `original`, `canonical`, and `upstream` are also used in this post to describe the _GitHub_ repository at the root of the project being managed. |


| Configuration: In most cases you will do Steps 1-3 only once! If you move to a new machine execute Steps 2-3 only. |
| --- |
| Only "fork" once! Do not repeat Step 1 if you've already forked the original/canonical repo. |
| Only "clone" once! Do not repeat Step 2 if you already have a local clone of your fork. |
| Only add this remote once! Do not perform this step if your local repo already has an `upstream` remote. |


1. Always _fork_ the repo (repository) you are working on.

  - This is accomplished by logging into your _GitHub_ account and selecting __Fork__ near the top right of the repo's page.
      - Navigate your browser to the _GitHub_ project you wish to work on. Example: https://github.com/Islandora-Collaboration-Group/ISLE-Drupal-Build-Tools
      - Click the __Fork__ button near the top right of the repo's _GitHub_ page.
     - This will either create a new fork in your own _GitHub_ account, or prompt you to choose an account if you have more than one. In either case, make a note of where the fork is created! In this document we'll reference your fork's URI as `upstream`. Example: https://github.com/Digital-Grinnell/ISLE-Drupal-Build-Tools  


2. Clone your fork down to your local machine.

  - Navigate your browser to the fork.  Example: https://github.com/Digital-Grinnell/ISLE-Drupal-Build-Tools
  - Click on the __Clone__ button to copy the fork's URI to your clipboard.
  - Open terminal/shell/powershell/cmd, navigate to your preferred project "parent" directory, and `git clone <paste from clipboard>`.
  - Change into the directory (`cd`) with the files you just cloned.


3. Before you start working, add an `upstream` pointer to the original/canonical repo that you forked.

  - Navigate your browser back to the original/canonical _GitHub_ project. Example: https://github.com/Islandora-Collaboration-Group/ISLE-Drupal-Build-Tools
  - From this repo, NOT your fork or local clone, click on the __Clone__ button and copy the _https_ URI to your clipboard.
  - In terminal/shell/powershell/cmd enter `git remote add upstream <paste from clipboard>`.


| Make certain your `master` branches are even with the original/canonical `master` |
| --- |

4. STOP! Get up-to-date before you do anything, fetch your remotes so your local clone has the most recent commits.

  - Change into the directory (`cd`) with the files you cloned.
  - In terminal/shell/powershell/cmd enter `git fetch --all`.


5. Checkout and pull the `upsteam master` to your local `master` branch.

  - Checkout your master: `git checkout master`
  - Pull the `upstream` master into yours so your local is up-to-date: `git pull upstream master`
  - Push your local `master` branch BACK to your fork in _GitHub_.  
      - If all is well and your `git pull...` resulted in a fast-forward or "Already up to date.", then: `git push origin master`
      - If your `git pull...` did not fast-forward and a merge message appeared, then there were differences in your branches. Never work on `master`.


| Create an _issue_ and a topic/fix/enhancement/document _branch_ for your work, and have at! |
| --- |

6. Create an _issue_ for your work.

  - Navigate your browser to the original/canonical _GitHub_ project you wish to work on. Example: https://github.com/Islandora-Collaboration-Group/ISLE-Drupal-Build-Tools
  - Find and open the `Issues` tab (its icon is an exclamation point in a circle) near the top of the page.
  - Look through the list of all issues, both `Open` and `Closed`, for any mention of the problem you wish to solve.
      - If you find an existing issue, study it and determine if you can add your work to the existing issue.
      - If an appropriate existing issue is not found, click `New issue` to create one and describe the problem you will be attacking.
  - Take note of the new, or existing, sequential number assigned to your issue.  In subsequent steps you should refer to your issue using its number (Example: #20) in references like these examples:  `#20`, `issue-20`.


7. Create your branch and check it out.

  - Create a branch with: `git branch <helpful and identifying name>`.  Example: `git branch issue-20`
  - Checkout your new branch with `git checkout <helpful and identifying name>`. Example: `git checkout issue-20`


8. Start your work and commit locally, aka "save your work", at times (probably more than once) that feel logical.

  - Create logical checkpoints (i.e., commits) when you feel you've finished on a particular "part" of your work. Example: You've just created a new file and added some stubbed content: Commit it!
      - Commits are references in your work and can be helpful if you need to go back to an earlier version of your work, sort of like an "undo" command. By committing regularly, you give yourself utmost flexibility and it's a good practice/habit.


9. Creating commits.

   - In terminal/shell/powershell/cmd enter `git status` to see a list of files changed, added, and removed.
   - Use `git add <file>` or `git rm <file>` to stage (add or remove) files from your commit. If you want to add all files to the commit you may shorthand it with `git add -A`; the `-A` flag is short for "All".
   - Create your commit after files are staged: `git commit`. Enter a commit message that is helpful for you and us! Helpful hint: Always write in the present tense: "Update <somefile.ext> to include all of the appropriate modules."
   - Continue your work, going through _this step_ as many times as needed.

| Finalizing and preparing for a pull request (PR) |
| --- |


10. Pushing back to `origin` will update your fork in _GitHub_.

   - After your final commit and feel you're ready to PR back to the project: `git push origin <name-of-your-branch>`.
   - Visit your forked _GitHub_ repo and switch branches to your new branch.
   - Select `New pull request` (top-left) and tell _GitHub_, if it isn't already, to compare against remote branches. Select the original/canonical master first, then your repo and branch.


11. Create the pull request (PR) and send it.
    - Enter a description of what your commits do as a whole.
    - How should this be tested?
    - Who should be notified? @mention them if you know.
    - Is there anything else we should know before we review and test your work?
    - With your description complete click the `Create Pull Request` button and you're done! Thank you!


And that's a wrap.  Until next time...
