---
title: "Automated Proofreading with `htmlproofer`"
publishdate: 2022-11-08
last_modified_at: 2022-11-11T20:32:00
draft: false
tags:
  - Rootstalk
  - htmlproofer
  - proofreading
---

What follows is a January 2022 excerpt from a piece of _Rootstalk_ project documentation titled `Automated-Testing.md`...

{{% original %}}
# Automated Testing

Today I started a little side-project aimed at helping test or "proof" the _Rootstalk_ structure and content.  I'm attempting to use the package/process documented in [this GitHub repo](https://github.com/gjtorikian/html-proofer).

I started on the command-line of my MacBook Pro like so:

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main›
╰─$ gem install html-proofer
Fetching yell-2.2.2.gem
Fetching nokogiri-1.13.1-arm64-darwin.gem
Fetching rainbow-3.1.1.gem
Fetching ethon-0.15.0.gem
Fetching html-proofer-3.19.3.gem
Fetching typhoeus-1.4.0.gem
Fetching parallel-1.21.0.gem
Successfully installed yell-2.2.2
Successfully installed ethon-0.15.0
Successfully installed typhoeus-1.4.0
Successfully installed rainbow-3.1.1
Successfully installed parallel-1.21.0
Successfully installed nokogiri-1.13.1-arm64-darwin
Successfully installed html-proofer-3.19.3
Parsing documentation for yell-2.2.2
Installing ri documentation for yell-2.2.2
Parsing documentation for ethon-0.15.0
Installing ri documentation for ethon-0.15.0
Parsing documentation for typhoeus-1.4.0
Installing ri documentation for typhoeus-1.4.0
Parsing documentation for rainbow-3.1.1
Installing ri documentation for rainbow-3.1.1
Parsing documentation for parallel-1.21.0
Installing ri documentation for parallel-1.21.0
Parsing documentation for nokogiri-1.13.1-arm64-darwin
Installing ri documentation for nokogiri-1.13.1-arm64-darwin
Parsing documentation for html-proofer-3.19.3
Installing ri documentation for html-proofer-3.19.3
Done installing documentation for yell, ethon, typhoeus, rainbow, parallel, nokogiri, html-proofer after 2 seconds
7 gems installed
```

Then, as suggested in the tool's `README.md` file...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main›
╰─$ htmlproofer --help
htmlproofer 3.19.3 -- Runs the HTML-Proofer suite on the files in PATH. For more details, see the README.

Usage:

  htmlproofer PATH [options]

Options:
            --allow-missing-href  If `true`, does not flag `a` tags missing `href` (this is the default for HTML5).
            --allow-hash-href  If `true`, ignores the `href="#"`
            --as-links     Assumes that `PATH` is a comma-separated array of links to check.
            --alt-ignore image1,[image2,...]  A comma-separated list of Strings or RegExps containing `img`s whose missing `alt` tags are safe to ignore
            --assume-extension  Automatically add extension (e.g. `.html`) to file paths, to allow extensionless URLs (as supported by Jekyll 3 and GitHub Pages) (default: `false`).
            --checks-to-ignore check1,[check2,...]  A comma-separated list of Strings indicating which checks you do not want to run (default: `[]`)
            --check-external-hash  Checks whether external hashes exist (even if the webpage exists). This slows the checker down (default: `false`).
            --check-favicon  Enables the favicon checker (default: `false`).
            --check-html   Enables HTML validation errors from Nokogumbo (default: `false`).
            --check-img-http  Fails an image if it's marked as `http` (default: `false`).
            --check-opengraph  Enables the Open Graph checker (default: `false`).
            --check-sri    Check that `<link>` and `<script>` external resources use SRI (default: `false`).
            --directory-index-file <filename>  Sets the file to look for when a link refers to a directory. (default: `index.html`)
            --disable-external  If `true`, does not run the external link checker, which can take a lot of time (default: `false`)
            --empty-alt-ignore  If `true`, ignores images with empty alt tags
            --error-sort <sort>  Defines the sort order for error output. Can be `:path`, `:desc`, or `:status` (default: `:path`).
            --enforce-https  Fails a link if it's not marked as `https` (default: `false`).
            --extension <ext>  The extension of your HTML files including the dot. (default: `.html`)
            --external_only  Only checks problems with external references
            --file-ignore file1,[file2,...]  A comma-separated list of Strings or RegExps containing file paths that are safe to ignore
            --http-status-ignore 123,[xxx, ...]  A comma-separated list of numbers representing status codes to ignore.
            --internal-domains domain1,[domain2,...]  A comma-separated list of Strings containing domains that will be treated as internal urls.
            --ignore-empty-mailto  If `true`, allows `mailto:` `href`s which do not contain an email address
            --report-invalid-tags  When `check_html` is enabled, HTML markup that is unknown to Nokogumbo are reported as errors (default: `false`)
            --report-missing-names  When `check_html` is enabled, HTML markup that are missing entity names are reported as errors (default: `false`)
            --report-script-embeds  When `check_html` is enabled, `script` tags containing markup are reported as errors (default: `false`)
            --report-missing-doctype  When `check_html` is enabled, HTML markup with missing or out-of-order `DOCTYPE` are reported as errors (default: `false`)
            --report-eof-tags  When `check_html` is enabled, HTML markup with tags that are malformed are reported as errors (default: `false`)
            --report-mismatched-tags  When `check_html` is enabled, HTML markup with mismatched tags are reported as errors (default: `false`)
            --log-level <level>  Sets the logging level, as determined by Yell. One of `:debug`, `:info`, `:warn`, `:error`, or `:fatal`. (default: `:info`)
            --only-4xx     Only reports errors for links that fall within the 4xx status code range
            --storage-dir PATH  Directory where to store the cache log (default: "tmp/.htmlproofer")
            --timeframe <time>  A string representing the caching timeframe.
            --typhoeus-config CONFIG  JSON-formatted string of Typhoeus config. Will override the html-proofer defaults.
            --hydra-config CONFIG  JSON-formatted string of Hydra config. Will override the html-proofer defaults.
            --url-ignore link1,[link2,...]  A comma-separated list of Strings or RegExps containing URLs that are safe to ignore. It affects all HTML attributes. Note that non-HTTP(S) URIs are always ignored
            --url-swap re:string,[re:string,...]  A comma-separated list containing key-value pairs of `RegExp => String`. It transforms URLs that match `RegExp` into `String` via `gsub`. The escape sequences `\:` should be used to produce literal `:`s.
            --root-dir PATH  The absolute path to the directory serving your html-files.
        -h, --help         Show this message
        -v, --version      Print the name and version
        -t, --trace        Show the full backtrace when an error occurs
```

