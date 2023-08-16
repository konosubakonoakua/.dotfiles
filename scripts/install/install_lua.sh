#!/bin/bash

#INFO: tested, works

PKG_FOLDER=~/Downloads/lua
INSTALL_PREFIX=$HOME/.local
SEMVER_GREP_REGEX="[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}"
lua_ver_latest=$(curl -L https://www.lua.org/download.html | grep -oE "lua-$SEMVER_GREP_REGEX" | awk 'NR==1{print $1}' | sort -r --version-sort | uniq | sed 's/lua-//')
lua_pkg_prefix=lua-
lua_pkg_suffix=.tar.gz
lua_pkg_file=$lua_pkg_prefix$lua_ver_latest$lua_pkg_suffix
lua_pkg_file_name=$lua_pkg_prefix$lua_ver_latest
lua_install_path=$INSTALL_PREFIX/
dowload_link=http://www.lua.org/ftp/$lua_pkg_file

echo "Found lua latest veriosn: $lua_ver_latest"
echo "Download link: $dowload_link"

[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $lua_pkg_file ]]; then
	wget $dowload_link || exit 1
else
	echo "$lua_pkg_file already exits."
	echo "Use cached version."
fi

tar -zvxf $lua_pkg_file
cd $lua_pkg_file_name
make INSTALL_TOP=$INSTALL_PREFIX all test && make INSTALL_TOP=$INSTALL_PREFIX install

echo "lua installed into $lua_install_path"
