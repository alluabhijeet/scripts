#!/bin/bash

# Check if current branch is 'main'
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" != "main" ]; then
    echo "Error: Terraform can only be run from the 'main' branch."
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Error: Uncommitted changes detected. Please commit or stash them before running Terraform."
    exit 1
fi

# Fetch remote updates and check if the local main is up to date with the remote
git fetch origin main
local_commit=$(git rev-parse HEAD)
remote_commit=$(git rev-parse origin/main)

if [ "$local_commit" != "$remote_commit" ]; then
    echo "Error: Local main branch is not up-to-date with remote main. Please pull the latest changes."
    exit 1
fi
