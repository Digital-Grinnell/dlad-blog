---
title: "Moving Static Sites to GitHub Pages"
publishDate: 2021-10-05
lastmod: 2021-10-05T16:59:11-05:00
draft: false
tags:
  - static
  - Hugo
  - GitHub Pages
---

{{% annotation %}}
Attention: This post effectively superseeds [post 109](content/posts/109-moving-static-sites-to-azure.md.md).
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

## publishDir = "docs"

Note that in all cases I found it necessary to conform to _GitHub_ practice of publishing content from a `./docs` site subdirectory rather than from `./public`, the default _Hugo_ behavior.  Publishing from `./docs` is default behavior for _Jekyll_, and that static generator is commonly used in _GitHub_ pages. The `./docs` setting typically appears in a site's front matter within `config.toml` as: `publishDir = "docs"`.

## gh-pages.yml

[Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/) directs us to create a new `.github/workflows/gh-pages.yml` file in each project.  This file directs _GitHub_ to build a _Hugo_ site each time a triggering event, like a "push", takes place.

The document specifies the file contents to be:

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

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          # extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

I find that setting the last line to read `publish_dir: ./doc` makes more sense based on changes documented in the previous section; however, leaving this parameter set to `./public` also seems to work.

## GitHub Pages Settings

To complete the process of creating a _GitHub Pages_ site you'll need to visit your repository's [GitHub Pages Settings](https://github.com/Digital-Grinnell/Digital-Grinnell.github.io/settings/pages) page and make selections like you see in the figure below.  The example below is taken from https://github.com/Digital-Grinnell/Digital-Grinnell.github.io/settings/pages.

{{% figure title="GH Pages Settings" src="/images/post-112/gh-pages-setting.png" %}}

# Address and Repo Tabulation

| CNAME Assigned               | New GH Address                      | GitHub Repo   | Old Address |
| ---                          | ---                                 | ---           | ---         |
| https://static.grinnell.edu/ | https://digital-grinnell.github.io/ | https://github.com/Digital-Grinnell/Digital-Grinnell.github.io | https://static.grinnell.edu |
| https://static.grinnell.edu/dlad-blog/ | https://digital-grinnell.github.io/dlad-blog/ | https://github.com/Digital-Grinnell/dlad-blog | https://static.grinnell.edu/blogs-McFateM |
|   |   |   |   |


And that's a wrap. Until next time...