Next...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main●›
╰─$ hugo
Start building sites …
hugo v0.87.0+extended darwin/arm64 BuildDate=unknown
WARN 2022/01/28 11:48:18 Page.Hugo is deprecated and will be removed in a future release. Use the global hugo function.
.File.UniqueID on zero object. Wrap it in if or with: {{ with .File }}{{ .UniqueID }}{{ end }}

                   | EN
-------------------+------
  Pages            | 257
  Paginator pages  |  10
  Non-page files   | 172
  Static files     |  28
  Processed images |   0
  Aliases          |  62
  Sitemaps         |   1
  Cleaned          |   0

Total in 773 ms
```

And finally...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main●›
╰─$ time htmlproofer ./public
Running ["ScriptCheck", "LinkCheck", "ImageCheck"] on ["./public"] on *.html...


Checking 1405 external links...
...
*  External link https://patch.com/iowa/across-ia/lawsuit-iowa-school-juvenile-offend-ers-misusing-drugs failed: 404 No error
*  image /images/rootstalk_leaf.svg does not have an alt attribute (line 389)
*  image https://rootstalk.blob.core.windows.net/rootstalk-2021-spring/grinnell_29963_OBJ.jpg does not have an alt attribute (line 743)
*  image https://rootstalk.blob.core.windows.net/rootstalk-2021-spring/grinnell_29999_OBJ.jpg does not have an alt attribute (line 132)
*  linking to internal hash #ref37 that does not exist (line 573)
   <a href="#ref37"><sup>37</sup></a>
*  linking to internal hash #ref38 that does not exist (line 578)
   <a href="#ref38"><sup>38</sup></a>
- ./public/volume-vii-issue-2/taylor/index.html
*  External link https://rootstalk-archive.grinnell.edu failed: response code 0 means something's wrong.
           It's possible libcurl couldn't connect to the server or perhaps the request timed out.
           Sometimes, making too many requests at once also breaks things.
           Either way, the return message (if any) from the server is: SSL peer certificate or SSH remote key was not OK
*  External link https://www.census.gov/quickfacts/fact/table/sanmarcoscitytexas/PST120219 failed: 404 No error
*  image /images/rootstalk_leaf.svg does not have an alt attribute (line 225)
*  image https://rootstalk.blob.core.windows.net/rootstalk-2021-spring/grinnell_29971_OBJ.jpg does not have an alt attribute (line 132)
*  image https://rootstalk.blob.core.windows.net/rootstalk-2021-spring/grinnell_29972_OBJ.jpg does not have an alt attribute (line 255)

HTML-Proofer found 1005 failures!
htmlproofer ./public  7.86s user 1.81s system 29% cpu 32.993 total
```

The output was too big to copy/paste above so I'm just showing an abridged version there.  Finding no "output file" option for `htmlproofer` I elected the following approach in order to get a manageable body of output:

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹main●›
╰─$ time htmlproofer ./public > htmlproofer-28-jan-2022.out 2>&1
htmlproofer ./public > htmlproofer-28-jan-2022.out 2>&1  7.77s user 1.68s system 29% cpu 32.112 total
```
{{% /original %}}

## Improving the Workflow

The process documented above worked very well, but making the output part of the _Rootstalk_ project repo is a problem, that repo isn't accessible to everyone on the project, but the `htmlproofer` output really should be!  So, I think a couple of improvements are needed:

1) The output should reside in the _Rootstalk_ project `documentation` container in _Azure_ blob storage, where it will have a consistent and [publicly-accessible URL](https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out).

2) Since the current output is always in a specific file, namely [rootstalk-html-proofer.out,](https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out) that file should contain a timestamp indicating when it was created/updated.

## First, An Updated Install

If you look closely above you'll see that my original install of `htmlproofer` was version `3.19.3` and that install is only on my GC MacBook Pro.  So before going farther, I'm going to attempt to update that installation to `version 4.x` which is described in more detail at [UPGRADING.md](https://github.com/gjtorikian/html-proofer/blob/main/UPGRADING.md).  Unfortunately, this document doesn't suggest "how" to upgrade so I suppose a re-install using [README.md](https://github.com/gjtorikian/html-proofer/blob/main/README.md) is called for.

Now, per the `README.md` file...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
╰─$ gem install html-proofer   
Fetching zeitwerk-2.6.6.gem
Fetching html-proofer-4.4.3.gem
Successfully installed zeitwerk-2.6.6
Successfully installed html-proofer-4.4.3
Parsing documentation for zeitwerk-2.6.6
Installing ri documentation for zeitwerk-2.6.6
Parsing documentation for html-proofer-4.4.3
Installing ri documentation for html-proofer-4.4.3
Done installing documentation for zeitwerk, html-proofer after 0 seconds
2 gems installed
```

