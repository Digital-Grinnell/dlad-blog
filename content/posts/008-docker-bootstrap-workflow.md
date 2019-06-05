---
date: 2019-05-15
title: docker-bootstrap Workflow
---

This post is as much about adding an image to a "live" _Markdown_ document (this blog post), as it is about my [docker-bootstrap](https://github.com/McFateM/docker-bootstrap) workflow.

The workflow is perhaps best described and summarized in a [diagram](https://github.com/McFateM/docker-bootstrap/blob/master/docker-bootstrap%20Diagram.pdf) I recently created, and exported to a PDF.  It should be self-explanatory, and with any luck you can see it below...

Posting an "inline" image into a _Markdown_ document is pretty easy using syntax like this:

```
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
```

But, does that work if the "image" is a PDF?  Let's see... nope, not directly.  

So the trick appears to be coding the "image" in raw HTML, with a download option for browsers that don't support PDF display, like so:

```
<object data="https://github.com/McFateM/docker-bootstrap/raw/master/docker-bootstrap-Diagram.pdf" type="application/pdf" width="1000px" height="700px">
    <embed src="https://github.com/McFateM/docker-bootstrap/raw/master/docker-bootstrap-Diagram.pdf">
        <p>This browser does not support PDFs. Please download the PDF to view it: <a href="https://github.com/McFateM/docker-bootstrap/raw/master/docker-bootstrap-Diagram.pdf">Download PDF</a>.</p>
    </embed>
</object>
```

<object data="https://github.com/McFateM/docker-bootstrap/raw/master/docker-bootstrap-Diagram.pdf" type="application/pdf" width="1000px" height="700px">
    <embed src="https://github.com/McFateM/docker-bootstrap/raw/master/docker-bootstrap-Diagram.pdf">
        <p>This browser does not support PDFs. Please download the PDF to view it: <a href="https://github.com/McFateM/docker-bootstrap/raw/master/docker-bootstrap-Diagram.pdf">Download PDF</a>.</p>
    </embed>
</object>

But in the case of a Github hosted PDF, that also does not work as I get a `Blocked by Content Security Policy` error for the PDF portion of the page, or at best, my browser is unable to display the PDF so I see the line/paragraph above this one.

So what next?  I reverted back to _Markdown_ syntax referencing a _.png_ copy of the diagram instead of the PDF:

![Workflow](https://github.com/McFateM/docker-bootstrap/raw/master/docker-bootstrap-Diagram.png "Mark's docker-bootstrap Workflow")

That appears to work nicely!  Two things to note...

- Be sure you reference the "raw" copy of the diagram from Github, not the "blob" that's displayed on the repo's Github page.
- I used [draw.io](https://draw.io) to create and export this diagram.  When I export it as a _.png_ I have to be sure to include a 20 pixel "border", otherwise my image has no margins and looks really bad in a browser with a dark page background.

And that's a wrap.  Until next time...
