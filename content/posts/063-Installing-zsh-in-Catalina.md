---
title: Installing ZSH in Catalina
publishdate: 2020-02-12
lastmod: 2020-02-12T10:41:51-06:00
draft: false
tags:
  - zsh
  - Oh My ZSH!
  - bira
  - OS X
  - Mac
  - Catalina
---

These days I like to do all my terminal/command-line work in _zsh_, more specifically, with [Oh My ZSH!](https://ohmyz.sh/) and the [bira](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/bira.zsh-theme) theme.  This [previous post](https://static.grinnell.edu/blogs/McFateM/posts/044-installing-zsh-in-centos/) described the process I used on each of my _Linux_ servers, and this post is similar, but written specifically for my _Catalina_ (_Macintosh OS X v10.15.x_), workstations.  

This is how I installed and configured _zsh_, and some other goodies, on my student _Mac Mini_ workstation, `MA6879`...

```
brew update
brew install nano zsh
chsh -s /bin/zsh mark
exit   # log back in after this
echo $SHELL
brew install wget git hugo  # Hugo added just for good measure
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
source ~/.zshrc
cd ~/.oh-my-zsh/themes/
ls -a
nano ~/.zshrc   # In the editor add (or replace similar) the following lines but without the leading #
                #  ZSH_THEME='bira'
                #  plugins=(git extract web-search yum git-extras docker)
exit   # log back in after this
```

And that's a wrap... until next time.  :smile:
