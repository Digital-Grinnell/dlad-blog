---
title: Archiving What Git Ignores
publishdate: 2020-02-26
lastmod: 2020-02-26T14:32:54-06:00
draft: false
tags:
  - GitHub
  - Git
  - .gitignore
  - gzip
  - archive
---

I love _git_ and _GitHub_, and I can certainly appreciate the usefullness of _.gitignore_, but there are times when I'd really like to move an ENTIRE project to a new home.  I have in my head a process that might play out like this...

  1. Fetch a list of all the files and directories that _.gitignore_ is ignoring.
  2. Pass that list to a _tar_ or _gzip_ command (maybe two of them) **with encryption** to create a secure, compressed archive.
  3. Commit the archive to the project repo in _GitHub_.

### Step 1

Ok, the first step looks pretty easy.  According to [this _StackOverflow_ answer](https://stackoverflow.com/a/1446609) we can use one or two _git_ commands to do the trick, specifically:

```
git ls-files --others --ignored --exclude-standard
git ls-files --others --ignored --exclude-standard --directory
```

The first command above lists all the ignored files, and the second one lists all the ignored directories.

### Step 2

I'm going to try installing and using [GnuPG](https://www.gnupg.org/index.html) and the [gpgtar command](https://www.gnupg.org/documentation/manuals/gnupg/gpgtar.html) to create a password-protected (encrypted) compressed _tar_ archive from our list.  First, to capture the list...

```
git ls-files --others --ignored --exclude-standard > .ignored.list
```

Then we _tar_ the list of files with encryption, like so:

```
gpgtar --encrypt --files-from .ignored.list --output .secured.ignored.list.tar
```

Should work nicely once I get _GnuPG_ installed and configured (see https://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/) on my Mac.  The installation should be as easy as `brew install gnupg`.


And that's a break... I'll be back.  :smile:
