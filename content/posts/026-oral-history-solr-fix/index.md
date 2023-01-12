---
title: "Missing Oral History Transcripts in DG - Fixed"
date: 2019-07-19T13:09:54
draft: false
tags:
    - Solr config
    - FedoraGSearch config
    - XSLT
    - Oral Histories
    - ISLE
---

I recently constructed a new, local/development instance of _ISLE_ (see [my previous post](/posts/021-rebuilding-isle-ld/)) largely in order to debug a mystery in _Digital.Grinnell_'s display of oral histories.  My _Trello_ card for the issue reads:

>Our newest AOH entries, and some older objects, will not display a transcript after upgrade to the latest version of the OH module. OHScribe is needed to aid in re-processing transcripts for these objects, and some XDebug work will also be required.

Engaging _XDebug_ and _PHPStorm_ allowed me to peek inside the relatively complex oral histories (OH) module where I found that some of our OH objects were missing key _Solr_ field elements, like `or_transcripts` and `or_speaker`.  Ultimately I tracked the problem to our _Solr_ config which is based on work found in https://github.com/discoverygarden/islandora_transforms and https://github.com/discoverygarden/basic-solr-config; the former repository here lists the later as a dependency.  

In case you're not already familiar with these projects, they both represent "starting points", largely config and `.xslt` code that's intended to be customized. In my experience this adds up to trouble since maintenance and upgrade of any multi-faceted, customized code like this can be tedious and therefore, dangerous.

The crux of my problem is that these repos use very long _Java_/_Tomcat_ paths, and the most significant of these is `/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/`.  However, in a standard _ISLE_ instace the equivalent path must be `/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/`.  See the difference?  The _ISLE_ path does NOT include a `../fedora/..` subdirectory like the _Discovery Garden_ paths do.

Unfortunately, when I updated my _FGSearch_ and _Solr_ configs earlier this year I missed some, but not all, of these `../fedora/..` directory references during a "manual" compare and merge process, and that made things like oral histories go afoul, and without much warning.  

My solution to this problem going forward is the creation of [this new public repository](https://github.com/DigitalGrinnell/FgsIndex).  The repo's description in _GitHub_ describes is:

>The contents of isle-fedora-ld's /usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex directory

The repo has no `README.md` file, yet, because the description is so succinct and accurate; but I'll make it a point to add more detail soon.

And that's a wrap.  Until next time...
