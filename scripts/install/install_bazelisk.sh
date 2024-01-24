#!/bin/bash

#INFO: tested, works good

PKG_FOLDER=~/Downloads/bazelisk
INSTALL_PREFIX=$HOME/.local/bin/bazelisk

version_latest=$(
	curl -L https://github.com/bazelbuild/bazelisk/releases |
		grep -oE 'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/v//' | awk 'NR==1{print $1}'
)
echo "Found bazelisk latest veriosn: $version_latest"
bazelisk_pkg_file=bazelisk-linux-amd64
bazelisk_pkg_folder=bazelisk-linux-amd64

mkdir -p $PKG_FOLDER && cd $PKG_FOLDER

if [[ ! -f $bazelisk_pkg_file ]]; then
	wget https://github.com/bazelbuild/bazelisk/releases/download/v$version_latest/$bazelisk_pkg_file
	[[ ! $? -eq 0 ]] && echo "Bazelisk install failed" && exit 1
else
	echo "$bazelisk_pkg_file already exits."
	echo "Use cached version."
fi

cp $bazelisk_pkg_file $INSTALL_PREFIX && chmod +x $INSTALL_PREFIX
if [[ $? -eq 0 ]]; then
	echo "Bazelisk installed"
else
	echo "Bazelisk install failed"
fi
