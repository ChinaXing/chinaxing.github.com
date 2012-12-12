#!/bin/bash

echo "----Job Start"

git add .

git commit -m "${1:-'add a new article'}"

git push 

commitID=$(echo ${1:-"no commit message"} | git commit-tree dev^{tree}:_site)

git update-ref refs/heads/master $commitID

git checkout master

git push -f origin master

rm -rf _site

git checkout dev

echo "----Job Done"
