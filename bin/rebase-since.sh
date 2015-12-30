#!/bin/bash

set -e

since=${1:-master}
current=$(git rev-parse --abbrev-ref HEAD)
since_ref=$(git merge-base "$since" "$current")

echo "Performing rebase of branch ${current} since $since @ merge-base $since_ref"
sleep 2
git rebase -i "$since_ref" "$current"
