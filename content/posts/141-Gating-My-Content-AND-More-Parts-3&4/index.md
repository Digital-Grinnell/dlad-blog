---
title: Gating My Content & More - Parts 3 and 4
publishDate: 2023-02-18T22:03:49-06:00
last_modified_at: 2023-03-23T17:28:48
draft: false
description: The 3rd and 4th parts of a second attempt at gating content in Wieting.TamaToledo.com. 
tags:
  - gating
  - authentication
  - NetlifyCMS
  - Wieting
  - StatiCrypt
  - Eleventy
  - 11ty
  - Azure
  - GitHub
  - oAuth
azure:
  dir: https://sddocs.blob.core.windows.net/documentation
  subdir: Building-Wieting-Guild-Pages
---  

{{% box %}}
See [Gating My Content & More - Parts 1 and 2](https://static.grinnell.edu/dlad-blog/posts/139-gating-my-content-and-more/) for prerequsite and background info.
{{% /box %}}

# Introducing Wieting Content

Part 3 of this process, the introduction of Wieting Theatre Guild content, is described in the project repo's `README.md` file.  Since the project is in a _private_ repo I'll include the pertinent parts here from [this gist](https://gist.github.com/SummittDweller/eb67aa53b3ec3c1d78e1d47d04399ee5).    
 
{{< gist SummittDweller eb67aa53b3ec3c1d78e1d47d04399ee5 >}}

# Part 4 - Protecting Pages with StatiCrypt CLI + More

Let's jump in with [StatiCrypt CLI](https://robinmoisson.github.io/staticrypt/).  The following experience is from the `README.md` file in my https://github.com/SummittDweller/wieting-guild-pages project.

## Displaying Embedded PDFs

Some of the pages I added to https://wieting-guild.tamatoledo.com are intended to display `.pdf` content.  The old shortcode responsible for that feature will need to be ported from [wieting-one-click-hugo-cms](https://github.com/SummittDweller/wieting-one-click-hugo-cms/tree/main/site/content/guild) and made to function in `Eleventy`.  

Time for some research into how PDF's can be best embedded into `Eleventy` content...  I found this:  

  - https://www.npmjs.com/package/eleventy-plugin-pdfembed

The template content used to embed a PDF then looks like this:

  `{% pdfembed 'https://documentcloud.adobe.com/view-sdk-demo/PDFs/Bodea-Brochure.pdf' %}`

## Properly Adding a Plugin to `.eleventy.js`

So, the initial contents of my `.eleventy.js` file was: 

```js
module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy("./src/css/");
  eleventyConfig.addWatchTarget("./src/css/");

  eleventyConfig.addShortcode("year", () => `${new Date().getFullYear()}`);

  return {
    dir: {
      input: "src",
      output: "public",
    },
  };
};
```

And I needed to add this:  

```js
const pluginPDFEmbed = require('eleventy-plugin-pdfembed');
module.exports = (eleventyConfig) => {
	// more stuff here
	eleventyConfig.addPlugin(pluginPDFEmbed, {
		key: '<YOUR CREDENTIAL KEY>'
	});
}
```

But, how and where?  After a little research I tried this:  

```js
const pluginPDFEmbed = require('eleventy-plugin-pdfembed');

module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy("./src/css/");
  eleventyConfig.addWatchTarget("./src/css/");
  eleventyConfig.addShortcode("year", () => `${new Date().getFullYear()}`);
  eleventyConfig.addPlugin(pluginPDFEmbed, { key: '<YOUR CREDENTIAL KEY>' });

  return {
    dir: {
      input: "src",
      output: "public",
    },
  };
};
```

Woohoo!  That syntax looks right, but of course I didn't get any PDF to display because my PDF path is all wrong AND I have yet to replace `<YOUR CREDENTIAL KEY>` above.  It's late so that can wait until tomorrow.  

## How to Restart An Eleventy Site

So, I returned to this project today after a `git add .`, `git commit ...`, `git push` sequence last evening.  Now my `pdfembed` plug-in isn't working locally.  I wonder why that is?  Probably because I didn't properly commit the effects of last night's `npm i eleventy-plugin-pdfembed`.  **So, how should I be doing that?**

A quick search of the web turned up evidence of a `--save` option on the `npm install` command.  The resource I found was [What is the --save option for npm install](https://learn.coderslang.com/0196-what-is-the-save-option-for-npm-install/).  The explanation there makes perfect sense, so I'm going to run `npm i eleventy-plugin-pdfembed --save` now to see what happens...

```zsh
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-guild-pages ‹main*› 
╰─$ npm i eleventy-plugin-pdfembed --save

up to date, audited 354 packages in 613ms

19 packages are looking for funding
  run `npm fund` for details

7 vulnerabilities (2 moderate, 3 high, 2 critical)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
```

Hmmm, there was no change in my `package.json` file, and when I look there I see that the `pdfembed` dependency was already there.  I guess the missing link here is that I didn't `npm run build` yet?  Bingo!  That did the trick.  So, my proper "restart" of the local site must include TWO commands:

  - `npm run build` 
  - `npm run start`                        

Now, back to the problem at hand...

## Resolving the PDF Path and Display

The `pdfembed` plug-in was written to take a full URL pointer to the PDF file, but I'd like to know if it works "locally" as well.  So, Eleventy configuration also supports the notion of a _passthrough_ directory as you can see in this line gleaned from our `.eleventy.js` file:  

```js
  eleventyConfig.addPassthroughCopy("./src/css/");  
```

So, I think what I'll do is create a dedicated _passthrough_ directory at `./src/static` -- I chose this path because `static` is the default "passthrough" directory in Hugo -- and put my PDFs in a subdirectory there.  To do this I'll add two more lines to our `.eleventy.js` file:  

```js
  eleventyConfig.addPassthroughCopy("./src/static/");
  eleventyConfig.addWatchTarget("./src/static/");
```

The second line above instructs the project to "keep watch" for changes in the contents of `./src/static`, and rebuild the project when any changes are detected there.  

Next, I'll create the `./src/static` directory and a `/pdfs` directory beneath it, place copies of all my PDF files there, and experiment with `pdfembed` shortcode calls like this:  

```
{% pdfembed '/pdfs/wieting-501c3.pdf' %}
{% pdfembed './pdfs/wieting-501c3.pdf' %}
{% pdfembed './static/pdfs/wieting-501c3.pdf' %}
```

Duh, none of this works.  So, I did some inspection of the local site and found this:  

```
This application domain (http://localhost:8080) is not authorized to use the provided PDF Embed API Client ID.
```

Well, of course, I haven't supplied a valid key for the `.eleventy.js` config line that reads `eleventyConfig.addPlugin(pluginPDFEmbed, { key: '<YOUR CREDENTIAL KEY>' });`!  

The instructions in [Eleventy Plugin: PDFEmbed](https://www.npmjs.com/package/eleventy-plugin-pdfembed) leads to a [free set of credentials](https://documentservices.adobe.com/dc-integration-creation-app-cdn/main.html) link to set that up.  

I setup an _Adobe Developer_ account, created credentials, and tried again.  Unfortunately, _Adobe_ is telling me that the viewer needs to be updated, so I opened [this _GitHub_ issue](https://github.com/cfjedimaster/eleventy-plugin-pdfembed/issues/2) to document my approach.  

The package author **very quickly** addressed the issue and produced an updated `main` within just a couple of hours... AWESOME!  So, based on guidance I found in [Install NPM Packages from GitHub](https://www.pluralsight.com/guides/install-npm-packages-from-gitgithub), I did `npm i https://github.com/cfjedimaster/eleventy-plugin-pdfembed` to update things locally and then gave it a test.  **It works!  Beautimous!**  

# Protecting Pages with StatiCrypt CLI

Let's jump in with [StatiCrypt CLI](https://robinmoisson.github.io/staticrypt/) to see about password protection for the new pages.  The guidance I'll follow is [How to password protect a static site on Vercel, Netlify, or any JAMStack site](https://www.alpower.com/tutorials/how-to-password-protect-a-static-site/) as it applies to StatiCrypt CLI and Eleventy.  I found that I also needed some guidance from [StatiCrypt](https://github.com/robinmoisson/staticrypt#staticrypt).  

## Locally...

```zsh
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-guild-pages ‹main› 
╰─$ npm install staticrypt

added 3 packages, and audited 357 packages in 2s

19 packages are looking for funding
  run `npm fund` for details

7 vulnerabilities (2 moderate, 3 high, 2 critical)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-guild-pages ‹main*› 
╰─$ npm audit fix

added 3 packages, removed 10 packages, changed 6 packages, and audited 350 packages in 2s

20 packages are looking for funding
  run `npm fund` for details

# npm audit report

ejs  <3.1.7
Severity: critical
ejs template injection vulnerability - https://github.com/advisories/GHSA-phwq-j96m-2c2q
fix available via `npm audit fix --force`
Will install @11ty/eleventy@2.0.0, which is a breaking change
node_modules/ejs
  @11ty/eleventy  <=1.0.2
  Depends on vulnerable versions of ejs
  Depends on vulnerable versions of liquidjs
  Depends on vulnerable versions of markdown-it
  Depends on vulnerable versions of pug
  node_modules/@11ty/eleventy

liquidjs  <10.0.0
Severity: moderate
liquidjs may leak properties of a prototype - https://github.com/advisories/GHSA-45rm-2893-5f49
fix available via `npm audit fix --force`
Will install @11ty/eleventy@2.0.0, which is a breaking change
node_modules/liquidjs

markdown-it  <12.3.2
Severity: moderate
Uncontrolled Resource Consumption in markdown-it - https://github.com/advisories/GHSA-6vfc-qv3f-vr6c
fix available via `npm audit fix`
node_modules/markdown-it

pug  <3.0.1
Severity: high
Remote code execution via the `pretty` option. - https://github.com/advisories/GHSA-p493-635q-r6gr
fix available via `npm audit fix --force`
Will install @11ty/eleventy@2.0.0, which is a breaking change
node_modules/pug

5 vulnerabilities (2 moderate, 1 high, 2 critical)

To address issues that do not require attention, run:
  npm audit fix

To address all issues (including breaking changes), run:
  npm audit fix --force
╭─mark@Marks-Mac-Mini ~/GitHub/wieting-guild-pages ‹main*› 
╰─$                        
```

## Building in Azure

I modified my `.github/workflows/azure-static-web-apps-lemon-mushroom-087d78210.yml` file to include a `app_build_command` option as suggested in [Build configuration for Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/build-configuration?tabs=github-actions#build-and-deploy). When omitted this defaults to `npm run build`, but I needed more to enmgage the encryption.  

## Now `wieting-guild.tamatoledo.com` 

On 2023-03-08T13:05:40-06:00 I added a new _Adobe_ `PDF Embed` API key to my developer dashboard, and also here in the config of `.eleventy.js`.  

This morning I added a `CNAME` record to the `tamatoledo.com` domain DNS records at _DigitalOcean_ with this value: `lemon-mushroom-087d78210.2.azurestaticapps.net`.  I also added a custom domain validation record for `wieting-guild.tamatoledo.com` in the _Azure Static Web App_ settings for this project.  It all works!  

---

I hope you find portions of this very detailed post to be useful.  I'm sure there will soon be some follow-up to this, but for this installment... That's a wrap!  


