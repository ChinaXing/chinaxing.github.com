
#!/bin/bash

echo "----Job Start"

git add .

git commit -m "${1:-'add a new article'}"

git push 

commitID=$(echo ${1:-"no commit message"} | git commit-tree dev^{tree}:www)

git update-ref refs/heads/master $commitID

git checkout master

git clean -d -f

git push -f 

rm -rf www

git checkout dev

echo "----Job Done"
