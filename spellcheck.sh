#!/bin/bash

function spellcheck() {
        aspell -l sv -p ./dict -x -c "$1"
}

pushd "$(dirname "$0")"

spellcheck src/ch00-00-introduction.md
spellcheck src/ch01-00-getting-started.md
spellcheck src/ch01-01-installation.md
spellcheck src/ch01-02-hello-world.md
spellcheck src/ch01-03-hello-cargo.md
spellcheck src/ch02-00-guessing-game-tutorial.md
spellcheck src/ch03-00-common-programming-concepts.md
spellcheck src/ch03-01-variables-and-mutability.md

head -1 dict > .dict
sed -e 1d dict | sort >> .dict
mv .dict dict

popd
