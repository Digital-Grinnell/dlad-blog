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

I'm going to try installing and using [GnuPG](https://www.gnupg.org/index.html) and an example command sequence I found in `Solution 2` at [https://stackoverflow.com/questions/35584461/gpg-encryption-and-decryption-of-a-folder-using-command-line](https://stackoverflow.com/questions/35584461/gpg-encryption-and-decryption-of-a-folder-using-command-line)

First, to capture the list...

```
git ls-files --others --ignored --exclude-standard > .ignored.list
```

Then we _tar_ the list of files, like so:

```
tar czf .ignored.list.tar --files-from .ignored.list
```

And finally, we use _GnuPG_ to encrypt the archive, like so:

```
gpg --encrypt --recipient summitt.dweller@gmail.com .ignored.list.tar
rm -fr .ignored.list.tar
```

This process leaves us with `.ignored.list.tar.gpg`, a secure tarball that we can safely store and restore.


#### Installing _GnuPG_ Tools

Should work nicely once I get _GnuPG_ installed and configured (see https://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/) on my Mac.  The installation should be as easy as `brew install gnupg`.

  - Completed install of _GnuPG_ as `Mark McFate <mark.mcfate@icloud.com>` on my Mac Mini.  27-Feb-2020
  - `gpg --gen-key` output is captured in my _KeePass_ vault.

  - Completed install of _GnuPG_ for `administrator` as `Summitt Dweller <summitt.dweller@gmail.com>` on `summitt-dweller-DO-docker`.  27-Feb-2020
  - Added `rng-tools` per [this very helpful post](https://delightlylinux.wordpress.com/2015/07/01/is-gpg-hanging-when-generating-a-key/)!
  - `gpg --gen-key` output is captured in my _KeePass_ vault.




And that's a break... I'll be back.  :smile:
