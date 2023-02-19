---
title: Adding a Custom 404 Page in Hugo
publishDate: 2023-02-16T13:07:31-06:00
last_modified_at: 2023-02-18T20:28:30
draft: false
description: "_Rootstalk_ could really use a custom 404 page.  So let's do it."
tags:
  - Hugo
  - Rootstalk
  - custom
  - "404"
  - Azure 
  - API
  - query
  - comment
  - URLSearchParams
  - .RenderString
azure:
  dir: https://sddocs.blob.core.windows.net/documentation
  subdir: 
---  

The task _du jour_ is to begin, and perhaps complete, the process of adding a custom 404 page to _Rootstalk_.  

Thus far I've found a couple of promising resources to guide the effort:  

  - [Custom 404 Page](https://gohugo.io/templates/404/)
  - [Custom 404 pages in Hugo done right](https://moonbooth.com/hugo/custom-404/)

In particular, I'm focusing on "Option 2" in the "...done right" document, and the "Azure Static Web App" portion of the first document.   

## Need a New Azure API Key?

Early in this journey I found that I could not deploy changes to [https://thankful-flower-0a2308810.1.azurestaticapps.net](https://thankful-flower-0a2308810.1.azurestaticapps.net) from the `develop` branch of the code because of an invalid or missing API key.  I turned to [Reset deployment tokens in Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/deployment-token-management) to try and remedy that.  

Alas, that didn't fix things.  The error in my "Build and Deploy Job" log in GitHub says... 

```
App Directory Location: '/' was found.
Looking for event info
The content server has rejected the request with: BadRequest
Reason: No matching Static Web App was found or the api key was invalid.
```

I'm going to remove the `azurestaticwebapp.config.json` file and try again.  Yes, that worked.  So, maybe I put that file in the wrong place?  Also, I am able to switch into the `main` branch of the _Rootstalk_ code, where there is no `azurestaticwebapp.config.json`, and the deployment workflow is successful there.   Time for some more web research.   

## Duh!

Ok, scratch that last section.  It turns out that the _GitHub Action_ that returned the error was an old one desinged to deploy a branch that no longer exists.  The custom 404 page has been working all along on https://thankful-flower-0a2308810.1.azurestaticapps.net/.  In fact, if you try and open something like https://thankful-flower-0a2308810.1.azurestaticapps.net/bogus, an address that doesn't work, you can see the new custom 404.  

## The Real Problem

So, my aim with this is to return a custom 404 page **when an external link, one outside of _Rootstalk_, does NOT work**.  That is apparently a very different ball of wax, so more research is needed.  

### Findings

After considerable research, it seems like what I have in mind **will not work in a static environment like Hugo**.  See [In HUGO - How to read query parameters in template](https://stackoverflow.com/questions/62466078/in-hugo-how-to-read-query-parameters-in-template) for more detail.  

So, what I've done thus far is to create a new page and a new shortcode in the _Rootstalk_ site.  

The page at `./static/broken-external-link.html` reads like this:  

```html
<h1>Whoops! Page Not Found</h1>

<h2>We looked everywhere for "{{ $dead }}", but that page can't be found.</h2>  

<p style="font-weight: 80; color:brown;">Our latest content is <a href="/">on the homepage</a>.</p>
```

The new shortcode at `./layouts/shortcodes/broken.html` reads like this:  

```
{{- $s := .Get 1 -}}
{{- $link := replaceRE "^https?://([^/]+)" "$1" $s -}}
{{- $dead := "dead" -}}
<a href="/broken-external-link.html?{{- (querify $dead $link) | safeURL -}}">{{- .Get 0 -}}</a>
```

That shortcode is called using Markdown syntax like this example from _Rootstalk's_ `content/past-issues/volume-ii-issue-2/kincaid.md`:  

{{% code %}}
...He has published stories and poems in The Eclectic, {{%/* broken "Fiction Fix" "http://fictionfix.net" */%}} and in the online journal {{%/* broken "deadpaper.org" "http://www.deadpaper.org" */%}}
{{% /code %}}

{{% box %}}
Note that in order to "properly" display the block above I had to effectively turn my shortcode references into "comments" by following the advice found in [Hugo - Show ShortCode Markdown in Code Block](https://digitaldrummerj.me/hugo-show-shortcode-markdown-in-code-block/).  
{{% /box %}}

Fortunately, the fourth paragraph in [this answer](https://stackoverflow.com/a/62495849) may hold the key.  It suggests that...

{{% code %}}
At this point, you can still use JavaScript (URLSearchParams) to interpret those params and to modify the page on the spot. This means that you're adding complexity to your Hugo site, as well as more load on the clients (browsers). If you really need those query strings and Hugo, this is the way to go.
{{% /code %}}

I believe this is a static site problem worth solving, for _Rootstalk_ and much more, so let's dive into some JavaScript and [URLSearchParams.](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)  

# The Fix

My **successful** implementation of `URLSearchParams` can be seen in _Rootstalk_ with pertinent source code found in that project's repo and these files:

  - `static/broken-external-link.html`  
  - `layouts/shortcodes/broken.html`  
  - `layouts/shortcodes/broken-endnote.html`
  - Any article `.md` file with a broken external link, such as `content/past-issues/volume-i-issue-1/dean.md`.  

# Oops, Another Problem

The bits of code implemented above work perfectly in my local (via `hugo server`) instance of _Rootstalk_, but there's a problem with the `broken` shortcode when used inside front matter, as is the case in the article titled [My Prairie](https://thankful-flower-0a2308810.1.azurestaticapps.net/past-issues/volume-ii-issue-1/moffett-1/).  

At the very bottom of that article there are three links in the author's "bio", and the last of those links is "broken".  The author's bio appears in the article front matter as you can see in the example shown here in abridged form:

```yaml
azure_dir: rootstalk-2015-fall
contributors:
- bio: '**Betty Moffett** taught for almost thirty years in Grinnell College’s Writing
    Lab, where she learned a great deal from her students.  Her stories have appeared
    in a number of journals and magazines, including [The MacGuffin,]
    (http://www.schoolcraft.edu/a-z-index/the-macguffin#.VqAvnpNVhBc) 
    [The Storyteller,](http://www.thestorytellermagazine.com/) and 
    {{%/* broken "The Wapsipinicon Almanac" "http://www.wapsialmanac" */%}}.  She and her 
    husband, Sandy, write songs for and play with The Too Many String Band.'
  caption: Photo courtesy of Betty Moffett
```

Here the `contributors.bio` field is a mix of Markdown syntax with a call to the `broken` shortcode.  The snippet of code from `layouts/_default/single.html` that renders the bio reads like this:  

```
      {{ with .Params.contributors }}
        {{ range . }}
          {{ $bio := (index . "bio") }}
            ...
            {{ if not (eq $bio " ") }}
              {{ $bio | markdownify }}
            {{ end }}
```

Essentially, the `contributors.bio` value is filtered using ` | markdownify` and that, as I have come to understand, is the root of this problem.  When `$bio` is filtered using `markdownify` the rendered bio from our previous example looks like this:

{{% box %}}
<i><b>Betty Moffett</b> taught for almost thirty years in Grinnell College’s Writing
Lab, where she learned a great deal from her students.  Her stories have appeared
in a number of journals and magazines, including <u>The MacGuffin</u>, <u>The Storyteller</u>, and {{%/* broken "The Wapsipinicon Almanac" \"http://www.wapsialmanac.com\" */%}}.  She and her husband, Sandy, write songs for and play with The Too Many String Band.</i>
{{% /box %}}

Likewise, if the `$bio` is not filtered with `| markdownify` then the Markdown elements including bold text and links don't work, but the `broken` link does.  That output looks like this:  

{{% box %}}
<i>Betty Moffett taught for almost thirty years in Grinnell College’s Writing
Lab, where she learned a great deal from her students.  Her stories have appeared
in a number of journals and magazines, including \[The MacGuffin](http://www.schoolcraft.edu/a-z-index/the-macguffin#.VqAvnpNVhBc), \[The Storyteller](http://www.thestorytellermagazine.com), and <u>The Wapsipinicon Almanac</u>.  She and her husband, Sandy, write songs for and play with The Too Many String Band.</i>
{{% /box %}}

I found numerous posts involving similar problems when mising shortcodes with Markdown and/or front matter, and many of them tout _Hugo_ `.RenderString` as the solution.  However, I have yet to wrap my head around how `.RenderString` might be used in this instance.  So, I've simply backed off from using the `broken` shortcode inside of `contributors.bio`, and have instead replaced such shortcode calls to straight HTML as you see in our abridged front matter below:  

```yaml
contributors:
- bio: '**Betty Moffett** taught for almost thirty years in Grinnell College’s Writing
    Lab, where she learned a great deal from her students.  Her stories have appeared
    in a number of journals and magazines, including 
    [The MacGuffin,](http://www.schoolcraft.edu/a-z-index/the-macguffin#.VqAvnpNVhBc) 
    [The Storyteller,](http://www.thestorytellermagazine.com/) and 
    <a href="/broken-external-link.html?dead=http://www.wapsialmanac.com">The Wapsipinicon Almanac</a>.  
    She and her husband, Sandy, write songs for and play with The Too Many String Band.'
```

Not a very elegant solution, but it works, and you can see a working example of it in the links near the end of [My Prairie](https://thankful-flower-0a2308810.1.azurestaticapps.net/past-issues/volume-ii-issue-1/moffett-1/).  

## Failed Again

As I was posting this update I came across [Questions about .RenderString](https://discourse.gohugo.io/t/questions-about-renderstring/22448/4?u=mcfatem) and the suggestion that replacing `{{ $bio | markdownify }}` with `{{ $.Page.RenderString $bio }}` might work.  It did not.  :frowning:  

---

I'm sure there will soon be much more here, but for this installment... That's a wrap!  


