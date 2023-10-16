#!/bin/bash

#INFO: tested, works good

PKG_FOLDER=~/Downloads/ninja
INSTALL_PREFIX=$HOME/.local/

version_latest=$(
	curl -L https://github.com/ninja-build/ninja/releases |
		grep -oE 'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/v//' | awk 'NR==1{print $1}'
)
echo "Found ninja latest veriosn: $version_latest"
ninja_pkg_file=ninja-linux.zip
ninja_pkg_folder=ninja-linux

mkdir -p $PKG_FOLDER && cd $PKG_FOLDER

if [[ ! -f $ninja_pkg_file ]]; then
	wget https://github.com/ninja-build/ninja/releases/download/v$version_latest/$ninja_pkg_file
	[[ ! $? -eq 0 ]] && echo "Download $ninja_pkg_file failed..." && exit 1
else
	echo "$ninja_pkg_file already exits."
	echo "Use cached version."
fi

unzip $ninja_pkg_file
chmod +x ./ninja && cp ./ninja $INSTALL_PREFIX/bin
if [[ $? -eq 0 ]]; then
	echo "ninja installed"
else
	echo "ninja install failed"
fi
