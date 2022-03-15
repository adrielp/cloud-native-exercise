#!/usr/bin/env zsh
# Change the shebang line to whatever you need it to be. MacOS uses zsh by default
# but if on a Linux system, you can use bash or sh

set -ex

docker build --tag fastapi-micro:1.0.0 .

docker run --rm -it \
    --name fastapi \
    -p 8080:8080 \
    fastapi-micro:1.0.0
