#!/bin/bash

source gh_api.sh
source check_path.sh

url=$(get_github_release_urls zellij-org/zellij | grep zellij-x86_64-unknown-linux-musl.tar.gz)
echo $url

cd ~/Downloads/ && mkdir -p zellij
cd zellij && rm -rf *.tar.gz
wget $url --no-check-certificate \
  && tar -vxf *.tar.gz\
  || echo "failed to download" && exit 1
cp -f **/zellij ~/.local/bin/zellij

