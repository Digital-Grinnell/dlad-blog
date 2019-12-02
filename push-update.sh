#!/bin/bash
cd ~/GitHub/blogs-McFateM
# perl -i.bak -lpe 'BEGIN { sub inc { my ($num) = @_; ++$num } } s/(build = )(\d+)/$1 . (inc($2))/eg' config.toml
docker image build -t blog-update .
docker login
docker tag blog-update mcfatem/blogs-mcfatem:latest
docker push mcfatem/blogs-mcfatem:latest
