#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "usage: $0 script_path" >&2
    exit 1
fi

SCRIPT=$1
if [ ! -f "$SCRIPT" ]; then
	echo "$0 must be run from archive root" >&2
	exit 1
fi

find mirrors/ -type d -name *.git -exec /bin/bash -lc "$SCRIPT {}" \;
