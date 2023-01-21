 ---
title: "Rebuilding ISLE for Digital.Grinnell"
publishdate: 2022-06-23
draft: false
tags:
  - ISLE
  - Digital.Grinnell
superseded_by: /posts/137-Updating-Digital.Grinnell-One-More-Time 
last_modified_at: 2023-01-20T21:54:44
---

This blog post will be used to chronicle a process I'm using to rebuild _Digital.Grinnell_ in _Legacy Islandora_ using [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE).  This process was triggered by ITS' intent to move DG's FEDORA repository to a new server.  That new server is currently mounted on node _DGDockerX_, my staging server, as `/mnt/datastage` and it contains a copy of DG's production FEDORA repository made on or about June 15, 2020.

## PORTABLE-DG

For starters I'm going be doing lots of "local" ISLE work up-front so I'm creating a USB drive backup/copy of `/mnt/datastage`.  The USB drive is named `PORTABLE-DG`.  In order to populate it I first attached the drive to my MacBook Pro (which is now woefully short on USB 'A' adapters) and started a series of `rsync` processes while that MacBook is connected to the campus network in Grinnell.

Note that I had hoped to control this process from the iMac (asset tag: 8660) that's still in my Burling office, but it's not behaving well for the last couple of weeks so that's a no-go.  

### Using _rsync_

On my MacBook Pro with an SSH connection and terminal open to _DGDockerX_ I started with this...

```
╭─mcfatem@MAC02FK0XXQ05Q ~
╰─$ cd /Volumes/PORTABLE-DG/FEDORA
╭─mcfatem@MAC02FK0XXQ05Q /Volumes/PORTABLE-DG/FEDORA
╰─$ rsync -aruvi islandora@dgdockerx.grinnell.edu:/mnt/datastage/datastreamStore . --progress
```

That operation completely tied up my MacBook Pro, so once I got control of my iMac again I moved `PORTABLE-DG` over there, opened a `Screen Sharing` connection to the iMac... and died a little (more) inside.   While I can open the `Screen Sharing` connection again, presumably because both Macs are on campus Ethernet, the iMac won't even recognize the USB drive.  So, I might as well be back home where systems and peripherals all work... sometimes very slowly.  

So I need two things from the same machine... a FAST connection to campus network storage, and a working large-capacity external drive.  The only way I can get that now is via my MacBook Pro, sitting in my office with an Ethernet connection, and `PORTABLE-DG` plugged into it.  Problem is I can't use the MacBook Pro for ANYTHING else while this is running, and I can't disconnect it for as long as the `rsync` operations take... and that could be a couple of days.

If I go home with the MacBook Pro it will mean pulling almost 1 TB of data from campus storage over my internet connection at home, and that could easily take a week.


---

And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