Hmmm, that still looks like an old version?  But this seems to indicate otherwise...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹develop›
╰─$ htmlproofer -v
htmlproofer 4.4.3
```

## Getting Help

That's easy...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹develop›
╰─$ htmlproofer -h
htmlproofer 4.4.3 -- Runs the HTML-Proofer suite on the files in PATH. For more details, see the README.

Usage:

  htmlproofer PATH [options]

Options:
            --allow-hash-href=<true|false>  If `true`, assumes `href="#"` anchors are valid (default: `true`)
            --allow-missing-href=<true|false>  If `true`, does not flag `a` tags missing `href`. In HTML5, this is technically allowed, but could also be human error. (default: `false`)
            --as-links     Assumes that `PATH` is a comma-separated array of links to check.
            --assume-extension <ext>  Automatically add specified extension to files for internal links, to allow extensionless URLs (as supported by most servers) (default: `.html`).
            --checks check1,[check2,...]  A comma-separated list of Strings indicating which checks you want to run (default: `["Links", "Images", "Scripts"]`)
            --check-external-hash=<true|false>  Checks whether external hashes exist (even if the webpage exists) (default: `true`).
            --check-internal-hash=<true|false>  Checks whether internal hashes exist (even if the webpage exists) (default: `true`).
            --check-sri=<true|false>  Check that `<link>` and `<script>` external resources use SRI (default: `false`).
            --directory-index-file <filename>  Sets the file to look for when a link refers to a directory. (default: `index.html`)
            --disable-external=<true|false>  If `true`, does not run the external link checker (default: `false`)
            --enforce-https=<true|false>  Fails a link if it's not marked as `https` (default: `true`).
            --extensions ext1,[ext2,...[  A comma-separated list of Strings indicating the file extensions you would like to check (including the dot) (default: `.html`)
            --ignore-empty-alt=<true|false>  If `true`, ignores images with empty/missing alt tags (in other words, `<img alt>` and `<img alt="">` are valid; set this to `false` to flag those) (default: `true`)
            --ignore-empty-mailto=<true|false>  If `true`, allows `mailto:` `href`s which do not contain an email address (default: `false`)
            --ignore-files file1,[file2,...]  A comma-separated list of Strings or RegExps containing file paths that are safe to ignore
            --ignore-missing-alt=<true|false>  If `true`, ignores images with missing alt tags (default: `false`)
            --ignore-status-codes 123,[xxx, ...]  A comma-separated list of numbers representing status codes to ignore.
            --ignore-urls link1,[link2,...]  A comma-separated list of Strings or RegExps containing URLs that are safe to ignore. This affects all HTML attributes, such as `alt` tags on images.
            --log-level <level>  Sets the logging level, as determined by Yell. One of `:debug`, `:info`, `:warn`, `:error`, or `:fatal`. (default: `:info`)
            --only-4xx     Only reports errors for links that fall within the 4xx status code range
            --root-dir PATH  The absolute path to the directory serving your html-files.
            --swap-attributes CONFIG  JSON-formatted config that maps element names to the preferred attribute to check (default: `{}`).
            --swap-urls re:string,[re:string,...]  A comma-separated list containing key-value pairs of `RegExp => String`. It transforms URLs that match `RegExp` into `String` via `gsub`. The escape sequences `\:` should be used to produce literal `:`s.
            --typhoeus CONFIG  JSON-formatted string of Typhoeus config. Will override the html-proofer defaults.
            --hydra CONFIG  JSON-formatted string of Hydra config. Will override the html-proofer defaults.
            --parallel CONFIG  JSON-formatted string of Parallel config. Will override the html-proofer defaults.
            --cache CONFIG  JSON-formatted string of cache config. Will override the html-proofer defaults.
        -h, --help         Show this message
        -v, --version      Print the name and version
        -t, --trace        Show the full backtrace when an error occurs
```

## Running the New `htmlproofer` 

So, having read the help documentation I forged ahead and got this...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹develop›
╰─$ htmlproofer ./public
Running 3 checks (Links, Scripts, Images) in ["./public"] on *.html files...

Checking 2461 external links
htmlproofer 4.4.3 | Error:  Document tree depth limit exceeded
```

I was unable to overcome that error with any provided options so I tried rebooting my Mac before running it again, and on that occasion it worked.  I've since submitted an "Issue" with the `htmlproofer` project to see if others can help work around it.  

When I was able to successfully run `htmlproofer` I got something like this:

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹develop›
╰─$ htmlproofer ./public
Running 3 checks (Links, Scripts, Images) in ["./public"] on *.html files...

Checking 2461 external links
...
* At ./public/volume-vii-issue-2/ross/index.html:585:
  internally linking to #ref38; the file exists, but the hash 'ref38' does not
* At ./public/volume-viii-issue-1/page/2/index.html:682:
  internally linking to .., which does not exist
* At ./public/volume-viii-issue-1/page/3/index.html:682:
  internally linking to .., which does not exist

HTML-Proofer found 3374 failures!
```

## Using `htmlproofer` with Docker

