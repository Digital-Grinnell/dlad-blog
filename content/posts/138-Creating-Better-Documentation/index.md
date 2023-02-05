---
title: Creating Better Documentation
publishDate: 2023-02-04T10:36:03-06:00
last_modified_at: 2023-02-04T22:29:52
draft: false
description: A new approach to creating better documentation here.
tags:
  - documentation
  - Azure
azure: 
  dir: https://sddocs.blob.core.windows.net/documentation/
  subdir: Better-Documentation  
---

# We Need More <strike>Cow Bell</strike> Screen Capture!

On a recent project I found myself following some development guidance provided in [Deploying an 11ty Site to Azure Static Web Apps](https://squalr.us/2021/05/deploying-an-11ty-site-to-azure-static-web-apps/) and I really like the work that [squalrus](https://github.com/squalrus) did here because **there's a nice mix of screen capture images and descriptive text**.  I think my documentation, at least in the past, has been lacking in images.  Time to fix that.  

# Command - Shift - 5

On my Mac I frequently use the `command - shift - 5` key sequence to launch _dynamic_ -- think movie, not image -- screen capture.  I did just that moments ago, so some of what you'll see below is a result of that maneuver.  :smile:  

So, now when I begin a new bit of development I use `command - shift - 5` to open a capture control like you see in the image below, and I capture every keystroke, command, and click as I work.  When finished I use `command - shift - 5` again to re-open the control, click `stop` (the square block control shown in the figure below), and presto, I have a new `.mov` file captured and ready for edting.  

{{% figure title="Use `Command - Shift - 5 to Stop Recording" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0675.png" %}}  

# Convert Videos to Frames

Embedding a raw `.mov` file into my documenation is possible, but more often that not the files are HUGE, and they contain LOTS of unnecessary, boring minutes.  All I really need is a sequence of images, perhaps with annotations, gleaned from the movie.  That's where [github.com/SummittDweller/convert_videos_to_frames](https://github.com/SummittDweller/convert_videos_to_frames) comes in.  

The aformentioned Python code repository was forked from [github.com/anas-899/convert_videos_to_frames](https://github.com/anas-899/convert_videos_to_frames), and I made very few changes to that excellent starting point.  Honestly, all that I did was apply my preferred Python project process, namely [Proper Python](https://blog.summittdweller.com/posts/2022/09/proper-python/).  

I used the tool to post-process the dynamic screen capture made while building portions of this post.  Some of the images generated from that screen capture may appear below, with a bit of explanation.  

## Conversion Workflow

This section will walk us through the workflow I've developed for turing a `.mov` into images, and then into _figure_ markdown like this example:  

```
{{% figure title="Rename the Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0000.png" %}}
```

{{% box %}}
Note that while composing this document I found it's best if image files have zero-padded numeric names, so `123.png` should be `0123.png`.  This helps keep the images in numerical order everywhere.

Some screen images in this document still appear in the old, unpadded naming convention.  
{{% /box %}}  

### 1) Rename the Screen Capture  

The first step is to change the screen capture `.mov` filename to something memorable as shown in the next two figures.  

{{% figure title="Rename the Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0000.png" %}}  

{{% figure title="The Renamed Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0001.png" %}}  

### 2) Drag the Renamed `.mov` Into VSCode  

Drag the renamed `.mov` file into the _VSCode_ window and the _convert_to_video_frames_ project window as shown below.  

{{% figure title="The Renamed Screen Capture" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0002.png" %}}  

### 3) Run the `main.py` Script  

Running the `main.py` script using a command of the form shown below processes the specified `.mov` file to create a large number of `.png` image frames.  The images are saved in a directory with the same name as the `.mov` file as shown in the figure below.  

{{% figure title="Running the `main.py` Script" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0005.png" %}}  

The command used in the above figure was:  

```
python main.py -p "Creating-Azure-Static-Web-App.mov" -r 50 -s ".png"  
```

That command syntax is documented in the [convert one video](https://github.com/SummittDweller/convert_videos_to_frames#convert-one-video) section of the _convert\_video\_to\_frames_ project `README.md` file.    

### 4) Delete Unnecessary Images and Add Annotations in VSCode

My configuration of _VSCode_ is equipped with a simple image editor extension, so in the next step in my workflow I use that extension to browse through the images.  While browsing I delete any images that I don't need.  I frequently add simple annotations -- like the red boxes and lines seen in the previous figure -- to those images I want to use.  

Sorry, I didn't capture any screen images from this culling and annotation process. :frowning:  

### 5) Upload Necessary Images to Azure Storage

Lots of `.png` images should not be pushed to _GitHub_, so I typically push the images to _Azure Storage_ and reference them in _figure_ shortcodes like the one shown above in _Conversion Workflow_.  

I've established a procedure that works nicely for adding a directory of images to _Azure Storage_.  It looks something like this:

- In _VSCode_ navigate to the directory containing necessary images, right-click on that directory name, and choose `Upload to Azure Storage...` from the pop-up menu as illustrated in the figure below.

{{% figure title="Right Click on the Directory and Choose Azure" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0008.png" %}}  

- Again in _VSCode_, choose a _Storage Account_ -- this is usually `sddocs` for me -- from the drop-down list that appears at the top of the window.

{{% figure title="Choose a Storage Account" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0013.png" %}}  

- In the `Select resource type` drop-down at the top of the window, select `Blob Containers` as illustrated below.  

{{% figure title="Select Blob Containers Resource Type" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0015.png" %}} 

- Next, choose a _Blob Container_ -- this is usually `documentation` for me -- from the `Select Blob Container` drop-down list that appears at the top of the window as illustrated below.

{{% figure title="Choose a Blob Container" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0016.png" %}} 
 
- In the `Enter the destination directory...` leave the `/` and press `Enter` to select it as illustrated below.  This will preserve the name of your selected local directory in _Azure Storage_.    

{{% figure title="Enter the Destination Directory" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0019.png" %}}  

- The `Azure: Activity Log` screen in _VSCode_ should now reflect the status of the upload, and a pop-up message may appear in the lower-right corner of the window as illustrated below.  

{{% figure title="Check the Azure Activity Log" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0032.png" %}} 

- When the upload is complete the `Azure: Activity Log` screen in _VSCode_ should indicate this as will the pop-up message in the lower-right corner of the window.    

{{% figure title="Upload is Complete" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0060.png" %}}  

- You can check the upload status using the `Azure` extension on the left side of the _VSCode_ window.  

{{% figure title="Check the Upload Using the Azure Extension" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0170.png" %}}  

- In the `Azure` extension navigation pane expand the `Resources` element, the subordinate `subscription` element, the `Storage accounts` element, and `Blob Container` + directory structure to find the destination directory.    

{{% figure title="Select the Destination Directory" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0189.png" %}}  

- You should be able to navigate and find the uploaded files to confirm that the upload was a success.  

{{% figure title="Verifying the Upload" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0208.png" %}}

- If needed, you can retrieve the URL of the _Azure_ resource by right-clicking on the filename and choosing the `Copy URL` element in the drop-down.  

{{% figure title="Copy An Image's URL" src="https://sddocs.blob.core.windows.net/documentation/Better-Documentation/0229.png" %}}  


