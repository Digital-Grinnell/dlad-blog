---
title: Creating Better Documentation
publishDate: 2023-02-04T10:36:03-06:00
last_modified_at: 2023-02-04T11:29:17
draft: false
description: A new approach to creating better documentation here.
tags:
  - documentation
  - Azure
---

# We Need More <strike>Cow Bell</strike> Screen Capture!

On a recent project I found myself following some development guidance provided in [Deploying an 11ty Site to Azure Static Web Apps](https://squalr.us/2021/05/deploying-an-11ty-site-to-azure-static-web-apps/) and I really like the work that [squalrus](https://github.com/squalrus) did here because **there's a nice mix of screen capture images and descriptive text**.  I think my documentation, at least in the past, has been lacking in images.  Time to fix that.  

# Command - Shift - 5

On my Mac I frequently use the `command - shift - 5` key sequence to launch _dynamic_ -- think movie, not image -- screen capture.  I did just that moments ago, so some of what you'll see below is a result of that maneuver.  :smile:  

So, now when I begin a new bit of development I use `command - shift - 5` to open a capture control like you see in the image below, and I capture every keystroke, command, and click as I work.  When finished I use `command - shift - 5` again to re-open the control, click `stop` (the square block control), and presto, I have a new `.mov` file captured and ready for edting.  

# Convert Videos to Frames

Embedding a raw `.mov` file into my documenation is possible, but more often that not the files are HUGE, and they contain LOTS of unnecessary, boring minutes.  All I really need is a sequence of images, perhaps with annotations, gleaned from the movie.  That's where [github.com/SummittDweller/convert_videos_to_frames](https://github.com/SummittDweller/convert_videos_to_frames) comes in.  

The aformentioned Python code repository was forked from [github.com/anas-899/convert_videos_to_frames](https://github.com/anas-899/convert_videos_to_frames), and I made very few changes to that excellent starting point.  Honestly, all that I did was apply my preferred Python project process, namely [Proper Python](https://blog.summittdweller.com/posts/2022/09/proper-python/).  

I used the tool to post-process the dynamic screen capture made while building this post.  Some of the images generated from that screen capture appear below, with a bit of explanation.  

{{% figure title="Referencing a Documentation Image" src="https://sddocs.blob.core.windows.net/documentation/Creating-Azure-Static-Web-App%2F1030.png" %}}




```
(.venv) ╭─mark@Marks-Mac-Mini ~/GitHub/convert_videos_to_frames ‹main*› 
╰─$ python main.py -p "Screen-Recording-01.mov" -r 20 -s ".png"                                
processing:Screen-Recording-01.mov
Screen-Recording-01/
```
