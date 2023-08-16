#!/bin/bash

#INFO: tested, works

PKG_FOLDER=~/Downloads/fennel
INSTALL_PREFIX=$HOME/.local
SEMVER_GREP_REGEX="[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}"
fennel_ver_latest=$(curl -L https://fennel-lang.org/ | grep -oE "v$SEMVER_GREP_REGEX" | awk 'NR==1{print $1}' | sort -r --version-sort | uniq | sed 's/v//')
fennel_pkg_file=fennel-$fennel_ver_latest-x86_64
fennel_install_path=$INSTALL_PREFIX/bin/fennel
dowload_link=https://fennel-lang.org/downloads/$fennel_pkg_file

echo "Found fennel latest veriosn: $fennel_ver_latest"
echo "Download link: $dowload_link"

[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $fennel_pkg_file ]]; then
	wget $dowload_link || exit 1
else
	echo "$fennel_pkg_file already exits."
	echo "Use cached version."
fi

chmod +x $fennel_pkg_file
rm -rf $fennel_install_path
mv $fennel_pkg_file $fennel_install_path

echo "fennel installed into $fennel_install_path"
echo "fennel tutorial: https://fennel-lang.org/tutorial"
