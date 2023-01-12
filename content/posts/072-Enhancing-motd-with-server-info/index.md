---
title: "Enhancing 'motd' with 'server-info'"
publishdate: 2020-05-05
draft: false
tags:
  - motd
  - server-info
  - mdv
  - figlet
---

My memory isn't what it used to be, but I have this blog. :smile: And on the handful of CentOS and Ubuntu servers that I maintain, I have my  [_server-info_](https://github.com/McFateM/server-info) script, my replacement for [_motd_]('https://en.wikipedia.org/wiki/Motd_(Unix)'). :grin:

## Requirements: _mdv_ and _figlet_

The _server-info_ script/command relies on a pair of utilities, namely [_mdv_](https://github.com/axiros/terminal_markdown_viewer) and [_figlet_](http://www.figlet.org/).

## The _server-info_ Script

You'll find the script itself in [this gist](https://gist.github.com/McFateM/98a3247a388b826a16c7f985e1d0351c).  Sample installation of the script is documented below, and the content template can be found in [this gist](https://gist.github.com/McFateM/8a81e74be780697cf8ab6e63a707052f).

## Sample Installation on DGDocker3, a CentOS 7 Host

[DGdocker3.Grinnell.edu](https://dgdocker3.grinnell.edu) is a _CentOS 7 / Docker_ server that I use for development and testing at _Grinnell College_. This is what I did on _DGDocker3_ to install my _server-info_ command:

```
sudo yum update
sudo yum install epel-release
sudo yum install figlet
sudo yum install python-pip
sudo pip install --upgrade pip
sudo pip install mdv
```

Then, to "install" the initial script and content template...

```
sudo su
cd /usr/local/bin
curl https://gist.githubusercontent.com/McFateM/8a81e74be780697cf8ab6e63a707052f/raw > server-info
chmod 755 server-info
cd /etc
curl https://gist.githubusercontent.com/McFateM/98a3247a388b826a16c7f985e1d0351c/raw > server-info.md
```

## Sample Installation in Ubuntu

[mcfate.family](https://mcfate.family) is a domain I currently use for testing, and right now (May 2020) it's pointed at an _Ubuntu 18.04 LTS_ droplet at _DigitalOcean_. This is what I did on that host, as _root_, to install my _server-info_ command:

```
apt-get update
apt-get install figlet
apt install python-pip
pip install mdv
```

Then, to "install" the initial script and content template, again as _root_...

```
cd /usr/local/bin
curl https://gist.githubusercontent.com/McFateM/8a81e74be780697cf8ab6e63a707052f/raw > server-info
chmod 755 server-info
cd /etc
curl https://gist.githubusercontent.com/McFateM/98a3247a388b826a16c7f985e1d0351c/raw > server-info.md
```

## Use

So, how's it used?  Simple, just enter `server-info` at any command prompt on the host.

## Updating the Maintenance Information

That's easy too, just use `sudo nano /etc/server-info.md` and apply your changes/additions, then save the file.


And that's a wrap.  Until next time... :smile:
