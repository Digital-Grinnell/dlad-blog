---
title: "VSCode Find and Replace Using `regex`"
publishdate: 2022-10-08
draft: false
tags:
  - VSCode
  - regex
  - find
  - replace
  - Rootstalk
---

This morning I needed to do some bulk "find and replace" operations in most of my [Rootstalk](https://rootstalk.grinnell.edu) content.  My first thought was to write and run a little Python script, but then I wondered what _VSCode_ might bring to the table.  Plenty, it brought plenty!

To keep this post as brief as possible, I'm simply going to reference an instructional video that I created earlier: [VSCode-Find-and-Replace.mp4.](VSCode-Find-and-Replace.mp4)  

A list of some links mentioned in the video is provided here:

  - https://linuxpip.org/vscode-regex-replace/
  - https://itnext.io/vscode-find-and-replace-regex-super-powers-c7f8be0fa80f
  - https://www.educative.io/answers/regex-search-and-replace-with-vs-code
  - https://www.youtube.com/watch?v=xMhKstbdr3k
  - https://remisharrock.fr/post/regex-search-and-replace-visual-studio-code/

If you're looking specifically to install and run the `regex-previewer` extension check out:

  - https://marketplace.visualstudio.com/items?itemName=chrmarti.regex
  - https://stackoverflow.com/questions/51389446/using-the-vscode-regex-plugin

Since _Rootstalk_ code is in a private repo, I'm including the contents of my `link-format.js` file here:

```javascript
var find_period = /\[(.+)\]\((.+)\)\./

var replace_period = /[$1.]($2) /

var find_comma = /\[(.+)\]\((.+)\)\,/

var replace_comma = /[$1,]($2) /
```


