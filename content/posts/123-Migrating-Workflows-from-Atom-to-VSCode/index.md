 ---
title: "Migrating Workflows from Atom to VSCode"
publishdate: 2022-06-09
draft: false
tags:
  - Atom
  - VSCode
  - workflow
supersedes: posts/085-remote-atom/
---

This might just be my shortest post ever in this blog, at least for now.  At this early date it's just a link to the [Atom No More?](https://blog.summittdweller.com/posts/2022/06/atom-no-more/) blog post in my personal blog.

The note above indicates that this post superseeds `085-remote-atom`, but there are other _Atom_-related posts that are also impacted.

Some of these include:

  - [posts/033-adding-lastmod-date/](posts/033-adding-lastmod-date/)


As time passes I'll document here any work-specific changes I make to my new _VSCode_ environments. 

## Replacing `atom .` with `code .`

The personal blog post mentioned above, [Atom No More?](https://blog.summittdweller.com/posts/2022/06/atom-no-more/), includes a procedure I used to implement `code .` to launch _VSCode_ from a terminal window on any of my Mac workstations.  As of this writing, June 22, 2022, I have successfully implmented this change on all of my Grinnell College workstations.

## Replacing Remote Atom

Some time ago I documented my setup of [Remote Atom](posts/085-remote-atom/) which gave me the ability to type open an SSH tunnel from any workstation to a remote Linux host, like _DGDocker1_ or _DGDockerX_, and locally use my _Atom_ editor to make and save changes to individual files remotely.  The command was simple, `ratom <filename>` would do the trick.

_VSCode_ can be setup to do the same kind of thing and I'm following guidance at [Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh) to do just that, starting with _DGDockerX_, the Docker node where we build and run the _staging_ version of Digital.Grinnell.

It works, and the setup was easier than with _Atom_, and perhaps better in the end?  We shall see, but so far it's looking very good.

### DGDockerX

To begin this process I installed the necessary [Remote Development extemsion pack](https://aka.ms/vscode-remote/download/extension).  That was easy.  Next, I opened my VPN connection to campus, as required for SSH, and then inside _VSCode_ I did as I was told...

  - `⇧⌘P` to open the command pallet,
  - entered `Remote-SSH: Connect to Host...` to initiate the command,
  - selected `Add New SSH Host...`, and
  - added _DGDockerX_ using `ssh islandora@dgdockerx.grinnell.edu -A`

When prompted to save the above confituration I did so into my workstation's `~/.ssh/config` file.  Now, to open a new connection to _DGDockerX_ I just repeat the first two steps above, then pick `dgdockerx.grinnell.edu` from the list provided.  That's it.  Once that is done I can open the _VSCode_ explorer and navigate through the remote host as needed.

### DGDocker1

The process was exactly as above, so now when I want to edit files on _DGDocker1_, I just do this in _VSCode_...

  - `⇧⌘P` to open the command pallet,
  - entered `Remote-SSH: Connect to Host...` to initiate the command,
  - select `dgdocker1.grinnell.edu` from the pull-down list that's presented.
  
---

And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
