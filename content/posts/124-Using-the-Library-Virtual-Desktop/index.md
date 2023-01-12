 ---
title: "Using the Library Virtual Desktop"
publishdate: 2022-06-16
draft: false
tags:
  - Virtual Desktop
  - VDI
  - Universal Control
---

A couple of months ago the `Screen Sharing` connection to the iMac in my campus office stopped working, presumably because ITS no longer allowed that connection.  No matter, rather than working to get that restored I thought I'd dry using a `Virtual Desktop` connection to a Windows VM.  I also had some need to work with Windows in other capacities so this seemed like a nice dual-purpose solution.  It worked!  Now I'm trying to remember and document how it works.  

So, I've learned that I can connect to my virtual desktop in one of two ways, with or without VPN.

## Without VPN

To open my virtual desktop without a VPN connection I simply have to visit [https://remotehorizon.grinnell.edu](https://remotehorizon.grinnell.edu) and login using my usual GC credentials.  I haven't fully tested yet, but I don't think this link will work if I am on the VPN at the time.

The really nice thing about this is that I can use Apple's new [Universal Control](https://support.apple.com/en-us/HT212757) feature to share my mouse and keyboard across multiple devices, _but only when not using the VPN!_

## With a VPN Connection

To open my virtual desktop with an active VPN connection I simply have to visit [https://horizon.grinnell.edu](https://horizon.grinnell.edu) and login using my usual GC credentials.  I have verified that this link does NOT work if VPN is not active.

## Documentation

I haven't perused it all, yet, but there is helpful guidance available [in Sharepoint](https://grinco.sharepoint.com/sites/IT/Support%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FIT%2FSupport%20Documents%2FConnecting%20to%20Virtual%20Workstations%20and%20Lab%2Epdf&parent=%2Fsites%2FIT%2FSupport%20Documents).  

## Choosing the `Library` VDI

When _horizon.grinnell.edu_ or _remotehorizon.grinnell.edu_ opens in our browser we should see a window like this:

{{% figure title="VDI Client Window" src="/images/post-124/vdi-client-window.png" %}} 

In that window we simply click on the `Library` VM icon since it is our only choice.  

## Connecting to _DGDocker1_

The `Library` selection above opens a Windows desktop where I typically search for `terminal`, or just `term`, in the provided _Search_ box.  That search should return a link to the Windows `Command Prompt` application which I then use to login to host _DGDocker1_ as user _islandora_, like so:

{{% figure title="Windows Command Prompt Login to DGDocker1" src="/images/post-124/windows-command-prompt.png" %}} 

In the `Command Prompt` the following sequence of `docker` and `drush` commands is typical:

{{% figure title="Running an _ihcQ_ Report" src="/images/post-124/ihcQ-command.png" %}} 

---

And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
