#!/bin/bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/gh_api.sh"
url=$(get_github_release_urls pwndbg/pwndbg | grep amd64-portable)

cd ~/Downloads/ && mkdir -p pwndbg
cd pwndbg
wget $url && tar -vxf *.tar.gz
rm -rf ~/.local/opt/pwndbg
cp -rf pwndbg ~/.local/opt/pwndbg

if [[ "$(cat $HOME/.bashrc)" =~ "/opt/pwndbg/bin" ]]; then
    echo '.bashrc already configured!'
else
    echo 'export PATH=$PATH:$HOME/.local/opt/pwndbg/bin' >> "$HOME/.bashrc"
    echo '.bashrc updated!'
fi
