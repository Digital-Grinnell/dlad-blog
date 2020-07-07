---
title: Remote Atom
publishdate: 2020-07-01
draft: false
tags:
  - Atom
  - remote-atom
---

Earlier this year I installed and configured the [remote-atom](https://atom.io/packages/remote-atom) package to assist with editing content and code for my [personal blog](https://summittdweller.com/blogs/mark). Naturally, I wrote a [blog post](https://summittdweller.com/blogs/mark/posts/adding-remote-atom-to-my-digitalocean-server/) to document it.

In the past week I've added the **remote-atom** package, and configuration to many of my [Digital.Grinnell](https://digital.grinnell.edu) servers. The installation and configuration was virtually identical to what I described in [Adding remote-atom to my DigitalOcean Server](https://summittdweller.com/blogs/mark/posts/adding-remote-atom-to-my-digitalocean-server/).  Thus far the package and it's configuration have been implemented on the following workstations, both personal and professional, with the following username@server configurations:

| Workstation: MA8660 - Grinnell College iMac |
| --- |
| administrator@static |
| islandora@dgdocker1 |
| islandora@dgdockerx |
| mcfatem@dgdocker3 |

_Note:_ The `~/.ssh/config` file for the settings shown above looks like this:

```
Host static
  Hostname 132.161.151.30
  RemoteForward 52698 localhost:52698
  User administrator
Host dgdocker3
  Hostname 132.161.151.50
  RemoteForward 52698 localhost:52698
  User mcfatem
Host dgdocker1
  Hostname 132.161.132.103
  RemoteForward 52698 localhost:52698
  User islandora
Host dgdockerx
  Hostname 132.161.132.101
  RemoteForward 52698 localhost:52698
  User islandora
```

| Workstation: Mark's Mac Mini - Personal Desktop |
| --- |
| cemtos@digitalOcean |
| mcfatem@dgdocker3 |
| administrator@static |
| islandora@dgdocker1 |


And that's a wrap.  Until next time...
