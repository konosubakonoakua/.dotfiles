#INFO: tested, works good

#!/bin/bash

PKG_FOLDER=~/Downloads/gtags
INSTALL_PREFIX=$HOME/.local/
MAKE_FLAGS=CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX\ 
MAKE_FLAGS+=CMAKE_BUILD_TYPE=RelWithDebInfo

gtags_ver=$(
	curl -L https://ftp.gnu.org/pub/gnu/global/ |
		grep -oE 'global-[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | awk 'NR==1{print $1}'
)
echo "Found gtags latest veriosn: $version_latest"
gtags_pkg=$gtags_ver.tar.gz

deps=(libncurses6-dev emacsen-common libltdl7 libsqlite3-0 doxygen id-utils python3-pygments)
dpkg -s ${deps[*]} >/dev/null
[[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER
if [[ ! -f $gtags_pkg ]]; then
	wget https://ftp.gnu.org/pub/gnu/global/$gtags_pkg
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$gtags_pkg already exits."
	echo "Use cached version."
fi
if [[ ! -d $gtags_ver ]]; then
	tar -zxvf $gtags_pkg
else
	echo "$gtags_ver already exits."
	echo "Use cached version."
fi

cd $gtags_ver
./configure --prefix=$INSTALL_PREFIX
make && make install && echo "Gtags installed."
