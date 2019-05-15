---
date: 2019-05-15T09:43:21-06:00
title: docker-bootstrap Workflow
---

This post is as much about adding an image to a "live" _Markdown_ document (this blog post), as it is about my [docker-bootstrap](https://github.com/McFateM/docker-bootstrap) workflow.

The workflow is perhaps best described and summarized in a [diagram](https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf) I recently created, and exported to a PDF.  It should be self-explanatory, and with any luck you can see it below...

Posting an "inline" image into a _Markdown_ document is pretty easy using syntax like this:

```
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
```

But, does that work if the "image" is a PDF?  Let's see... nope, not directly.  So the trick appears to be coding the "image" in raw HTML, with a download option for browsers that don't support PDF display, like so:

```
<object data="https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf" type="application/pdf" width="1000px" height="700px">
    <embed src="https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf">
        <p>This browser does not support PDFs. Please download the PDF to view it: <a href="https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf">Download PDF</a>.</p>
    </embed>
</object>
```
<object data="https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf" type="application/pdf" width="1000px" height="700px">
    <embed src="https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf">
        <p>This browser does not support PDFs. Please download the PDF to view it: <a href="https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf">Download PDF</a>.</p>
    </embed>
</object>

And that's a wrap.  Until next time...
