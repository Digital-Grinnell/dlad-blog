---
title: "Moving Static Sites to GitHub Pages"
publishDate: 2021-10-05
lastmod: 2021-10-05T22:01:20-05:00
draft: false
tags:
  - static
  - Hugo
  - GitHub Pages
---

{{% annotation %}}
Attention: This post effectively superseeds [post 109](/posts/109-moving-static-sites-to-azure).
{{% /annotation %}}

# Pertinent Resources

This section simply tabluates the posts and documentation used to effect migration of all sites from the _Grinnell College_ `static` host to _GitHub Pages_.

| Resource | Address |
| ---      | ---     |
| Hugo: Host on GitHub | https://gohugo.io/hosting-and-deployment/hosting-on-github/ |
| GitHub: Getting started with GitHub Pages | https://docs.github.com/en/pages/getting-started-with-github-pages |
| GitHub: Creating a GitHub Pages site | https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site |
| GitHub: Managing a custom domain for your GitHub Pages site | https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-a-subdomain |

# Customizations

## Do NOT Set `publishDir = "docs"`

Do *NOT* change the `publishDir` parameter in your configuration, if you even have one!  The default `public` setting is correct.

## gh-pages.yml

[Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/) directs us to create a new `.github/workflows/gh-pages.yml` file in each project.  This file directs _GitHub_ to build a _Hugo_ site each time a triggering event, like a "push", takes place.

The document specifies the following contents plus a few additions of my own:

```
name: github pages

on:
  push:
    branches:
      - main  # Set a branch to deploy
  pull_request:

jobs:
  deploy:
    runs-on: ubuntu-20.04
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - uses: szenius/set-timezone@v1.0  # per https://github.com/marketplace/actions/set-timezone
        with:
          timezoneLinux: "America/Chicago"

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

## GitHub Pages Settings

It's not documented well, but *important to note* that this workflow will create a new `gh-pages` branch of your repo and the `root` of that branch is what you should publish! _**Pay attention to those settings in the figure below!**_

To complete the process of creating a _GitHub Pages_ site you'll need to visit your repository's [GitHub Pages Settings](https://github.com/Digital-Grinnell/Digital-Grinnell.github.io/settings/pages) page and make selections like you see in the figure below.  The example below is taken from https://github.com/Digital-Grinnell/Digital-Grinnell.github.io/settings/pages.

{{% figure title="GH Pages Settings" src="/images/post-112/gh-pages-settings.png" %}}

# Completed Migrations

| CNAME Assigned               | New GH Address                      | GitHub Repo   | Old Address |
| ---                          | ---                                 | ---           | ---         |
| https://static.grinnell.edu/ | https://digital-grinnell.github.io/ | https://github.com/Digital-Grinnell/Digital-Grinnell.github.io | https://static.grinnell.edu |
| https://static.grinnell.edu/dlad-blog/ | https://digital-grinnell.github.io/dlad-blog/ | https://github.com/Digital-Grinnell/dlad-blog | https://static.grinnell.edu/blogs-McFateM |
|   |   |   |   |


And that's a wrap. Until next time...
