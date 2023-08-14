#INFO: tested, works

#!/bin/bash

GIT_SRC=~/Downloads/lazygit
INSTALL_PREFIX=$HOME/.local/

version_latest=$(
	curl -L https://github.com/jesseduffield/lazygit/releases/ |
		grep -oE '>v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>v//' | awk 'NR==1{print $1}'
)
echo "Found lazygit latest veriosn: $version_latest"
lazygit_pkg_file=lazygit_${version_latest}_Linux_x86_64.tar.gz
lazygit_pkg_folder=lazygit_${version_latest}_Linux_x86_64

[[ ! -d $GIT_SRC ]] && mkdir $GIT_SRC
cd $GIT_SRC

if [[ ! -f $lazygit_pkg_file ]]; then
	wget https://github.com/jesseduffield/lazygit/releases/download/v$version_latest/$lazygit_pkg_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$lazygit_pkg_file already exits."
	echo "Use cached version."
fi

tar -zxvf $lazygit_pkg_file
chmod +x ./lazygit && cp -f ./lazygit $INSTALL_PREFIX/bin/
echo "Lazygit installed."
