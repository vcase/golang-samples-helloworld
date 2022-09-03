#!/bin/bash

SCRIPTDIR=$(cd $(dirname $0); pwd)

set -eu

cd $SCRIPTDIR/../github-actions

stepNum=1
branchName="step-$stepNum"
startCommit=$(git log --reverse -n $stepNum --pretty=format:%H)

if git rev-parse --verify $branchName &>/dev/null; then 
    git reset --hard HEAD
    git checkout main
    git branch -D $branchName; 
fi

git checkout -b $branchName $startCommit

mkdir -p .github/workflows 

cat <<EOT > .github/workflows/development.yml
name: CD Pipeline
on: [pull_request]
jobs:
  development:
    environment: development
    runs-on: linux-latest
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3
      - name: Go Tooling Preparation
        uses: actions/setup-go@v3
        with:
          go-version: '1.17'
          cache: true
      - name: lint
        run: go vet ./...
      - name: build
        run: go build ./...
      - name: unit-test
        run: go test ./...
      - name: run
        run: go run .
EOT

git add .
git commit -m "step-1 development workflow"
git push -uf origin $branchName