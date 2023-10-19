#!/bin/bash
#
#INFO: tested, works

PKG_FOLDER=~/Downloads/nnn
INSTALL_PREFIX=$HOME/.local/
VARIANT=""

case "$1" in
emoji)
	echo "Installing nnn-emoji-static"
	VARIANT=-emoji
	;;
icons)
	echo "Installing nnn-icons-static"
	VARIANT=-icons
	;;
musl)
	echo "Installing nnn-musl-static"
	VARIANT=-musl
	;;
nerd)
	echo "Installing nnn-nerd-static"
	VARIANT=-nerd
	;;
*)
	echo "Available options: emoji|icons|musl|nerd"
	echo "Your input is invalid, default installing nnn-static (default)"
	VARIANT=""
	;;
esac

version_latest=$(
	curl -L https://github.com/jarun/nnn/releases |
		grep -oE 'nnn v[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/nnn v//' | awk 'NR==1{print $1}'
)
echo "Found nnn$VARIANT-static latest veriosn: $version_latest"
nnn_exec=nnn$VARIANT-static
nnn_pkg_file=nnn$VARIANT-static-${version_latest}.x86_64.tar.gz
nnn_pkg_folder=nnn$VARIANT-static-${version_latest}.x86_64

[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $nnn_pkg_file ]]; then
	wget https://github.com/jarun/nnn/releases/download/v$version_latest/$nnn_pkg_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$nnn_pkg_file already exits."
	echo "Use cached version."
fi

tar -zxvf $nnn_pkg_file
chmod +x ./$nnn_exec && cp -f ./$nnn_exec $INSTALL_PREFIX/bin/nnn
echo "$nnn_exec installed."
