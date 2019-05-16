#!/bin/sh

cd /root/blog
git fetch origin
git checkout feature-hugo
git reset --hard origin/feature-hugo
git clean -fdx
git submodule init
git submodule update
git submodule foreach git pull --rebase origin master
supervisorctl restart hugo
echo "ok!"
