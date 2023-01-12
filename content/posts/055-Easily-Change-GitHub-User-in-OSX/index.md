---
title: Easily Change GitHub User in OSX
publishDate: 2019-11-18
lastmod: 2020-08-26T13:16:40-05:00
draft: false
emojiEnable: true
tags:
  - OSX
  - GitHub
  - user
  - login
  - keychain
  - credentials
  - terminal
---

The first step is to run `git config -l` to see what the current configuration is.  If the `user.name` and/or `user.email` properties are incorrect, change them using something like this:

```
git config --global user.name "Mark McFate"
git config --global user.email "yourEMail@address.here"
```

That's only half the battle.  I love _OSX_ and the _Keychain Access_ app is wonderful, except when I'm working with _git_ and _GitHub_ in a terminal, which I do quite often. The real problem is that I have 4 different identities in _GitHub_... crazy, I know.  Changing from one identity to another has been a real pain-in-the-a$$, up until I found [this gem of a post](https://docs.github.com/en/github/using-git/updating-credentials-from-the-osx-keychain#updating-your-credentials-via-keychain-access).

Basically, what it tells me to do from the _Keychain Access_ app is this:

  1) In Finder, search for the _Keychain Access_ app.
  2) In _Keychain Access_, search for github.com.
  3) Find the "internet password" entry for github.com.
  4) Edit or delete the entry accordingly.

Works like a charm!  The next `git...` command I specify, if necessary, will prompt me for my _GitHub_ username and password -- or more appropriately, my `Personal Access Token`, since I now have 2-factor authentication enabled -- and those are automatically saved until I repeat the above process. Woot!

And that's a wrap.  Until next time...
