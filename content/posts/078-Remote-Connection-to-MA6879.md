---
title: "Remote Connection to MA6879"
publishdate: 2020-06-02
draft: false
tags:
  - MA6879
  - Mac Mini
  - Screens 4
  - remote
  - vnc
---
_MA6879_ is the tag ID of the Mac Mini student-workstation in my _Grinnell College_ office in Burling Library. During the COVID-19 pandemic it's the only Mac that I have access to on campus. But the Macs here in my home office are not allowed to run [Screens 4](https://edovia.com/en/screens-mac/), the software that I formerly used to make remote connections between Macs.  Fortunately, since the IP address of _MA6879_ is "static" and known (by me!), I can use built-in tools to make my screen-share and remote-control connections.

There are at least two ways to make a connection.

## Using VNC

To make a connection I can use [vnc](https://en.wikipedia.org/wiki/Virtual_Network_Computing) as described in the second half of [https://helpdesk.owu.edu/networking/other-networking-information/mac2mac/](https://helpdesk.owu.edu/networking/other-networking-information/mac2mac/). Have a look.

### Pertinent Text

In case the link is ever lost, here's what it says, verbatim...

>On the machine you'll be remotely connecting from:
>
>  1. Make sure you're in Finder (it says "Finder" next to the apple icon at top left. You can click on the desktop to go to finder or Command+Tab to get to Finder.
>  2. Select Connect to Server from the Go menu.
>  3. In the Server Address field type in the IP address of your remote computer preceded by "vnc:" as it appeared in Screen Sharing above.
>  4. Click the Connect button and it will open the remote desktop in a new window. You will have control over the keyboard and mouse as if you were sitting down at that computer.
>  5. When you're done, simply close that window.
>  6. To access files and folders on the remote computer select Go to Folder from the Go menu.
>  7. Type in the IP address of the computer you wish to connect to preceded with "afp:" as it appeared in File Sharing above.
>  8. Click the Go button and the folders you have access to on the remote computer will open in a new Finder window.
>  9. When you're done, simply close that window.

## Using "Screen Sharing"

Tim, my esteemed _Grinnell College_ colleague, also reminds me that it should be possible to open the _Screen Sharing.app_ application using _Spotlight Search_ (Command + Spacebar).  That app opens a simple dialog like this example:

![Screen Sharing.app Dialog](/images/post-078/ScreenSharing.app-2020-06-02.png "Screen Sharing.app Dialog")

You simply enter the network alias or IP address of the Mac you want to control, and click `Connect`.


And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
