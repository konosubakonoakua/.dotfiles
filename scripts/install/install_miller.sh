#!/bin/bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/gh_api.sh"
url=$(get_github_release_urls johnkerl/miller | grep linux-amd64.tar.gz)

cd ~/Downloads/ && mkdir -p miller
cd miller
wget $url && tar -vxf *.tar.gz
cp -f **/mlr ~/.local/bin/mlr

if [[ "$(cat $HOME/.bashrc)" =~ ".local/bin" ]]; then
    echo '.bashrc already configured!'
else
    echo 'export PATH=$PATH:$HOME/.local/bin' >> "$HOME/.bashrc"
    echo '.bashrc updated!'
fi
