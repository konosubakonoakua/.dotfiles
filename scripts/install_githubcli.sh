#INFO: tested, works

#!/bin/bash

GIT_SRC=~/Downloads/githubcli
INSTALL_PREFIX=$HOME/.local/

# https://github.com/cli/cli/releases/download/v2.32.1/gh_2.32.1_linux_amd64.tar.gz
version_latest=$(
	curl -L https://github.com/cli/cli/releases/ |
		grep -oE '>v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>v//' | awk 'NR==1{print $1}'
)
echo "Found githubcli latest veriosn: $version_latest"
githubcli_pkg_file=gh_${version_latest}_linux_amd64.tar.gz
githubcli_pkg_folder=gh_${version_latest}_linux_amd64

[[ ! -d $GIT_SRC ]] && mkdir $GIT_SRC
cd $GIT_SRC

if [[ ! -f $githubcli_pkg_file ]]; then
	wget https://github.com/cli/cli/releases/download/v$version_latest/$githubcli_pkg_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$githubcli_pkg_file already exits."
	echo "Use cached version."
fi

tar -zxvf $githubcli_pkg_file
cp -rf ./$githubcli_pkg_folder/* $INSTALL_PREFIX
gh --verion
gh auth login
echo "githubcli installed."
