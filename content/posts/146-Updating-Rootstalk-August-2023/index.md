---
title: "Updating Rootstalk - August 2023" 
publishDate: 2023-08-15T09:57:57-05:00
last_modified_at: 2023-09-13T13:58:51
draft: false
description: Documents the process used to update _Rootstalk_, in development and production, in August (and September) 2023 with the publication of content from the Spring 2023 term as Volume IX, Issue 1.  
tags:
  - Rootstalk
  - NPM
  - proofreading
azure:
  dir: 
  subdir: 
---  

In this document I will attempt to capture the ordered steps required to publish a new "issue" of _Rootstalk_ in it's newest environment.  

The development of this blog post, and modifications to the https://github.com/Digital-Grinnell/rootstalk-issue-workflow repo, took place on my personal Mac Mini while simultaneous work on _Rootstalk_ was completed in the `~/GitHub/npm-rootstalk` AND `~/GitHub/rootstalk-issue-workflow`<sup>*</sup> local repositories on my Grinnell College MacBook Pro.  The two machines shared a single keyboard and mouse, plus copy/paste capabilities, via Universal Control.  

<sup>*</sup>Note that work in `~/GitHub/roostalk-issue-workflow` must be completed on my GC-issued MacBook Pro as access to `InDesign` is only available on that college-owned machine.  

# Following (and Modifying) the Documented Workflow 

