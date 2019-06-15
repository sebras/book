#!/bin/bash

function spellcheck() {
        aspell -l sv -p ./dict -x -c "$1"
}

pushd "$(dirname "$0")"

spellcheck src/ch00-00-introduction.md

head -1 dict > .dict
sed -e 1d dict | sort >> .dict
mv .dict dict

popd