Because of all the errors I was getting and all the headaches with trying to configure/manage a working `ruby` environment, I turned to the [klakegg/html-proofer](https://hub.docker.com/r/klakegg/html-proofer) project on DockerHub.  It works nicely! 

I ran it like so on my M1 MacBook...

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk/public ‹develop›
╰─$ docker run --rm -it \
  -v $(pwd):/src \
  klakegg/html-proofer:3.19.2 \
  --allow-hash-href --check-html --empty-alt-ignore
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Running ["ScriptCheck", "LinkCheck", "ImageCheck", "HtmlCheck"] on ["."] on *.html...


Checking 2445 external links...
Ran on 430 files!
...
- ./volume-viii-issue-1/woodpeckers-of-the-prairie/index.html
  *  External link https://www.linkedin.com/in/chelsea-steinbrecher-hoffmann-82723755 failed: 999 No error

HTML-Proofer found 225 failures!
```

And I subsequently copied the `rootstalk-html-proofer.out` file to _Azure_ blog storage so you'll find it available at https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out.  Keep in mind that this version of the output used option flags `--allow-hash-href --check-html --empty-alt-ignore` to limit the output considerably.

## A Better Docker `htmlproofer` Run

```
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk/public ‹develop›
╰─$ time docker run --rm -it \
  -v $(pwd):/src \
  klakegg/html-proofer:3.19.2 > /tmp/rootstalk-html-proofer.out
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
docker run --rm -it -v $(pwd):/src klakegg/html-proofer:3.19.2 >   0.12s user 0.08s system 0% cpu 2:10.53 total
```

That run, without any limiting options, returned...  `HTML-Proofer found 1383 failures!`.  It also doesn't contain a timestamp of any kind, nor does it indicate which options were used, so I'd like to see if I can easily remedy that with a little more scripting.

## Capture More Info: `./html-proofer.sh`

To better control and capture relevant output I constructed a small bash script, `html-proofer.sh`, and you'll find it in the root directory of the _Rootstalk_ project repo.  Its initial contents:

```bash
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
date > /tmp/rootstalk-html-proofer.out
echo $COMMAND >> /tmp/rootstalk-html-proofer.out
time $COMMAND | sed -e 's/\x1b\[[0-9;]*m//g' >> /tmp/rootstalk-html-proofer.out
mv -f /tmp/rootstalk-html-proofer.out ~/Downloads/rootstalk-html-proofer.out
```

Output from running the script should look something like this:

```
╭─mark@Marks-Mac-Mini ~/GitHub/rootstalk ‹main*›
╰─$ ./htmlproofer.sh
Start building sites …
hugo v0.105.0+extended darwin/amd64 BuildDate=unknown
WARN 2022/11/08 19:36:19 .File.UniqueID on zero object. Wrap it in if or with: {{ with .File }}{{ .UniqueID }}{{ end }}

                   | EN
-------------------+------
  Pages            | 394
  Paginator pages  |  23
  Non-page files   | 114
  Static files     |  30
  Processed images |   0
  Aliases          |  72
  Sitemaps         |   1
  Cleaned          |   0

Total in 1289 ms

real	0m57.285s
user	0m0.068s
sys	0m0.098s
```

The script creates a file, `~/Downloads/rootstalk-html-proofer.out`, that should contain easily readable output like this:

```
Tue Nov  8 19:36:19 CST 2022
docker run --rm -it -v /Users/mark/GitHub/rootstalk/public:/src klakegg/html-proofer:3.19.2 --check-html
Running ["HtmlCheck", "ScriptCheck", "LinkCheck", "ImageCheck"] on ["."] on *.html... 


Checking 2474 external links...
Ran on 413 files!


- ./about/index.html
  *  External link https://ojs.grinnell.edu/index.php/prairiejournal/about/submissions#onlineSubmissions failed: 404 No error
- ./admin/index.html
  *  image /images/generic-01.png does not have an alt attribute (line 127)
- ./admin/tags/index.html
  *  image /images/generic-01.png does not have an alt attribute (line 129)
- ./index.html
  *  254:11: ERROR: Start tag of nonvoid HTML element ends with '/>', use '>'.
      <h2><a href="/volume-viii-issue-1/" />Click here for full contents of "Volume VIII, Issue 1"</a></h2>
          ^ (line 254)
  *  internally linking to .., which does not exist (line 261)

...many lines removed...

- ./volume-viii-issue-1/trissell/index.html
  *  External link https://www.alltrails.com/us/iowa/kellogg failed: 403 No error
  *  External link https://www.nass.usda.gov/Publications/AgCensus/2017/Full_Report/Volume_1,_Chapter_2_County_LevelIowa/st19_2_0001_0001.pdf failed: 404 No error
  *  image https://rootstalk.blob.core.windows.net/rootstalk-2022-spring/trissell-7.png does not have an alt attribute (line 210)
- ./volume-viii-issue-1/woodpeckers-of-the-prairie/index.html
  *  External link https://www.linkedin.com/in/chelsea-steinbrecher-hoffmann-82723755 failed: 999 No error
  *  image https://rootstalk.blob.core.windows.net/rootstalk-2022-spring/Villatoro-2-volume-iii-issue-1-spring-2022.jpg does not have an alt attribute (line 177)
  *  image https://rootstalk.blob.core.windows.net/rootstalk-2022-spring/Villatoro-8-moffett-volume-viii-issue-1-spring-2022.jpg does not have an alt attribute (line 330)

HTML-Proofer found 1426 failures!
```

Again, I moved that `~/Downloads/rootstalk-html-proofer.out` file to _Azure_ storage so that it's available at https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out.

## Next Steps

Since most of the issues identified in https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out are missing image `alt` attributes, I think it would be prudent to try and automate the generation of meaningful `alt` tags.  Since all of the _Rootstalk_ images are now stored in _Azure Blob Containers_, I think it would be prudent to look at things like:

  - [Using Artificial Intelligence to Generate Alt Text on Images](https://css-tricks.com/using-artificial-intelligence-to-generate-alt-text-on-images/) and
  - [Dynamically Generated Alt Text with Azure's Computer Vision API](https://codepen.io/sdras/details/jawPGa)

Big fun!  

### Not So Much Fun

A little research into automatic generation of `alt` tags leads me to believe it's not going to be worthwhile for _Rootstalk_ after all.  Many of our images are relatively complex so effectively training an auto-tag algorithm might take longer than it's worth, and the results are likely to be disappointment.  I think it's better if we try to eliminate all the "systemic" `html-proofer` issues that we can, and manually deal with the rest, perhaps with the aid of a student worker.

## Scripting `html-proofer`

After briefly focusing on eliminating all of the "easy", systemic issues that `html-proofer` flagged, I turned my attention to automating the process of running a new `html-proofer`.  The product of that work is the new `html-proofer.sh` script that's listed, complete with comments, here:

```bash
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

The output from my latest run of `html-proofer.sh` looks like this:

```html
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/rootstalk ‹develop› 
╰─$ ./html-proofer.sh                                                               
Start building sites … 
hugo v0.105.0+extended darwin/arm64 BuildDate=unknown
WARN 2022/11/11 14:11:30 .File.UniqueID on zero object. Wrap it in if or with: {{ with .File }}{{ .UniqueID }}{{ end }}

                   | EN   
-------------------+------
  Pages            | 391  
  Paginator pages  |  23  
  Non-page files   |  24  
  Static files     |  32  
  Processed images |   0  
  Aliases          |  71  
  Sitemaps         |   1  
  Cleaned          |   0  

Total in 558 ms
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested

real    2m12.174s
user    0m0.088s
sys     0m0.080s
HTML-Proofer found 316 failures!
Removing 24 false-negative errors from the output...
Argument '--overwrite' is in preview and under development. Reference and support levels: https://aka.ms/CLI_refstatus

There are no credentials provided in your command and environment, we will query for account key for your storage account.
It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.

You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
For more information about RBAC roles in storage, visit https://docs.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.

In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.
Finished[#############################################################]  100.0000%
{
  "client_request_id": "57a1860a-61fd-11ed-a661-9aa213ed91f9",
  "content_md5": "o6WZXPlD/W134hWMYo3XZQ==",
  "date": "2022-11-11T20:13:43+00:00",
  "encryption_key_sha256": null,
  "encryption_scope": null,
  "etag": "\"0x8DAC4213C06EEC8\"",
  "lastModified": "2022-11-11T20:13:44+00:00",
  "request_id": "4fa6aae2-b01e-0070-3c0a-f6f502000000",
  "request_server_encrypted": true,
  "version": "2021-06-08",
  "version_id": null
}
The output should be available now for download at https://rootstalk.blob.core.windows.net/documentation/rootstalk-html-proofer.out.
```

So, 316 failures minus the 24 false-negatives we removed equals **292 failures yet to be examined**.  Not too bad for a site with seven years of content and 2400+ references to be checked!

---

And that's a wrap.  Until next time, Keep Calm, Carry On, stay safe and wash your hands! :smile:
