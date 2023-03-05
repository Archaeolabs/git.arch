#!/bin/bash

set -eufo pipefail

if [ "$#" -ne 1 ]; then
    echo "usage: $0 target_path" >&2
    exit 1
fi

TARGET="$1"

echo "Archiving ${TARGET}"

cd $TARGET
if ! `git config --get --bool remote.origin.mirror`; then
	echo "Not a mirror or working tree" >&2
	exit 1	
fi

commit_hash="$(git rev-parse --short HEAD)"
remote_url="$(git config --get remote.origin.url)"
protocol="$(echo $remote_url | grep '://' | sed -e 's,^\(.*://\).*,\1,g')"
url="$(echo $remote_url | sed -e s,$protocol,,g | sed -e 's/\.[^.]*$//')"
path=/var/www/git/archives/${url}-${commit_hash}

mkdir -p ${path}
git archive -o $path/${commit_hash}.zip HEAD
git archive -o $path/${commit_hash}.tar HEAD
git archive -o $path/${commit_hash}.tar.gz HEAD
git archive -o $path/${commit_hash}.tar.bz2 HEAD

echo "Done"
