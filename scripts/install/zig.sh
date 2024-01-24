#!/bin/bash

#INFO: tested, works

PKG_FOLDER=~/Downloads/zig
INSTALL_PREFIX=$HOME/.local
SEMVER_GREP_REGEX="[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}"
zig_pkg_file_suffix=".tar.xz"
zig_pkg_file_prefix=$(
	curl -L https://ziglang.org/download/ | grep -oE "zig-linux-x86_64-$SEMVER_GREP_REGEX\.tar\.xz" |
		awk 'NR==1{print $1}' | sort -r --version-sort | uniq | sed 's/\.tar\.xz//'
)
zig_pkg_file=$zig_pkg_file_prefix$zig_pkg_file_suffix
zig_ver_latest=$(echo $zig_pkg_file | grep -oE "$SEMVER_GREP_REGEX")
zig_install_path=$INSTALL_PREFIX/opt/$zig_pkg_file_prefix
mkdir -p $zig_install_path
dowload_link=https://ziglang.org/download/$zig_ver_latest/$zig_pkg_file

echo "Found zig latest veriosn: $zig_ver_latest"
echo "Download link: $dowload_link"

[[ ! -d $PKG_FOLDER ]] && mkdir -p $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $zig_pkg_file ]]; then
	wget $dowload_link || exit 1
else
	echo "$zig_pkg_file already exits."
	echo "Use cached version."
fi

rm -rf $zig_pkg_file_suffix
tar -Jxvf $zig_pkg_file
rm -rf $zig_install_path
rm -rf $INSTALL_PREFIX/bin/zig
mv $zig_pkg_file_prefix $zig_install_path
chmod +x $zig_install_path/zig
ln -s $(readlink -f $zig_install_path/zig) $(readlink -f $INSTALL_PREFIX/bin/zig)

echo "Zig installed into $zig_install_path"
