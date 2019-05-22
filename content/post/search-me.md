---
date: 2019-05-19T18:39:10-06:00
title: Search Me?
---

Yes, yes you can!  

It's not "done" yet (is anything ever really done?) but you can now 'search' the content, titles, and tags of this blog!  For now just visit [the new /search page](../../search/) and enter the term(s) you would like to look for.  I'll explain this better once it is "done", I hope.

This wonderful addition to the site comes to you compliments of [this awesome gist](https://gist.github.com/eddiewebb/735feb48f50f0ddd65ae5606a1cb41ae#layoutspagesearchhtml), with a little hacking by your's truly.

There's just one problem, perhaps summarized [in my comment on the gist](https://gist.github.com/eddiewebb/735feb48f50f0ddd65ae5606a1cb41ae#gistcomment-2921320) posted moments ago.  The original comment says:

{{% original %}}
I think search is a great addition to Hugo!  But I had to butcher things a bit to get this working with my theme and config.  But it does work, with one exception, I get only one match returned in my results, apparently because of this JS error thrown in the first match:  
```
TypeError: $(...).mark is not a function
```
The offending code looks like this:

```
function populateResults(result){
  $.each(result,function(key,value){
   ...
    $.each(snippetHighlights,function(snipkey,snipvalue){
      $("#summary-"+key).mark(snipvalue);
      // $("#summary-"+key);
    });
  });
}
```

This seems to be telling me that my returned Objects, namely `matches`, did NOT inherit the `mark` function.  Sound right?   Note that if I comment out the .mark reference (see code snippet above) then I get ALL my results, but of course with nothing highlighted.

So, if I'm right about this, can anyone tell me how to define or attach (not sure what the right Javascript concept is) `mark` as a function of each returned object?

Being a relative Hugo noob, and a total Javascript idiot (there, I said it) I am wondering if there's an easy way to fix this, because I understand what .mark is intended to do, and I'd really love to have that feature.  Thanks in advance!
{{% /original %}}

And that's a wrap, well, at least until I find a solution.  Until next time...
