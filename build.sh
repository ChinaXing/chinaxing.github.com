
#!/bin/bash

echo "----Job Start"

if [ $# -eq 1 ]
then
    echo "--- build static ---"
    (cd wintersmith && node_modules/wintersmith/bin/wintersmith build)
    echo "--- build Done --"
fi

echo "--- commit dev ---"

git add .

git commit -m "${1:-'add a new article'}"

echo "--- push dev ---"

git push 

echo "--- prepare master commit ---" 

commitID=$(echo ${1:-"no commit message"} | git commit-tree dev^{tree}:www)

git update-ref refs/heads/master $commitID

echo "--- checkout master ---"

git checkout master

git clean -d -f

echo "--- push master ---" 

git push -f 

echo "--- clean www ---"

rm -rf www

echo "--- checkout dev ---"

git checkout dev

echo "----Job Done"
