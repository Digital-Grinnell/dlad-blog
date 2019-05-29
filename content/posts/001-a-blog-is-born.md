---
date: 2018-11-18
title: A Blog is Born
tags:
    - docker
    - docksal
    - lets-encrypt
    - ansible
    - hugo
---

Have you ever wondered how a blog is born?  The story behind this blog begins with my interest in stepping back from the CMS world, primarily [Drupal](https://www.drupal.org/), to discover the joys of static site generation.  The journey begins in earnest at the [2016 DLF Forum: Milwaukee](https://www.diglib.org/dlf-events/2016forum/) on the eve of the United States' 2016 national election, when all the buzz that wasn't political, was about building static web sites, and [Jekyll](https://jekyllrb.com/).  

A few weeks after the DLF Forum this server was born, thanks to the my colleagues in the [Grinnell College (GC) Libraries](https://www.grinnell.edu/academics/libraries), and Grinnell's [Information Technology Services (ITS)](https://www.grinnell.edu/about/offices-services/its) department.  *JekyllDev* was its name, and Jelkyll development was its intended purpose. Life and work quickly got in the way of interests, as they are apt to do, and *JekyllDev* subsequently sat idle for nearly 2 years.  During that span my work offered opportunities to learn about 'DevOps' technologies like [Ansible](https://www.ansible.com/), [Vagrant](https://www.vagrantup.com/), [Docker](https://www.docker.com/), and ultimately [Docksal](https://docksal.io/).  

I was introduced to *Docksal* at a *Drupal* conference in the Fall of 2018, and immediately looked for ways to inform my local development work with it.  About the same time there was renewed interest in creation of a static site associated with a project destined to appear in the [Humanities and Social Studies Complex](https://www.eypae.com/client/grinnell-college/humanities-and-social-studies-complex), the HSSC, at Grinnell College. I wondered if *Docksal* could help me, and others at GC, with development of a *Jekyll* site? It could, but along the way I discovered that *Docksal* already had a pre-built 'template' for spinning up development sites in [Hugo](https://gohugo.io/). So I started to play with that...*Hugo* sites created using *Docksal*.  It's an absolutely awesome development workflow!  

Using *Docksal* I was able to quickly spin up _local_ copies of my work, including the blog you are reading now.  But my workflow for pushing content to production was still lacking something.  I wanted an efficient, Docker-based deployment strategy that would accommodate collaborative development and provide quick, automated builds. Fortunately, I stumbled upon the tremendous work of [Juan Treminio](https://jtreminio.com/), specifically his blog post titled [Setting Up a Static Site with Hugo and Push to Deploy](https://jtreminio.com/blog/setting-up-a-static-site-with-hugo-and-push-to-deploy/).  It is exactly what I was looking for. ITS was kind enough to rename *JekyllDev* to something a bit more generic, namely *static*, and this server, `static.grinnell.edu` is the result.

My next post will attempt to chronicle the steps my associates and I took to complete the configuration of `static.grinnell.edu`, and ultimately to create this blog following [Juan Treminio's](https://jtreminio.com/) lead.
