#!/bin/bash

#INFO: tested, works good

PROXY_URL=http://127.0.0.1:3128
PKG_FOLDER=~/Downloads/nodejs
INSTALL_PREFIX=$HOME/.local/lib/nodejs

version_latest=$(
	curl -L https://nodejs.org/dist/latest/ |
		grep -oE 'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/v//' | awk 'NR==1{print $1}'
)
echo "Found nodejs latest veriosn: $version_latest"
nodejs_pkg_file=node-v$version_latest-linux-x64.tar.xz
nodejs_pkg_folder=node-v$version_latest-linux-x64

mkdir -p $PKG_FOLDER && cd $PKG_FOLDER

if [[ ! -f $nodejs_pkg_file ]]; then
	wget https://nodejs.org/dist/latest/$nodejs_pkg_file
	[[ ! $? -eq 0 ]] && echo "$nodejs_pkg_file download failed..." && exit 1
else
	echo "$nodejs_pkg_file already exits."
	echo "Use cached version."
fi

if [[ ! -e $INSTALL_PREFIX ]]; then
	mkdir $INSTALL_PREFIX && tar -Jxvf $nodejs_pkg_file -C $INSTALL_PREFIX
	echo "export PATH=$INSTALL_PREFIX/nodejs_pkg_folder/bin:\$PATH" >>~/.bashrc
	source ~/.bashrc
else
	echo "export PATH=$INSTALL_PREFIX/$nodejs_pkg_folder/bin:\$PATH" >>~/.bashrc
	echo "nodejs already installed"
fi

if [[ $? -eq 0 ]]; then
	echo "nodejs installed to $INSTALL_PREFIX/$nodejs_pkg_folder"
	echo "SET NPM PROXY: $PROXY_URL"
	npm config set registry http://registry.npmjs.org/
	npm config set proxy $PROXY_URL
	npm config set https-proxy $PROXY_URL
	npm config set strict-ssl false
else
	echo "nodejs install failed"
fi
