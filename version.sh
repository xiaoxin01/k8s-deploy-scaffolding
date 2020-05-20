#!/bin/bash
set -e

versionFile="$1"
# if versionFile not given, set default file name
if [ -z "$versionFile" ]; then
    versionFile=".VERSION"
fi

# if file not exists, set default version
if [ ! -f "$versionFile" ]; then
    echo "0.0.0" > "$versionFile"
fi

echo "bump version"
# using treeder/bump to bump version
docker run --rm -v "$PWD":/app treeder/bump --filename "$versionFile"
