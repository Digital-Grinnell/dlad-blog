---
title: Adding a LastMod Date
publishdate: 2019-08-02
lastmod: 2019-08-02T15:18:03-07:00
draft: false
---

So, `Hugo` supports the use of [front matter](https://gohugo.io/content-management/front-matter/) "date" variables including: `date`, `publishDate` and `lastmod`.  I won't explain the details of each variable because the [aforementioned resource](https://gohugo.io/content-management/front-matter/) has a nice, concise explanation of them all.  

Until recently this blog only dealt with the "date" field since I used to have [Atom](https://atom.io) configured to automatically update that field for me when I save changes to a file.  However, `Hugo` treats "date" more like the date of publication (publishDate) than the last modification (lastmod) date, so things got a little screwy if/when I edited an old post.

My latest change aims to fix that...  I've changed "date" to "publishDate" and also added a "lastmod" field to the front matter of new posts.  Along with this I've updated the way the blog posts are sorted, now by "lastmod", not "publishDate", and I've updated Atom so that it automatically updates my "lastmod" date when I edit and save any file.

For the record, all of this involves the [atom-timestamp](https://atom.io/packages/atom-timestamp) package and a "Timestamp prefix" setting of:
```
[lastmod|Updated]:[ \t]+["]?
```

And that's a wrap.  Until next time...
