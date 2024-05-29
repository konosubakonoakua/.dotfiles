#!/bin/bash

if [[ "$(cat $HOME/.bashrc)" =~ ".local/bin" ]]; then
    echo '.bashrc already configured!'
else
    echo 'export PATH=$PATH:$HOME/.local/bin' >> "$HOME/.bashrc"
    echo '.bashrc updated!'
fi
