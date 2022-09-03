#!/bin/bash

SCRIPTDIR=$(cd $(dirname $0); pwd)

set -eu

cd $SCRIPTDIR/../github-actions

stepNum=1
stepName=staging
branchName="step-$stepNum"
startCommit=$(git log --reverse -n $stepNum --pretty=format:%H)

if git rev-parse --verify $branchName &>/dev/null; then 
    git reset --hard HEAD
    git checkout main
    git branch -D $branchName; 
fi

git checkout -b $branchName $startCommit

mkdir -p .github/workflows 

cat <<EOT > .github/workflows/main.yml
name: CD Pipeline
on: [pull_request]
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