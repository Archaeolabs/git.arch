#!/bin/bash

set -eufo pipefail

if [ "$#" -ne 1 ]; then
    echo "usage: $0 target_path" >&2
    exit 1
fi

TARGET="$1"

echo "Pulling ${TARGET}"

cd $TARGET
if ! `git config --get --bool remote.origin.mirror`; then
	echo "Not a mirror or working tree" >&2
	exit 1	
fi

git fetch --all

echo "Done"

