---
date: 2019-05-15T19:39:57-06:00
title: Testing SSL Vulnerabilities
---

This is a subject that's grabbed my attention recently here at Grinnell College.  Specifically, I wanted a way to run my own SSL vulnerability scans of servers inside the campus firewall, something that outside agents could not do effectively.  About a month ago I came upon a tool for this task, [testssl.sh](https://github.com/drwetter/testssl.sh), and I've installed it on my Docker staging server, _DGDockerX_.

The tool resides in the _islandora_ user's home directory on _DGDockerX_ and I'm able to run it from a terminal open to that node like so:

```
cd ~/testssl.sh
./testssl.sh --help
```

As you might imagine, running the application with a `--help` flag produces a listing of all available commands.

Typically I'll do something like: `./testssl.sh static.grinnell.edu`

And that's a wrap.  Until next time...
