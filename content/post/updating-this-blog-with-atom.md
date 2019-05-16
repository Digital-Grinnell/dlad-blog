---
date: 2019-05-16T13:41:37-06:00
title: Updating This Blog with Atom
---

So I have my [Atom](https://atom.io/) config stored in a [Github repo](https://github.com/SummittDweller/Atom-Config) so that I can easily keep _Atom_ in-sync between the various platforms I use here and at home. Today I added the [atom-shell-commands](https://atom.io/packages/atom-shell-commands) package to my _Atom_ config and have configured it with a “command” that takes care of updating my blog when I add a new post (like this one).

The command configuration in my `.atom/config.cson` looks like this:

```
"atom-shell-commands":
  commands: [
    {
      name: "Update My Blog"
      command: "./update-blog.sh"
      options:
        cwd: "{ProjectDir}"
        keymap: 'ctrl-2'
        save: "True"
    }
  ]
```

The `./update-blog.sh` script referenced in the configuration contains:

```
  #!/bin/bash
  cd ~/Projects/blogs-McFateM
  docker image build -t blog-update .
  docker login
  docker tag blog-update mcfatem/blogs-mcfatem:latest
  docker push mcfatem/blogs-mcfatem:latest
```

If you’re reading this from my blog site then it must be working because I used the new command to push this content to the site!

And that’s a wrap. Until next time…
