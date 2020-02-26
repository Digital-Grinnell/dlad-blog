---
title: How to Create a New GitHub Repo from an Existing Branch
publishdate: 2020-02-26
lastmod: 2020-02-26T13:55:09-06:00
draft: false
tags:
  - GitHub
  - New
  - Repo
  - Branch
  - Wieting
  - mogtofu33
  - docker-compose-drupal
---

I just found a handy _git_/_GitHub_ workflow in a [Quora](https://www.quora.com) post titled ["How do I create a new GitHub repository from a branch in an existing repository?"](https://www.quora.com/How-do-I-create-a-new-GitHub-repository-from-a-branch-in-an-existing-repository).  And I used it, successfully, to create a new _GitHub_ repo for my updated _Drupal 8_ rendition of the [Wieting Theatre's website](https://Wieting.TamaToledo.com).  

The new _GitHub_ repo is [wieting-D8-DO](https://github.com/SummittDweller/wieting-D8-DO) and it was created from the `wieting` branch of [docker-compose-drupal](https://github.com/SummittDweller/docker-compose-drupal).

The commands I used looked something like this:

```
cd ~/GitHub
git clone https://github.com/SummittDweller/docker-compose-drupal.git
cd docker-compose-drupal
git checkout master
git reset --hard origin/wieting
git checkout wieting
git remote rm origin
git remote add origin https://github.com/SummittDweller/wieting-D8-DO.git
git config user.name "SummittDweller"
git config user.email summitt.dweller@gmail.com
git push -u origin master
```

And that's a wrap... until next time.  :smile:
