#!/usr/bin/env zsh
# Change the shebang line to whatever you need it to be. MacOS uses zsh by default
# but if on a Linux system, you can use bash or sh

set -ex

python -m pytest

pylint app/main.py \
    tests/test_main.py \
    src/helm_test.py

autopep8 --in-place \
    --aggressive \
    --aggressive \
    --recursive \
    app tests src
