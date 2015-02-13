#!/bin/sh
jekyll b
cd _site
git add . 
git commit -m 'new deploy'
git push origin master
echo 'done'
