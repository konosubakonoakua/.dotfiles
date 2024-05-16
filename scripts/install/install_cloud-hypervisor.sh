#!/bin/bash

url=$(curl -s "https://api.github.com/repos/cloud-hypervisor/cloud-hypervisor/releases/latest" \
  | grep -v "cloud-hypervisor-v39\.0\.tar\.xz" \
  | grep -Po '"browser_download_url": "\K[^"]*'
)
echo $url

cd ~/Downloads/ && mkdir -p cloud-hypervisor
cd cloud-hypervisor
wget $url
chmod +x ./*
cp -f ./* ~/.local/bin/

if [[ "$(cat $HOME/.bashrc)" =~ ".local/bin" ]]; then
    echo '.bashrc already configured!'
else
    echo 'export PATH=$PATH:$HOME/.local/bin' >> "$HOME/.bashrc"
    echo '.bashrc updated!'
fi
