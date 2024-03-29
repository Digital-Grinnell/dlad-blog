---
title: "Creating a `git` Hook"
publishdate: 2022-10-27
draft: false
tags:
  - git
  - hook
  - last_modified_at
  - pre-commit
  - clean
last_modified_at: 2023-01-20T20:20:24
---

I recently created [Hugo Front Matter Tools](https://github.com/Digital-Grinnell/hugo-front-matter-tools) which is described as...

_A collection of Python scripts desinged to help manage [Hugo](https://gohugo.io) `.md` content [front matter](https://gohugo.io/content-management/front-matter/)._

I already have mechanisms in many projects, like this blog, that help me report the last time ANY content was pushed to _GitHub_, or the last time a _Hugo_ site was compiled.  But it would be nice, especially in the case of _Rootstalk_, if I could save the last `git add` date/time into an individual file's front matter.  That way the tools mentioned above could leverage and report that valuable information.

## Creating a `git` Hook

While searching for possibilities this morning I ran across [this post](https://stackoverflow.com/a/17360528) which I'll repeat here in case the original is ever lost...

{{% original %}}
It turns out you can run "hooks" - they are actually handled by another mechanism - when staging files (at `git add` time):

https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes#_keyword_expansion

(scroll down a bit to the "smudge" and "clean" diagrams)

Here is what I understood :

    edit the .gitattributes, and create rules for the files which should trigger a dictionary update:

    novel.txt filter=updateDict

    Then, tell Git what the updateDict filter does on smudge (`git checkout`) and clean (`git add`):

    $ git config --global filter.updateDict.clean countWords.script

    $ git config --global filter.updateDict.smudge cat

{{% /original %}}

## My First Hook

Here are some of the details surrounding my first `git` hook...

- Purpose: To add or update a `last_modified_at:` front matter field with the current local date/time whenever a `git add` operation touches a `.md` (Markdown) file in a specific project.

- Projects: Initially I'll try to implement this on [this blog project](https://github.com/Digital-Grinnell/dlad-blog).  If that works, I'll happily apply it to [the Rootstalk project](https://github.com/Digital-Grinnell/rootstalk).

- Improvements: What follows will only work if the `last_modified_at:` field already exists in a file's front matter.  What happens if we are working with a file that does NOT already have that field?

For initial implementation I'm going to follow the advice found in [Adding last modified timestamps with Git](https://mademistakes.com/notes/adding-last-modified-timestamps-with-git/).  The shell script in that post reads like this:

```sh
#!/bin/sh
# Contents of .git/hooks/pre-commit
# Replace `last_modified_at` timestamp with current time

git diff --cached --name-status | egrep -i "^(A|M).*\.(md)$" | while read a b; do
  cat $b | sed "/---.*/,/---.*/s/^last_modified_at:.*$/last_modified_at: $(date -u "+%Y-%m-%dT%H:%M:%S")/" > tmp
  mv tmp $b
  git add $b
done
```

I created the same `pre-commit` script in this project's `.git/hooks/` directory.  Now to test it...

### Initial Test

```txt
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git status
On branch main
Your branch is up to date with 'origin/main'.
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git add .
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git commit -m "Testing my pre-commit hook"
hint: The '.git/hooks/pre-commit' hook was ignored because it's not set as executable.
hint: You can disable this warning with `git config advice.ignoredHook false`.
[main 0b9781d7] Testing my pre-commit hook
 3 files changed, 74 insertions(+)
 create mode 100644 content/posts/131-Creating-a-git-Hook.md
```

So, I changed the `pre-commit` hook permissions and tried again after adding a bit more to this `.md` file.

```
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main› 
╰─$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   content/posts/131-Creating-a-git-Hook.md

no changes added to commit (use "git add" and/or "git commit -a")
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git add .
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git commit -m "2nd test of pre-commit hook"
[main 49118af7] 2nd test of pre-commit hook
 1 file changed, 23 insertions(+), 1 deletion(-)
 ```

It worked!  The `.md` file for this post now includes a line of front matter that says `last_modified_at: 2022-10-27T16:02:09` in both my local AND _GitHub_ repository versions.  Hurrah!

### More Testing

Now, what happens if I `git add` and `git commit` more test files including:

  - `test1.md` - A `.md` file that has no `last_modified_at:` front matter key,
  - `test2.txt` - A `.txt` file that has an empty `last_modified_at:` front matter key, and
  - `test3.png` - A `.png` image file that, of course, has no `last_modified_at:` front matter key.

```
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   content/posts/131-Creating-a-git-Hook.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        content/test1.md
        content/test2.txt
        content/test3.png

no changes added to commit (use "git add" and/or "git commit -a")
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git add .
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*› 
╰─$ git commit -m "Three-part pre-commit hook test"
[main 1b20a2a8] Three-part pre-commit hook test
 4 files changed, 202 insertions(+), 1 deletion(-)
 create mode 100644 content/test1.md
 create mode 100644 content/test2.txt
 create mode 100644 content/test3.png
 ```

 Looking at the three files (actually, four files including this blog post) and...  **BEAUTIMOUS!**   
 
  _Everything worked as it should!_  
  Now, let's see if I can improve on the rather cryptic format of the date/time that gets added.

To do that, change the `git diff...` line in `.git/hooks/pre-commit` to use the `TZ` timezone setting and remove the `-u` flag so that we get local time like so:

```
git diff --cached --name-status | egrep -i "^(A|M).*\.(md)$" | while read a b; do
  cat $b | sed "/---.*/,/---.*/s/^last_modified_at:.*$/last_modified_at: $(TZ=CST6CDT date "+%F %H.%M %Z")/" > tmp
```

Notice also that this format does not include ANY colons (I'm using a `.` between hour and minute instead) so there should be no need to quote the value.

:drum:  **It works!**

In fact, it works so well that I'm keeping a copy of the `pre-commit` script [here](https://github.com/Digital-Grinnell/dlad-blog) in this blog's repo.

# Now I Need An Install Script

The `pre-commit` script works exceptionally well, but since it lives in each project's `/.git/hooks` directory, one that is NEVER pushed to the project's remote, it would be nice to have a semi-automatic way of creating it in a repo.  

This notion got me wondering... is there already a suitable "git hook manager" (that is the phrase I Googled) that I can use for this?  Yes, I beleive there might very well be one based on these results from my Google search:

  - https://github.com/aitemr/awesome-git-hooks - Just a list of cool hooks.  
  - https://github.com/evilmartians/lefthook - Interesting, but perhaps more than I need?  
  - https://pre-commit.com/ - Also interesting, but again it's perhaps too much.  
  - https://stackoverflow.com/questions/427207/can-git-hook-scripts-be-managed-along-with-the-repository - A great discussion!
  - https://githooks.com/ - The discussion above led me here, and from here, anything seems possible!
  - https://github.com/sds/overcommit - Nice, but again, too complex.  
  - https://github.com/boddenberg-it/.githooker - Maybe, but I found the sparse documentation a little confusing.

  - https://medium.com/@ripoche.b/using-global-pre-commit-hook-to-prevent-committing-unwanted-code-edbbf957ad12 - **My choice because it's relatively simple with no unnecessary dependencies.**  See below.  

# Implementing a Global Pre-Commit Hook

Here we go, at 2023-01-20T13:13:17-06:00 I embarked on an effort to implement portions of [Using global pre-commit hook to prevent committing unwanted code](https://medium.com/@ripoche.b/using-global-pre-commit-hook-to-prevent-committing-unwanted-code-edbbf957ad12) on my Mac Mini in this [dlad-blog](https://github.com/Digital-Grinnell/dlad-blog) project using my existing `pre-commit` hook.   

My relevant command history...  

{{% code %}}
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*›  
╰─$ git --version  
git version 2.39.1  
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*›  
╰─$ **mkdir -p ~/gitconfig/hooks**  
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*›  
╰─$ **mv -f .git/hooks/pre-commit ~/gitconfig/hooks/.**  
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*›   
╰─$ **git config \-\-global \-\-edit**  
╭─mark@Marks-Mac-Mini ~/GitHub/dlad-blog ‹main*›  
╰─$ cd ~; pwd  
/Users/mark  
{{% /code %}}

The last `git` command above opened my global git configuration file, `/Users/mark/.gitconfig` in `nano`, where I added this line to the `[core]` section:  

  - `hooksPath = /Users/mark/gitconfig/hooks`

Now it's time to commit all these changes to see if my new global git config works. :drum:  **Yup!**  The frontmatter at the top of this `.md` file just changed to include the current date/time: `last_modified_at: 2023-01-20 13.29 CST`.  Bingo!  

---

There might be more to learn here, but for now... that's a wrap.  
