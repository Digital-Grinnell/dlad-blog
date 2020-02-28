---
title: Archiving What Git Ignores
publishdate: 2020-02-26
lastmod: 2020-02-27T15:14:56-06:00
draft: false
tags:
  - GitHub
  - git
  - ls-files
  - .gitignore
  - archive
  - GnuPG
  - gpg
---

I love _git_ and _GitHub_, and I can certainly appreciate the usefullness of _.gitignore_, but there are times when I'd really like to move an ENTIRE project to a new home.  I have in my head a process that might play out like this...

  1. Fetch a list of all the files and directories that _.gitignore_ is ignoring.
  2. Pass that list to a _tar_ or _gzip_ command (maybe two of them) **with encryption** to create a secure, compressed archive.
  3. Commit the archive to the project repo in _GitHub_, or keep it in a safe place for restoration in the future.
  4. Navigate in your terminal to a target and restore the archive using the

### Step 1

Ok, the first step looks pretty easy.  According to [this _StackOverflow_ answer](https://stackoverflow.com/a/1446609) we can use one or two _git_ commands to do the trick, specifically:

```
git ls-files --others --ignored --exclude-standard
git ls-files --others --ignored --exclude-standard --directory
```

The first command above lists all the ignored files, and the second one lists all the ignored directories.

### Step 2

I'm going to try installing and using [GnuPG](https://www.gnupg.org/index.html) and an example command sequence I found in `Solution 2` at [https://stackoverflow.com/questions/35584461/gpg-encryption-and-decryption-of-a-folder-using-command-line](https://stackoverflow.com/questions/35584461/gpg-encryption-and-decryption-of-a-folder-using-command-line)

First, we capture the list of "ignored" files, then we _tar_ it, then apply a _GnuPG_ encryption, then remove the intermediate, unsecure artifact, like so:

```
git ls-files --others --ignored --exclude-standard > $(date --iso-8601).ignored.list
tar czvf $(date --iso-8601).ignored.list.tar.gz --files-from $(date --iso-8601).ignored.list
gpg --encrypt --recipient summitt.dweller@gmail.com $(date --iso-8601).ignored.list.tar.gz
rm -fr $(date --iso-8601).ignored.list.tar.gz
```

This process leaves us with `<today>.ignored.list.tar.gz.gpg`, a secure tarball that we can safely store and restore.

### Step 3

Not much to elaborate on here... just keep that archive safe.  Unfortunately, in the case of my `wieting-D8-DO` the archive is something north of 270 MB, way too big for _GitHub_.

### Step 4 - Restoring a GPG Archive, As Needed

Copy the `<date>.ignored.list.tar.gz` file to your target/parent directory, presumably the same directory that the files were captured from originally, and run this sequence, substituting the datestamp prefix of the `.gpg` filename in place of `<date>`.

```
gpg --decrypt <date>.ignored.list.tar.gz.gpg > ignored.list.tar.gz
tar xzvf ignored.list.tar.gz
rm -f ignored.lists.tar.gz *.ignored.list.tar.gz.gpg
```

#### Installing _GnuPG_ Tools

Should work nicely once I get _GnuPG_ installed and configured (see https://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/) on my Mac.  The installation should be as easy as `brew install gnupg`.

  - Completed install of _GnuPG_ as `Mark McFate <mark.mcfate@icloud.com>` on my Mac Mini.  27-Feb-2020
  - `gpg --gen-key` output is captured in my _KeePass_ vault.

  - Completed install of _GnuPG_ for `administrator` as `Summitt Dweller <summitt.dweller@gmail.com>` on `summitt-dweller-DO-docker`.  27-Feb-2020
  - Added `rng-tools` per [this very helpful post](https://delightlylinux.wordpress.com/2015/07/01/is-gpg-hanging-when-generating-a-key/)!
  - `gpg --gen-key` output is captured in my _KeePass_ vault.

## Does This Really Work?

Why yes, yes it does.  The proof is in the pudding, or in this case, it's in a post I just pushed to my personal blog, specifically: [Updating the Wieting Site in Drupal 8](https://summittdweller.com/blogs/mark/posts/updating-the-wieting-site-in-drupal-8/).  Check it out.


And that's a break... I'll be back.  :smile:
