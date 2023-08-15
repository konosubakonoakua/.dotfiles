#INFO: tested, works good

#!/bin/bash

PKG_FOLDER=~/Downloads/btop
INSTALL_PREFIX=$HOME/.local/

version_latest=$(
	curl -L https://github.com/aristocratos/btop/releases/latest |
		grep -oE 'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/v//' | awk 'NR==1{print $1}'
)
echo "Found btop latest veriosn: $version_latest"
btop_pkg_file=btop-x86_64-linux-musl.tbz
btop_pkg_folder=btop-x86_64-linux-musl

mkdir -p $PKG_FOLDER && cd $PKG_FOLDER

if [[ ! -f $btop_pkg_file ]]; then
	wget https://github.com/aristocratos/btop/releases/download/v$version_latest/$btop_pkg_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$btop_pkg_file already exits."
	echo "Use cached version."
fi

tar -jxvf $btop_pkg_file
cd ./btop && make install PREFIX=$INSTALL_PREFIX
if [[ $? -eq 0 ]]; then
	echo "Btop++ installed"
else
	echo "Btop++ install failed"
fi
