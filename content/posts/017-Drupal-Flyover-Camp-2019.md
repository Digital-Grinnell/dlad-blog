---
date: 2019-06-01T12:10:33-06:00
title: Drupal Flyover Camp 2019
---

The last couple days I attended [Drupal Flyover Camp 2019](https://www.flyovercamp.org/) at UMKC in Kansas City, MO.  I picked up on a few tricks and tools that I thought I'd mention here, just so I don't forget some of the details.

### Friday - Day 1

My favorite presentation of the day was [Visual Regression Testing with BackstopJS](http://visual-regression.davidneedham.me) by [David Needham](https://twitter.com/davidneedham). There's some cool tech here that I think could be very useful with things like [Digital Grinnell](https://digital.grinnell.edu), [Rootstalk](https://rootstalk.grinnell.edu), and even [this blog](https://static.grinnell.edu/blogs/McFateM).

David Needham's presentation also included some live command line work and I was also impressed with his terminal and environment.  David used [iTerm2](https://www.iterm2.com/index.html) as a replacement for the standard Mac "Terminal" app, and combined that with [Z shell or 'zsh'](https://en.wikipedia.org/wiki/Z_shell#Oh_My_Zsh) instead of 'bash'.  I have since started using both and am finding lots of nice features that I believe will help me in my work.  I've adopted the [bira](https://github.com/robbyrussell/oh-my-zsh/wiki/themes#bira) theme for 'zsh' and am loving it.  David also shared a [gist](https://gist.github.com/davidneedham/4014378) with some nice 'bash' profile improvements.

From David's presentation I was also encouraged to learn how to launch [Atom](https://atom.io/) from the command line.  That simple change is [documented here](https://www.google.com/search?client=firefox-b-1-d&q=launch+atom+from+the+command+line).  

I also attended the session titled [Bringing Sanity to Your Git Workflow](https://www.flyovercamp.org/schedule/bringing-sanity-your-git-flow) and picked up on a couple of gems from presenter [Josh Fabean](https://www.drupal.org/u/joshfabean).  

The first of Josh's gems was `git add -p` or `--patch`, an option that lets you interactively pick and choose only those modifications that you want added, or indexed, for a commit.  The option gives the user ability to review differences in individual files before adding modified contents to the index.

The second gem is this [visualizing-git online tool](https://git-school.github.io/visualizing-git/).  Check it out.

### Saturday - Day 2

[Jeff Geerling's](https://www.jeffgeerling.com/) presentation of [Everything I Know About Kubernetes I Learned from a Cluster of Raspberry Pis](https://www.flyovercamp.org/schedule/everything-i-know-about-kubernetes-i-learned-cluster-raspberry-pis) was both informative and entertaining.  Great stuff.  I was especially pleased to see that Jeff still relies on [Ansible](https://www.ansiblefordevops.com/) as his "golden hammer".  I think I will revisit his book and get back in the habit of using _Ansible_.  I also recommend keeping an eye on [Jeff's blog](https://www.jeffgeerling.com/blog) and [projects list](https://www.jeffgeerling.com/projects).

[Tess Flynn, aka 'socketwench'](https://twitter.com/socketwench?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor) conducted another high-energy presentation, this time it was [Dr. Upal is In: Healthcheck Your Site!](https://socketwench.github.io/healthcheck-your-site/#/).  From this presentation I'll follow-up with a look at the details of the [Site Audit Module](drupal.org/project/site_audit), the [Healthcheck Module](drupal.org/project/healthcheck), and [Hacked!](https://www.drupal.org/project/hacked).  

Last, but not least, was the [Regression Resolved: Compare Months of Commits in Seconds with Git Bisect](https://www.flyovercamp.org/schedule/regression-resolved-compare-months-commits-seconds-git-bisect) presentation by [David Needham](https://twitter.com/davidneedham).  Simply awesome.

And that's a wrap.  Until next time...
