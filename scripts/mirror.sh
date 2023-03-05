#!/bin/bash

set -eufo pipefail

if [ "$#" -ne 1 ]; then
    echo "usage: $0 target_path" >&2
    exit 1
fi

TARGET="$1"

echo "Mirroring ${TARGET}"

# Matches:
# git@github.com:user/project.git
# git@192.168.101.127:user/project.git
# git://host.xz/path/to/repo.git/
# git://host.xz/~user/path/to/repo.git/
# https://github.com/user/project.git
# https://192.168.101.127/user/project.git
# https://host.xz/path/to/repo.git/
# https://gitlab.freedesktop.org/pipewire/pipewire.git
# http://192.168.101.127/user/project.git
# http://host.xz/path/to/repo.git/
# http://github.com/user/project.git
# ssh://user@host.xz:port/path/to/repo.git/
# ssh://user@host.xz/path/to/repo.git/
# ssh://host.xz:port/path/to/repo.git/
# ssh://host.xz/path/to/repo.git/
# ssh://user@host.xz/path/to/repo.git/
# ssh://host.xz/path/to/repo.git/
# ssh://user@host.xz/~user/path/to/repo.git/
# ssh://host.xz/~user/path/to/repo.git/
# ssh://user@host.xz/~/path/to/repo.git
# ssh://host.xz/~/path/to/repo.git
re="^(git|ssh|http(s)?)|(git@[\w\.]+))(:(\/\/)?)([\w\.@\:/\-~]+)(\.git)(\/)"

if ! [[ $1 =~ $re ]]; then
	echo "Provided URL does not match" $1
	exit 1
fi

proto="`echo $1 | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
url=`echo $1 | sed -e s,$proto,,g`

if [ -d mirrors/$url ]; then
	echo "Mirror already exists"
	exit 1
fi

source_url=$url
target_path=/var/www/git/mirrors/$url

echo "Cloning from ${source_url} into ${target_path}"
git init --bare "${target_path}"
cd "${target_path}"

git config remote.origin.url $TARGET
git config --add remote.origin.fetch '+refs/heads/*:refs/heads/*'
git config --add remote.origin.fetch '+refs/tags/*:refs/tags/*'
git config --add remote.origin.fetch '+refs/notes/*:refs/notes/*'
git config remote.origin.mirror true
git fetch --all

echo ""
echo "Done."
