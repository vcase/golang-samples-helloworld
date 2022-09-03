#!/bin/bash

SCRIPTDIR=$(cd $(dirname $0); pwd)

set -eu

cd $SCRIPTDIR/../github-actions

stepNum=3
stepName=production
branchName="step-$stepNum"
startCommit=$(git log --pretty=format:%H | tail -n $stepNum | head -n 1)

echo "startCommit $startCommit"

git clean -fd
git reset --hard HEAD
git checkout main
git pull
if git rev-parse --verify $branchName &>/dev/null; then 
    git branch -D $branchName; 
fi

echo "git checkout -b $branchName $startCommit"
git checkout -b $branchName $startCommit

mkdir -p .github/workflows 

echo "
  $stepName:
    environment: $stepName
    runs-on: ubuntu-latest
    needs: staging
    steps:
      - run: echo \"Lint\"
      - run: echo \"Build\"
      - run: echo \"Test\"
      - run: echo \"Publish\"
      - run: echo \"Deploy\"    
" >> .github/workflows/main.yml

git add .
git commit -m "$branchName $stepName workflow"
git push -uf origin $branchName