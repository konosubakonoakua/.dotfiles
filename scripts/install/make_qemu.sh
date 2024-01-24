#!/bin/bash

#INFO: tested, works good
deps=(libgtk-3-dev libperl-dev flex)
dpkg -s ${deps[*]} >/dev/null
[[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

PKG_FOLDER=~/Downloads/qemu
INSTALL_PREFIX=$HOME/.local/

version_latest=$(
	curl -L https://www.qemu.org/download/#source |
		grep -oE '[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | awk 'NR==1{print $1}'
)
echo "Found btop latest veriosn: $version_latest"
qemu_pkg_file=qemu-$version_latest.tar.xz
qemu_pkg_folder=qemu-$version_latest

mkdir -p $PKG_FOLDER && cd $PKG_FOLDER

if [[ ! -f $qemu_pkg_file ]]; then
	wget https://download.qemu.org/$qemu_pkg_file
	[[ ! $? -eq 0 ]] && echo "$qemu_pkg_file download failed" && exit 1
else
	echo "$qemu_pkg_file already exits."
	echo "Use cached version."
fi

[[ ! -e $qemu_pkg_folder ]] && tar -Jxvf $qemu_pkg_file
cd ./$qemu_pkg_folder && ./configure --prefix=~/.local/ && make -j install
if [[ $? -eq 0 ]]; then
	echo "QEMU installed"
else
	echo "QEMU install failed"
fi
