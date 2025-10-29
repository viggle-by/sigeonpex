#!/bin/bash

set -xe

# A script to concat all the files in $1 into thier respective files in /

cd "$1"

files=$(find . -type f)

for file in $files; do
    mkdir --parents "/$(dirname $file)"

    if [ -f "/$file" ]; then
        cat $file >> "/$file"
    else
        cp --preserve=mode $file "/$file"
    fi
done