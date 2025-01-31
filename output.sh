#!/usr/bin/bash
## Check if the current directory is writable.
GITPATH=$(dirname "$(realpath "$0")")
if [ ! -w "$GITPATH" ]; then
    echo "Can't write to $GITPATH"
    exit 1
else
    echo $GITPATH
fi
