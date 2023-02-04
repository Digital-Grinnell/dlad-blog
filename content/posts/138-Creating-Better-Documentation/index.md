---
title: Creating Better Documentation
publishDate: 2023-02-04T10:36:03-06:00
last_modified_at: 2023-02-04T15:33:00
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

I used the tool to post-process the dynamic screen capture made while building portions of this post.  Some of the images generated from that screen capture may appear below, with a bit of explanation.  

## Conversion Workflow

This section will walk us through the workflow I've developed for turing a `.mov` into images, and then into _figure_ markdown like this example:  

```
{{% figure title="Rename the Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F0.png" %}}
```

### 1) Rename the Screen Capture  

The first step is to change the screen capture `.mov` filename to something memorable as shown in the next two figures.  

{{% figure title="Rename the Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F0.png" %}}  

{{% figure title="The Renamed Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F1.png" %}}  

### 2) Drag the Renamed `.mov` Into VSCode  

Drag the renamed `.mov` file into the _VSCode_ window and the _convert_to_video_frames_ project window as shown below.  

{{% figure title="The Renamed Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F2.png" %}}  

### 3) Run the `main.py` Script  

Running the `main.py` script using a command of the form shown below processes the specified `.mov` file to create a large number of `.png` image frames.  The images are saved in a directory with the same name as the `.mov` file as shown in the figure below.  

{{% figure title="Running the `main.py` Script" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F5.png" %}}  

The command used in the above figure was:  

```
python main.py -p "Creating-Azure-Static-Web-App.mov" -r 50 -s ".png"  
```

That command syntax is documented in the [convert one video](https://github.com/SummittDweller/convert_videos_to_frames#convert-one-video) section of the _convert\_video\_to\_frames_ project `README.md` file.    

### 4) Delete Unnecessary Images and Add Annotations in VSCode

My configuration of _VSCode_ is equipped with a simple image editor extension, so in the next step in my workflow I use that extension to browse through the images.  While browsing I delete any images that I don't need.  I frequently add simple annotations -- like the red boxes and lines seen in the previous figure -- to those images I want to use.  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F8.png" %}}  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F13.png" %}}  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F15.png" %}} 

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F16.png" %}} 

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F17.png" %}} 

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F18.png" %}} 

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F19.png" %}} 

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F24.png" %}} 

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F32.png" %}} 

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F170.png" %}}  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F180.png" %}}  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F189.png" %}}  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F208.png" %}}

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F229.png" %}}

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F259.png" %}}  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F264.png" %}}  

{{% figure title="Needs a Title" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation%2F675.png" %}}  