Following the [Rootstalk New Issue Workflow](https://github.com/Digital-Grinnell/rootstalk-issue-workflow#readme) is the **KEY** to making this happen as smoothly as possible.  Since _Rootstalk_ has a new NPM wrapper it will probably be necessary to modify that document to reflect changes required by NPM.  

_Note that the effort documented here was interrupted by many things, including a week of COVID-19, and subsequently pushed from August into September 2023._  

# Working Locally With the [npm-rootstalk](https://github.com/Digital-Grinnell/npm-rootstalk) Repo

Rather than repeating a lot of documenation here, I'll simply mention that the `README.md` file in the [npm-rootstalk](https://github.com/Digital-Grinnell/npm-rootstalk) repo has been updated to reflect the latest/greatest development and production workflows.  A great deal of that document has been deemed obsolete but it remains visible to authorized project developers nonetheless.  

# Update - Automated Proofreading

_Rootstalk_ really needs an updated run of `htmlproofer` so I started re-visiting that tool by reading https://static.grinnell.edu/dlad-blog/posts/133-automated-proofreading-with-htmlproofer/#first-an-updated-install.  I subsequently found a `~/GitHub/html-proofer-3.19.3` diretory on my Grinnell College MacBook, but I found that I could not run the `htmlproofer` command there as I witnessed the following...

```bash
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
╰─$ htmlproofer -v
rbenv: htmlproofer: command not found

The `htmlproofer' command exists in these Ruby versions:
  3.0.2
```

So, following the workflow documented in [First, An Updated Install](https://static.grinnell.edu/dlad-blog/posts/133-automated-proofreading-with-htmlproofer/#first-an-updated-install) went like this...

```bash
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
╰─$ gem install html-proofer  
Fetching zeitwerk-2.6.11.gem
Fetching yell-2.2.2.gem
Fetching ethon-0.16.0.gem
Fetching typhoeus-1.4.0.gem
Fetching rainbow-3.1.1.gem
Fetching ttfunk-1.7.0.gem
Fetching ruby-rc4-0.1.5.gem
Fetching hashery-2.1.2.gem
Fetching Ascii85-1.1.0.gem
Fetching afm-0.2.2.gem
Fetching pdf-reader-2.11.0.gem
Fetching nokogiri-1.15.4-arm64-darwin.gem
Fetching timers-4.3.5.gem
Fetching io-event-1.3.2.gem
Fetching fiber-annotation-0.2.0.gem
Fetching fiber-local-1.0.0.gem
Fetching html-proofer-5.0.8.gem
Fetching console-1.23.2.gem
Fetching async-2.6.4.gem
Successfully installed zeitwerk-2.6.11
Successfully installed yell-2.2.2
Successfully installed ethon-0.16.0
Successfully installed typhoeus-1.4.0
Successfully installed rainbow-3.1.1
Successfully installed ttfunk-1.7.0
Successfully installed ruby-rc4-0.1.5
Successfully installed hashery-2.1.2
Successfully installed Ascii85-1.1.0
Successfully installed afm-0.2.2
Successfully installed pdf-reader-2.11.0
Successfully installed nokogiri-1.15.4-arm64-darwin
Successfully installed timers-4.3.5
Building native extensions. This could take a while...
Successfully installed io-event-1.3.2
Successfully installed fiber-annotation-0.2.0
Successfully installed fiber-local-1.0.0
Successfully installed console-1.23.2
Successfully installed async-2.6.4
Successfully installed html-proofer-5.0.8
Parsing documentation for zeitwerk-2.6.11
Installing ri documentation for zeitwerk-2.6.11
Parsing documentation for yell-2.2.2
Installing ri documentation for yell-2.2.2
Parsing documentation for ethon-0.16.0
Installing ri documentation for ethon-0.16.0
Parsing documentation for typhoeus-1.4.0
Installing ri documentation for typhoeus-1.4.0
Parsing documentation for rainbow-3.1.1
Installing ri documentation for rainbow-3.1.1
Parsing documentation for ttfunk-1.7.0
Installing ri documentation for ttfunk-1.7.0
Parsing documentation for ruby-rc4-0.1.5
Installing ri documentation for ruby-rc4-0.1.5
Parsing documentation for hashery-2.1.2
Installing ri documentation for hashery-2.1.2
Parsing documentation for Ascii85-1.1.0
Installing ri documentation for Ascii85-1.1.0
Parsing documentation for afm-0.2.2
Installing ri documentation for afm-0.2.2
Parsing documentation for pdf-reader-2.11.0
Installing ri documentation for pdf-reader-2.11.0
Parsing documentation for nokogiri-1.15.4-arm64-darwin
Installing ri documentation for nokogiri-1.15.4-arm64-darwin
Parsing documentation for timers-4.3.5
Installing ri documentation for timers-4.3.5
Parsing documentation for io-event-1.3.2
Installing ri documentation for io-event-1.3.2
Parsing documentation for fiber-annotation-0.2.0
Installing ri documentation for fiber-annotation-0.2.0
Parsing documentation for fiber-local-1.0.0
Installing ri documentation for fiber-local-1.0.0
Parsing documentation for console-1.23.2
Installing ri documentation for console-1.23.2
Parsing documentation for async-2.6.4
Installing ri documentation for async-2.6.4
Parsing documentation for html-proofer-5.0.8
Installing ri documentation for html-proofer-5.0.8
Done installing documentation for zeitwerk, yell, ethon, typhoeus, rainbow, ttfunk, ruby-rc4, hashery, Ascii85, afm, pdf-reader, nokogiri, timers, io-event, fiber-annotation, fiber-local, console, async, html-proofer after 3 seconds
19 gems installed
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
```

And following that...  

```bash
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
╰─$ htmlproofer -v
5.0.8
```

...which looks good!  So from there the process was...

```bash
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
╰─$ cd npm-rootstalk
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/npm-rootstalk ‹main›
╰─$ ll
total 184
-rw-r--r--   1 mcfatem  1278142703   1.1K Aug 18 09:19 LICENSE
-rw-r--r--   1 mcfatem  1278142703    16K Aug 30 11:33 README.md
drwxr-xr-x   3 mcfatem  1278142703    96B Aug 18 09:19 archetypes
-rw-r--r--   1 mcfatem  1278142703   3.0K Aug 18 09:19 config.yml
drwxr-xr-x  12 mcfatem  1278142703   384B Aug 18 09:19 content
drwxr-xr-x   7 mcfatem  1278142703   224B Aug 18 09:19 layouts
-rw-r--r--   1 mcfatem  1278142703    64K Aug 18 09:19 package-lock.json
-rw-r--r--   1 mcfatem  1278142703   937B Aug 18 09:19 package.json
drwxr-xr-x  29 mcfatem  1278142703   928B Aug 23 12:00 public
drwxr-xr-x   3 mcfatem  1278142703    96B Aug 18 09:20 resources
drwxr-xr-x   9 mcfatem  1278142703   288B Aug 18 09:20 static
drwxr-xr-x   3 mcfatem  1278142703    96B Aug 18 09:19 themes
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/npm-rootstalk ‹main›
╰─$ hugo
Start building sites …
hugo v0.112.7+extended darwin/arm64 BuildDate=unknown

                   | EN
-------------------+------
  Pages            | 431
  Paginator pages  |   0
  Non-page files   |   6
  Static files     | 632
  Processed images |   0
  Aliases          |   0
  Sitemaps         |   1
  Cleaned          |   0

Total in 489 ms
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/npm-rootstalk ‹main›
╰─$ ll
total 184
-rw-r--r--   1 mcfatem  1278142703   1.1K Aug 18 09:19 LICENSE
-rw-r--r--   1 mcfatem  1278142703    16K Aug 30 11:33 README.md
drwxr-xr-x   3 mcfatem  1278142703    96B Aug 18 09:19 archetypes
-rw-r--r--   1 mcfatem  1278142703   3.0K Aug 18 09:19 config.yml
drwxr-xr-x  12 mcfatem  1278142703   384B Aug 18 09:19 content
drwxr-xr-x   7 mcfatem  1278142703   224B Aug 18 09:19 layouts
-rw-r--r--   1 mcfatem  1278142703    64K Aug 18 09:19 package-lock.json
-rw-r--r--   1 mcfatem  1278142703   937B Aug 18 09:19 package.json
drwxr-xr-x  29 mcfatem  1278142703   928B Sep 13 11:28 public
drwxr-xr-x   3 mcfatem  1278142703    96B Aug 18 09:20 resources
drwxr-xr-x   9 mcfatem  1278142703   288B Aug 18 09:20 static
drwxr-xr-x   3 mcfatem  1278142703    96B Aug 18 09:19 themes
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/npm-rootstalk ‹main›
╰─$ htmlproofer ./public
Running 3 checks (Images, Links, Scripts) in ["./public"] on *.html files ...


Checking 3177 external links
...
* At ./public/volume-ix-issue-1/tech-on-the-prarie/index.html:586:
  internally linking to #ref14; the file exists, but the hash 'ref14' does not
* At ./public/volume-ix-issue-1/tech-on-the-prarie/index.html:591:
  internally linking to #ref15; the file exists, but the hash 'ref15' does not

HTML-Proofer found 3741 failures!
```

The output from the `htmlproofer ./public` command was too big to use effectively so I turned back to [Using `htmlproofer` with Docker](https://static.grinnell.edu/dlad-blog/posts/133-automated-proofreading-with-htmlproofer/#using-htmlproofer-with-docker) where I found that version `3.19.2` is still the latest.  So I moved to the `Capture More Info: ./html-proofer.sh` section of the post 133 and found that the `html-proofer.sh` script was NOT part of the new `npm-rootstalk` repo.  Time to get get that script back from a previous version of the repo...   

```bash
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/npm-rootstalk ‹main›
╰─$ cp -f ~/GitHub/.out-of-the-way/rootstalk/html-proofer.sh .
```

And now we have our `html-proofer.sh` script where it belongs again.  It looks like this:  

```sh
#!/bin/bash
##
## Add options to the end of the COMMAND string to change html-proofer behavior.  For a list of available options run:
##   docker run --rm -it -v $(pwd):/src klakegg/html-proofer:3.19.2 --help
## Common options might include:
##    --allow-hash-href
##    --check-html
##    --empty-alt-ignore
##
hugo         # generate a new site
cd public    # move into the new site's files
COMMAND="docker run --rm -it -v $(pwd):/src klakegg/html-proofer:3.19.2 --check-html"
date > /tmp/rootstalk-html-proofer.tmp
echo $COMMAND >> /tmp/rootstalk-html-proofer.tmp
time $COMMAND | sed -e 's/\x1b\[[0-9;]*m//g' >> /tmp/rootstalk-html-proofer.tmp
tail -1 /tmp/rootstalk-html-proofer.tmp
##
## I'm unable to effectively control many of the bogus issues reported by html-proofer, things like:
##     *  internally linking to .., which does not exist (line 682)
##           <a href="..">Back</a>
## So, let's try to implement some `grep` and `sed` commands that will automatically count and remove
## them from the output.
##
BOGUS=`grep -c 'internally linking to ..,' /tmp/rootstalk-html-proofer.tmp`
echo "Removing ${BOGUS} false-negative errors from the output..."
sed '/internally linking to \.\.,/,+1d' /tmp/rootstalk-html-proofer.tmp > ${HOME}/Downloads/rootstalk-html-proofer.out
echo "${BOGUS} false-negative errors were removed from this output." >> ${HOME}/Downloads/rootstalk-html-proofer.out
##
## Successfully running scripted Azure CLI in a Docker container proved to be virtually
## impossible, perhaps because the CLI login and commands are so "interative"?
## So, the `az` commands that follow will require the Azure CLI be installed on the
## host.  See https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?source=recommendations#install-with-homebrew
## for doing that with Homebrew.  Also, you should run `az login` before attempting the
## `az storage blob upload...` command shown here.
##
az storage blob upload \
     --account-name rootstalk \
     --container-name documentation \
     --name rootstalk-html-proofer.out \
     --file ${HOME}/Downloads/rootstalk-html-proofer.out \
     --overwrite \
     --auth-mode key
##
## The output should be available now for download at https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out
##
echo "The output should be available now for download at https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out."
##
```

It looks like it should work as-is, so let's give it a go... 

```bash
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/npm-rootstalk ‹main●›
╰─$ ./html-proofer.sh
Start building sites …
hugo v0.112.7+extended darwin/arm64 BuildDate=unknown

                   | EN
-------------------+------
  Pages            | 431
  Paginator pages  |   0
  Non-page files   |   6
  Static files     | 632
  Processed images |   0
  Aliases          |   0
  Sitemaps         |   1
  Cleaned          |   0

Total in 456 ms
docker: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?.
```

So, Docker isn't running on my Mac.  Going to launch _Docker Desktop_ and try again...  

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/npm-rootstalk ‹main●›
╰─$ ./html-proofer.sh
Start building sites …
hugo v0.112.7+extended darwin/arm64 BuildDate=unknown

                   | EN
-------------------+------
  Pages            | 431
  Paginator pages  |   0
  Non-page files   |   6
  Static files     | 632
  Processed images |   0
  Aliases          |   0
  Sitemaps         |   1
  Cleaned          |   0

Total in 492 ms
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested

real	2m29.158s
user	0m0.115s
sys	0m0.122s
HTML-Proofer found 848 failures!
Removing 2 false-negative errors from the output...
Argument '--overwrite' is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus

There are no credentials provided in your command and environment, we will query for account key for your storage account.
It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.

You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
For more information about RBAC roles in storage, visit https://docs.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.

In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.

Skip querying account key due to failure: AADSTS700082: The refresh token has expired due to inactivity.  The token was issued on 2022-12-02T17:43:57.4286890Z and was inactive for 90.00:00:00.
Trace ID: 0c32ac0c-67e4-41cc-8b81-326161df2c00
Correlation ID: d7fadcb4-51c1-421c-adf8-75f378294d9f
Timestamp: 2023-09-13 16:51:51Z
Server failed to authenticate the request. Please refer to the information in the www-authenticate header.
RequestId:d1addbca-001e-002e-5b62-e67766000000
Time:2023-09-13T16:51:52.1924115Z
ErrorCode:NoAuthenticationInformation
The output should be available now for download at https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out.
```

So, it looks like `html-proofer` worked and found 846 (848 minus 2) probable failures.  However, the _Azure_ credentials I was using for remote storage have expired and/or changed so the script wasn't able to save the output in _Azure_.  Fortunately, there is a local copy at `/tmp/rootstalk-html-proofer.tmp` so I'm just going to copy that to BLOB storage using _Microsoft Azure Storage Explorer_.  

Done.  The new file is publicly available at https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out.  

# Pushing to Production

I found a `git` command at https://stackoverflow.com/questions/13897717/push-commits-to-another-branch to help me push the new `main` back to `production` to trigger a production update.  However...  

```bash
╭─mark@Marks-Mac-Mini ~/GitHub/npm-rootstalk ‹main› 
╰─$ git push origin main:production
To https://github.com/Digital-Grinnell/npm-rootstalk.git
 ! [rejected]        main -> production (non-fast-forward)
error: failed to push some refs to 'https://github.com/Digital-Grinnell/npm-rootstalk.git'
hint: Updates were rejected because a pushed branch tip is behind its remote
hint: counterpart. Check out this branch and integrate the remote changes
hint: (e.g. 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

So, trying to remedy that... 

```bash
╭─mark@Marks-Mac-Mini ~/GitHub/npm-rootstalk ‹main› 
╰─$ git checkout production
Switched to branch 'production'
Your branch is up to date with 'origin/production'.
╭─mark@Marks-Mac-Mini ~/GitHub/npm-rootstalk ‹production› 
╰─$ git pull origin main
From https://github.com/Digital-Grinnell/npm-rootstalk
 * branch            main       -> FETCH_HEAD
Successfully rebased and updated refs/heads/production.
```

Now my `SOURCE CONTROL` tab in _VSCode_ shows a status of `Sync Changes 1 <down> 46 <up>`.  Since my local `production` branch now looks just like `main`, that sounds like the right thing to do at this point so here goes...  I clicked the `Sync...` button and got an email back indicating that `Azure Static Web Apps CI/CD: All jobs that ran were successful`.  

Ok, so what about the production instance on _DigitalOcean_?  

Well, rather than checking in at _DigitalOcean_, I decided to just have a look at https://rootstalk.grinnell.edu and it looks GREAT!  

A quick look at the footer on https://rootstalk.grinnell.edu/about shows `Compiled: Sep 13, 2023 at 1:50pm CDT  • GitHub Hash: f1dddf64`  and that feels right too!  

---

That's all folks... until next time.




