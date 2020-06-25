---
title: "Debugging SSH Login Issues"
publishdate: 2020-05-06
draft: false
tags:
  - ssh
  - sshd
  - ssh-keygen
  - ssh-copy-id
---

Lately my passwordless, SSH logins to all my servers have quit working, at least they seem to have stopped working from the only accessible "work" workstation that I have at the moment, _MA7053_. Since our enterprise malware mitigation agent, _Traps_, is blocking my access to my "real" workstation, _MA8660_, this has become more than just a nuisance.

So here's what I came up with as a process to try and determine exactly where the problems are...

## To Debug SSHD Issues with Key Logins

From a terminal opened in the target (CentOS 7 in this example) server:

```
sudo su
# stop the sshd service
systemctl stop sshd.service
# as root, restart the sshd service in DEBUG mode.  Note that your terminal will NOT return, it's spooling debug output
/usr/sbin/sshd -d
# attempt to connect again and look for DEBUG output in your terminal window
# once resolved, ctrl-c to kill the above process, then be sure to restart sshd like so:
systemctl start sshd.service
```

## To Create and Engage a New SSH Key

  - On your *local* workstation open a terminal and enter the following with defaults and NO password or phrase:
    - ssh-keygen
  - Next, using the `islandora` user at `dgdocker1.grinnell.edu` as an example, enter the following to copy the key to the target server:
    - ssh-copy-id -i ~/.ssh/id_rsa islandora@dgdocker1.grinnell.edu


And that's a wrap.  Until next time...
