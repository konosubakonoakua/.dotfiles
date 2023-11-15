#!/bin/bash

#INFO: tested, works

PKG_FOLDER=~/Downloads/llvm
INSTALL_PREFIX=$HOME/.local/opt/llvm/

version_latest=$(
	curl -L https://github.com/llvm/llvm-project/releases/ |
		grep -oE 'llvmorg-[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/llvmorg-//' | awk 'NR==1{print $1}'
)
echo "Found llvm latest veriosn: $version_latest"
llvm_pkg_file=clang+llvm-${version_latest}-x86_64-linux-gnu-ubuntu-22.04.tar.xz
llvm_pkg_folder=clang+llvm-${version_latest}-x86_64-linux-gnu-ubuntu-22.04

[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $llvm_pkg_file ]]; then
	wget https://github.com/llvm/llvm-project/releases/download/llvmorg-$version_latest/$llvm_pkg_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$llvm_pkg_file already exits."
	echo "Use cached version."
fi

[[ ! -d $llvm_pkg_folder ]] && mkdir -p $INSTALL_PREFIX/$llvm_pkg_folder && tar -xJvf $llvm_pkg_file -C $INSTALL_PREFIX || exit 1
echo "llvm extracted."
ln -sf $INSTALL_PREFIX/$llvm_pkg_folder $INSTALL_PREFIX/current
echo "$INSTALL_PREFIX/current <---soft link---> $INSTALL_PREFIX/$llvm_pkg_folder"

PKG_INSTALL_PATH_CURRENT=$INSTALL_PREFIX/current

(
	source ~/.bashrc
	if [[ ":$PATH:" != *":$PKG_INSTALL_PATH_CURRENT/bin"* ]]; then
		echo 'export PATH="$PATH:'"$PKG_INSTALL_PATH_CURRENT/bin"'"' >>~/.bashrc
		echo "$PKG_INSTALL_PATH_CURRENT/bin added to "'$PATH'
	else
		echo "$PKG_INSTALL_PATH_CURRENT/bin already added to "'$PATH'
	fi
	exit 0
)

source ~/.bashrc
