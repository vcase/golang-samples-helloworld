#!/bin/bash

SCRIPTDIR=$(cd $(dirname $0); pwd)

set -eu

cd $SCRIPTDIR/../github-actions

stepNum=1
stepName=development
branchName="step-$stepNum"
startCommit=$(git log --reverse -n $stepNum --pretty=format:%H)

if git rev-parse --verify $branchName &>/dev/null; then 
    git reset --hard HEAD
    git checkout main
    git branch -D $branchName; 
fi

git checkout -b $branchName $startCommit

mkdir -p .github/workflows 

cat <<EOT > .github/workflows/$stepName.yml
name: pr branch jobs
on: [pull_request]
jobs:
  $stepName:
    environment: $stepName
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3
      - name: Go Tooling Preparation
        uses: actions/setup-go@v3
        with:
          go-version: '1.17'
          cache: true
      - run: go vet ./...
      - run: go build ./...
      - run: go test ./...
      - run: go run .
EOT

git add .
git commit -m "$branchName $stepName workflow"
git push -uf origin $branchName