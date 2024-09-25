#!/bin/bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/gh_api.sh"
source "$(cd -P "$(dirname "$0")" && pwd -P)/check_path.sh"

url=$(get_github_release_urls zellij-org/zellij | grep zellij-x86_64-unknown-linux-musl.tar.gz)
echo $url

cd ~/Downloads/ && mkdir -p zellij
cd zellij && rm -rf *.tar.gz
wget $url --no-check-certificate \
  && tar -vxf *.tar.gz && cp -f ./zellij ~/.local/bin/zellij \
  || echo "failed to download" && exit 1


