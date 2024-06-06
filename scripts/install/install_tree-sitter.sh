#!/bin/bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/gh_api.sh"
url=$(get_github_release_urls tree-sitter/tree-sitter | grep tree-sitter-linux-x64.gz)
echo $url

cd ~/Downloads/ && mkdir -p tree-sitter
cd tree-sitter
rm -f ./* ~/.local/bin/tree-sitter
wget $url && gzip -d *.gz
chmod +x ./tree-sitter-linux-x64
cp -f ./tree-sitter-linux-x64 ~/.local/bin/tree-sitter

if [[ "$(cat $HOME/.bashrc)" =~ ".local/bin" ]]; then
    echo '.bashrc already configured!'
else
    echo 'export PATH=$PATH:$HOME/.local/bin' >> "$HOME/.bashrc"
    echo '.bashrc updated!'
fi
