---
title: Easily Change GitHub User in OSX
publishDate: 2019-11-18
lastmod: 2019-11-20T10:19:07-05:00
draft: false
emojiEnable: true
tags:
  - OSX
  - GitHub
  - keychain
  - credentials
  - terminal
---

The first step is to run `git config -l` to see what the current configuration is.  If the `user.name` and/or `user.email` properties are incorrect, change them using something like this:

```
git config --global user.name "Mark McFate"
git config --global user.email "yourEMail@address.here"
```

That's only half the battle.  I love _OSX_ and the _Keychain Access_ app is wonderful, except when I'm working with _git_ and _GitHub_ in a terminal, which I do quite often. The real problem is that I have 4 different identities in _GitHub_... crazy, I know.  Changing from one identity to another has been a real pain-in-the-a$$, up until I found [this gem of a post](https://help.github.com/en/github/using-git/updating-credentials-from-the-osx-keychain).

Basically, what it tells me to do from the command line is this:

{{% original %}}
Through the command line, you can use the credential helper directly to erase the keychain entry.

To do this, type the following command:

```
git credential-osxkeychain erase
host=github.com
protocol=https
>
```
...Press `return`.

If it's successful, nothing will print out. To test that all of this works, try and clone a repository from GitHub. If you are prompted for a password, the keychain entry was deleted.
{{% /original %}}

Works like a charm!  The next `git...` command I specify, if necessary, will prompt me for my _GitHub_ username and password, and those are automatically saved until I repeat the `git credential-osxkeychain erase` command. Woot!

And that's a wrap.  Until next time...
