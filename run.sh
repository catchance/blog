#!/bin/sh

cd /root/blog
git fetch origin
git checkout feature-hugo
git reset --hard origin/feature-hugo
git clean -fdx
supervisorctl restart hugo
echo "ok!"
