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
The detailed information provided in this blog post uses _Rootstalk_ and [this blog](https://static.grinnell.edu/blogs/McFateM) as examples, but the concepts apply equally to all of the professional and personal sites I've listed.
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
git status
git commit -m "Mark's edits to post 095"
git status
git remote -v
git push origin post-095-edits
```

This `git status`, `git add .`, `git commit...` and `git push...` sequence should become VERY familiar over time.  Since I am currently using this workflow to edit the document you are reading, I'm going to change my "example" project and execute these commands now, sharing the results with you below.

#### git status
In this example I previously used the command `git checkout -b post-095-edits` to create a new branch for my work here. I subsequently edited this file, named `095-collaborating-on-hugo-site-development`, and tested then saved my changes.  Now, when I run `git status` I see this:

```
╭─mark@Marks-Mac-Mini ~/GitHub/blogs-McFateM ‹post-095-edits›
╰─$ git status
On branch post-095-edits
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)
  (commit or discard the untracked or modified content in submodules)

	modified:   content/posts/095-collaborating-on-hugo-site-development.md
	modified:   themes/hugo-theme-m10c (modified content)

no changes added to commit (use "git add" and/or "git commit -a")
```

This command indicates that I'm working in my `post-095-edits` branch, as intended.  It also shows that I've made changes to `content/posts/095-collaborating-on-hugo-site-development.md` as well as to my `themes/hugo-theme-m10c` theme. Finally, it tells me that none of these changes have been "committed" yet. You can't see it here, but the two lines that begin with the word `modified:` appear in my terminal in red; indicating that they are not quite ready to share yet.

#### git add .
I'm comfortable with changes made to ALL of the files reported as "modified" above, so I want to "stage" ALL of them to be committed, and I do that using `git add .`.  The dot at the end captures ALL of the modified files.  If there were changes that I'm not comfortable with I could be more specific and repeat the path of each file to be committed like so:  `git add content/posts/095-collaborating-on-hugo-site-development.md`.

If all goes as planned, the `git add .` command won't return anything.

#### git status
Now I can check my progress with another `git status`, like so:

```
╭─mark@Marks-Mac-Mini ~/GitHub/blogs-McFateM ‹post-095-edits*›
╰─$ git status
On branch post-095-edits
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   content/posts/095-collaborating-on-hugo-site-development.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)
  (commit or discard the untracked or modified content in submodules)

	modified:   themes/hugo-theme-m10c (modified content)
```

This time `git status` is showing me that my `content/posts/095-collaborating-on-hugo-site-development.md` file is "to be committed", and it appears in my terminal in green to indicate that it's "ready to go".  The line that reads `modified:   themes/hugo-theme-m10c (modified content)` still appears in red and is "not staged for commit", and that's OK because I didn't make any necessary changes to that path, the system did, and they don't need to be saved.

So, now we are ready to commit our "staged" changes.

#### git commit -m "Mark's edits to post 095"
The `git commit` command should always include a short but descriptive "message" following a `-m` flag as you see here:

```
╭─mark@Marks-Mac-Mini ~/GitHub/blogs-McFateM ‹post-095-edits*›
╰─$ git commit -m "Mark's edits to post 095"
[post-095-edits d5e2c50] Mark's edits to post 095
 1 file changed, 2 insertions(+), 1 deletion(-)
 ```

 The output indicates that I changed and am committing just one file, where I inserted two new blocks of text, and deleted another.

#### git remote -v
The `git remote...` command is not absolutely necesary, but I use it just to confirm where my next `git push` is going to go. The command lists for me all of the "remotes", the project repositories, that are associated with this project.  In this case:

```
╭─mark@Marks-Mac-Mini ~/GitHub/blogs-McFateM ‹post-095-edits›
╰─$ git remote -v
origin	https://github.com/McFateM/blogs-McFateM.git (fetch)
origin	https://github.com/McFateM/blogs-McFateM.git (push)
```

This indicates that I have just one remote with an alias of `origin`, and any `git push origin...` or `git fetch origin...` commands will reference this blog's project repository on _GitHub_ at https://github.com/McFateM/blogs-McFateM.git.  This is the same repository that I cloned from earlier using `git clone git clone https://github.com/McFateM/blogs-McFateM.git --recursive`.

#### git push origin post-095-edits
This `git push` statement will attempt to "push" my committed changes up to the project's `origin` remote, as described above. The results are:

```
╭─mark@Marks-Mac-Mini ~/GitHub/blogs-McFateM ‹post-095-edits›
╰─$ git push origin post-095-edits
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 6 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 635 bytes | 635.00 KiB/s, done.
Total 5 (delta 4), reused 0 (delta 0)
remote: Resolving deltas: 100% (4/4), completed with 4 local objects.
remote:
remote: Create a pull request for 'post-095-edits' on GitHub by visiting:
remote:      https://github.com/McFateM/blogs-McFateM/pull/new/post-095-edits
remote:
To https://github.com/McFateM/blogs-McFateM.git
 * [new branch]      post-095-edits -> post-095-edits
```

This `git push...` was a success! The committed changes were pushed to my blog's repository where a new `post-095-edits` branch has been created.

### What's Next?
As you can see in the output above, the next step in the process is for someone, presumably the project lead, that's me, to create a `pull request` so that the new `post-095-edits` branch of the project can be tested and merged into the `master` branch. In all of my workflows `master` is the branch that is ultimately used in production. Untill a `pull request` is created, tested, and merged, the changes that we just committed will still not be available to the public.

You can learn more about pull-requests, specifically as they apply to _GitHub_ repositories and workflows, at [https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-requests](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-requests).

<hr/>

And that's a wrap.  Until next time...
