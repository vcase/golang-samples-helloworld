#!/bin/bash

SCRIPTDIR=$(cd $(dirname $0); pwd)

set -eu

cd $SCRIPTDIR/../github-actions

stepNum=2
stepName=staging
branchName="step-$stepNum"
startCommit=$(git log --reverse -n $stepNum --pretty=format:%H)

echo "startCommit $startCommit"

git reset --hard HEAD
git checkout main
if git rev-parse --verify $branchName &>/dev/null; then 
    git branch -D $branchName; 
fi

echo "git checkout -b $branchName $startCommit"
git checkout -b $branchName $startCommit

mkdir -p .github/workflows 

cat <<EOT > .github/workflows/main.yml
name: main branch jobs
on: 
  push:
    branches:
      - main
jobs:
  $stepName:
    environment: $stepName
    runs-on: ubuntu-latest
    steps:
      - run: echo "Lint"
      - run: echo "Build"
      - run: echo "Test"
      - run: echo "Publish"
      - run: echo "Deploy"    
EOT

git add .
git commit -m "$branchName $stepName workflow"
git push -uf origin $branchName