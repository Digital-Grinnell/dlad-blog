#!/bin/bash
# cd ~/GitHub/blogs-McFateM
current=`git symbolic-ref --short -q HEAD`
git checkout ${current}
perl -i.bak -lpe  'BEGIN { sub inc { my ($num) = @_; ++$num } } s/(build = )(\d+)/$1 . (inc($2))/eg' config.toml
# compile the site before copying to the new image
hugo --ignoreCache --ignoreVendor --minify --debug --verbose
echo "Hugo compilation is complete."
echo "Starting docker image build..."
docker image build -f push-update-Dockerfile --no-cache -t blog-update .
echo "docker image build is complete."
docker login
docker tag blog-update mcfatem/blogs-mcfatem:latest
docker push mcfatem/blogs-mcfatem:latest
