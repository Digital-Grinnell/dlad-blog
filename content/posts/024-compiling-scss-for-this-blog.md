---
title: Compiling SCSS (SASS) for This Blog
date: 2019-07-19
draft: false
emoji: true
---

While working on another post I finally made the decision to improve the appearance of this blog a bit, and unfortunately I'd forgotten exactly how to do that.  Even more unfortunate, I never blogged about the process so I had to "discover" the details all over again. :cry: This post is intended to remedy that.

The [theme](https://github.com/McFateM/hugo-theme-m10c) used here, `m10c`, employs `.scss`, or [SASS](https://sass-lang.com/) (Syntactically Awesome Style Sheets) files. Subsequently, a `SASS` compiler is required to process them and produce suitable `.css` to control the display you see now.

Since I use [Atom](https://atom.io/) for all of my maintenance and content here, it only made sense to create a workflow that would make compilation of `.scss` changes automatic.  Doing so on each of my Mac's involved these simple steps:

  - Install `SASS` - I used `homebrew` from the command line based on guidance found [here](https://sass-lang.com/install), like so: `brew install sass/sass/sass`
  - Install the [atom-sass package](https://atom.io/packages/atom-sass) in _Atom_ per the guidance provided with the package.

That's it.  Now, when I edit my `~/Projects/blogs-McFateM/assets/css/_extra.scss` file using _Atom_ and save the changes, the corresponding `.css` is automatically created for me.

Now, I need to research the techniques found in [this post about Hugo with SASS](https://blog.fullstackdigital.com/how-to-cache-bust-and-concatenate-js-and-sass-files-with-hugo-in-2018-9266fd3c411e) and [this subsequent post about including SASS variables from config.toml](https://blog.fullstackdigital.com/how-to-use-hugo-template-variables-in-scss-files-in-2018-b8a834accce) and figure out how to make them work for me.  Unfortunately, I haven't figured out how to make my `atom-sass` recognize config variables from my `config.toml` file yet. :smirk:  I probably need to study [this _Hugo_ pipes document](https://gohugo.io/hugo-pipes/scss-sass/) too.

Also... I've forgotten more than once to document the super-simple `Emoji` capabilities of _Hugo_ and the handy cheatsheet available at https://www.webfx.com/tools/emoji-cheat-sheet/.  Not forgotten anymore.  Now, just don't forget to add `enableEmoji = true` to your `config.toml`, and `emoji: true` to the frontmatter of your posts!  

And that's a wrap.  Until next time...
