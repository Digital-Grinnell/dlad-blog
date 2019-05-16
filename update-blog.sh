#!/bin/bash
cd ~/Projects/blogs-McFateM
docker image build -t blog-update .
docker login
docker tag blog-update mcfatem/blogs-mcfatem:latest
docker push mcfatem/blogs-mcfatem:latest
