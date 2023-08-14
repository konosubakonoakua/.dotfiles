#INFO: tested, works

#!/bin/bash

GIT_SRC=~/Downloads/glow
INSTALL_PREFIX=$HOME/.local/

# https://github.com/charmbracelet/glow/releases/download/v1.5.1/glow_Linux_arm64.tar.gz
version_latest=$(
	curl -L https://github.com/charmbracelet/glow/releases |
		grep -oE '>v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>v//' | awk 'NR==1{print $1}'
)
echo "Found glow latest veriosn: $version_latest"
glow_pkg_file=glow_Linux_arm64_${version_latest}.tar.gz
glow_pkg_folder=glow_${version_latest}_Linux_x86_64

[[ ! -d $GIT_SRC ]] && mkdir $GIT_SRC
cd $GIT_SRC

if [[ ! -f $glow_pkg_file ]]; then
	wget https://github.com/charmbracelet/glow/releases/download/v$version_latest/glow_Linux_x86_64.tar.gz -O $glow_pkg_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$glow_pkg_file already exits."
	echo "Use cached version."
fi

mkdir -p $glow_pkg_folder
tar -zxvf $glow_pkg_file -C $glow_pkg_folder
cd $glow_pkg_folder
chmod +x ./glow && cp -f ./glow $INSTALL_PREFIX/bin/
tar -zxvf ./manpages/glow.1.gz -C $INSTALL_PREFIX/share/man/man1
echo "glow installed."
