#!/bin/bash

for d in */ ; do
    [ -L "${d%/}" ] && continue
    #echo "$d"
    cd "$d"
    echo "Shell is currently working in '$(pwd)'."
    docker compose up -d
    cd ../
done