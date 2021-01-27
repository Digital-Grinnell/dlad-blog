---
title: "Debugging SSH Login Issues"
publishdate: 2020-05-06
date: 2021-01-26T20:15:43-06:00
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

## My `DGAdmin` Experience

Today, January 26, 2021, I set out to configure a new server, namely `dgadmin.grinnell.edu`.  After I'd done all of the above to set the server up for `ssh/pubkey` authentication it still would not work. I subsequently opened a help ticket and my esteemed colleague, Mike Conner, came to my rescue.  Mike's response to my ticket included this:

{{% original %}}
Is the private key corresponding to the public key in /home/administrator/.ssh/authorized_keys loaded in your ssh-agent?
You can specify which private key to use for the connection using the -i flag:

  `ssh -i /path/to/id_rsa administrator@dgadmin.grinnell.edu`

You can also debug using the verbose flag in your ssh command:

  `ssh -i /path/to/id_rsa -vvv administrator@dgadmin.grinnell.edu`
{{% /original %}}

Mike hit the nail on the head, my ssh-agent must have been using a diffeent pubkey.  I executed the command that Mike had suggested and it worked.  Specifically that command was:


```
ssh -i ~/.ssh/id_rsa -vvv administrator@dgadmin.grinnell.edu
```

### Extras Are No Longer Necessary

After the above command logged me in without a password I ran one more test.  Would I always need to run my `ssh` commands in that form?  No, I found that once I had run that command successfully the ssh-agent remembers the correct pubkey to use so subsequent logins can use just `ssh administrator@dgadmin.grinnell.edu`.

And that's a wrap.  Until next time...
