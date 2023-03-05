#!/bin/bash

set -eufo

if [ "$#" -ne 1 ]; then
    echo "usage: $0 user" >&2
    exit 1
fi

USER="$1"

echo "Archiving all starred repos from Github user ${USER}"

out=$(curl -XGET https://api.github.com/users/${USER}/starred)
echo $out | jq '.[].clone_url' | sed 's/\"//g' | xargs -I{} -d'\n' ./scripts/mirror.sh {}

