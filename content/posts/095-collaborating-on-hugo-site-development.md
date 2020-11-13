---
title: "Collaborating on Hugo Site Development"
publishDate: 2020-11-12
lastmod: 2020-11-12T15:39:56-06:00
draft: false
tags:
  - Hugo
  - local development
  - git
  - Atom
  - Rootstalk
---

This post will instruct the reader to install necessary tools and engage the workflow I now use to develop and maintain a handful of _Hugo_ static websites. The list of sites now includes both professional, those owned and operated by [Grinnell College](https://grinnell.edu), as well as "personal" sites that I develop, maintain and host myself.

## Professional Sites
These include:

  - [Rootstalk](https://rootstalk.grinnell.edu),
  - [This Blog](https://static.grinnell.edu/blogs/McFateM),
  - [The Static.Grinnell.edu Landing Page](https://static.grinnell.edu), and
  - [VAF](https://vaf.grinnell.edu)

{{% box %}}
The detailed information provided in this blog post involves _Rootstalk_, but the concepts apply equally to all of the professional and personal sites I've listed.
{{% /box %}}

## Personal Sites
These include:

  - [The SummittDweller.com Landing Page](https://summittdweller.com),
  - [My Personal Blog](https://summittdweller.com/blogs/mark), and
  - [The Compass Rose Band](https://compassroseband.net/)

## Local Development
This section briefly describes all that is necessary to collaborate effectively on the development and maintenance of [Rootstalk](https://rootstalk.grinnell.edu) from your OS X workstation, presumably a Mac desktop or laptop.

### Required Software
The workflow which follows will require you to install, or update, the following software packages:

| Software | How to Install |
| --- | --- |
| git | The suggested `Homebrew` instructions lead down an infinite rabbit-hole, so use [https://sourceforge.net/projects/git-osx-installer/](https://sourceforge.net/projects/git-osx-installer/) instead. |
| atom | See [https://flight-manual.atom.io/getting-started/sections/installing-atom/](https://flight-manual.atom.io/getting-started/sections/installing-atom/) |
| hugo | The easiest way to install on a Mac is using the [Binary (Cross-platform)](https://gohugo.io/getting-started/installing/#binary-cross-platform) technique.  As of the writing of this post the package of choice for a Mac was named `hugo_extended_0.78.2_macOS-64bit.tar.gz`. Once you have downloaded the `.gz` file, double-click on it to expand the archive.  Then try this command to install it in your $PATH: `sudo cp -f ~/Downloads/hugo_extended_0.78.2_macOS-64bit/hugo /usr/local/bin/hugo`|

### Usual Workflow
It is recommended that you clone this repository to an OS X workstation where [git](https://git-scm.com), [Atom](https://atom.io), and [Hugo](https://gohugo.io) are installed and running in an up-to-date versions.

My typical workflow for local development, after installation of the above, goes like this:

```
mkdir -p ~/GitHub
cd ~/GitHub
git clone https://github.com/McFateM/rootstalk-static --recursive
cd rootstalk-static
git checkout -b <new-branch-name>
atom .
hugo server
```

#### atom .
The `atom .` command opens the project in my [Atom](https://atom.io) editor which provides many tools and shortcuts to speed development and maintenance. [Atom Basics](https://flight-manual.atom.io/getting-started/sections/atom-basics/) is well worth reading to get you up-to-speed with the powerful editor you now have at your disposal.

Note that when _Atom_ is installed it should include a command-line shortcut so that the `atom .` command will work; however, if `atom .` will not launch _Atom_ it should be possible to add the necssary command-line option as directed in [this StackOverflow answer](https://stackoverflow.com/a/23666354).

#### hugo server
The `hugo server` command compiles and launches a local instance of the site and provides a link, usually [http://localhost:1313](http://localhost:1313/), to that site if there are no errors.  This local site will respond immediately to any changes made and saved in _Atom_.

Note that if your Mac complains that `hugo` isn't from an "approved" developer, you should run the following command to override the need for "approval": `sudo xattr -d com.apple.quarantine /usr/local/bin/hugo`

### Editing and Saving Changes Locally
Once you have both `atom .` and `hugo server` running the process of editing, testing, saving, and sharing your changes should be pretty straightforward.  You will generally use the following commands and operations, in sequence, and repeated as often as necessary.

  - Open your local site by visiting `https://localhost:1313`, or whatever address the `hugo server` command returned, in the web browser of your choice.
  - When you have identified a change that needs to be made, find the corresponding file in the left-most panel of your _Atom_ editor window -- this will usually be some `.md` (_Markdown_) file beneath the `content` directory.  Click on that file to open it in your editor window.
  - Make changes to the file using the appropriate syntax, usually _Markdown_.  There's a nice basic syntax guide for _Markdown_ at [https://www.markdownguide.org/basic-syntax/](https://www.markdownguide.org/basic-syntax/).
  - Once your changes to the file are complete, visit the `File` menu in _Atom_ and select `Save` to save the change.
  - As soon as the file is saved you should see your site change immediately, or almost so, in your browser window.  Check that the changes are properly reflected.
  - Repeat the above steps for as many files as needed.

### Sharing Your Changes with the Project Team
Assuming you have made proper changes, and tested them locally, you should be ready to share your work with the project team.  The first time you do this it's likely that you will need some live assistance in order to get proper `git` credentials and configuration applied.  Reach out to your team development leader for help.  An example of the steps that you will be taking, and repeating quite often, are:

```
git status
git add .
git commit -m "Mark's edits to post 095"
git push origin post-095
```

This `git status`, `git add .`, `git commit...` and `git push...` sequence should become VERY familiar over time.  Since I am currently using this workflow to edit the document you are reading, I'm going to execute these commands now and share the results with you here.

#### git status
In this example I previously used the command `git checkout -b post-095-edits` to create a new branch for my work here. I subsequently edited this file, named `095-collaborating-on-hugo-site-development`, and tested then saved my changes.  Now, when I run `git status` I see this:

```





<hr/>

And that's a wrap.  Until next time...
