#!/bin/bash
SCRIPTDIR=$(cd $(dirname $0); pwd)

if [ -e ../github-actions ]; then rm -rf ../github-actions; fi
git clone . ../github-actions

cd ../github-actions

if [ -e .git ]; then rm -rf .git; fi
if [ -e .github ]; then rm -rf .github; fi

git init .
git branch -m main
git add .
git commit -m "initial commit"

git remote add origin git@github.com:vcase/github-actions.git

git push -uf origin main


