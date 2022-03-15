#!/usr/bin/env zsh
# Change the shebang line to whatever you need it to be. MacOS uses zsh by default
# but if on a Linux system, you can use bash or sh

# Run Python venv, activate the environment, then run a pip install
# of the developer requirements.txt

python3 -m venv venv \
    && source venv/bin/activate \
    && pip install --upgrade pip \
    && pip install -r src/requirements.txt \
    && deactivate
