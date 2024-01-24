#!/usr/bin/env bash

PKG_FOLDER=~/Downloads/zoxide
INSTALL_PREFIX=$HOME/.local/
name="zoxide"
arch="x86_64"
os="unknown-linux-musl"
filetype="tar.gz"

# https://github.com/ajeetdsouza/zoxide/releases/latest
# https://github.com/ajeetdsouza/zoxide/releases/download/14.1.0/zoxide-14.1.0-x86_64-unknown-linux-musl.tar.gz
version_latest=$(
  curl -L https://github.com/ajeetdsouza/zoxide/releases |
		grep -oE '>[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>//' | awk 'NR==1{print $1}'
)
echo "Found $name latest veriosn: $version_latest"

[ -z $version_latest ] && echo "Nothing found, quiting..." && exit 1

zoxide_pkg_file=$name-${version_latest}-${arch}-${os}.${filetype}
zoxide_pkg_folder=$name-${version_latest}-${arch}-${os}

[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $zoxide_pkg_file ]]; then
  wget https://github.com/ajeetdsouza/zoxide/releases/download/v${version_latest}/${zoxide_pkg_file}
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$zoxide_pkg_file already exits."
	echo "Use cached version."
fi

tar -zxvf $zoxide_pkg_file
cp -f ./$name $INSTALL_PREFIX/bin/$name

mkdir -p "$INSTALL_PREFIX/share/man/man1/"
cp -f ./man/man1/*.1 $INSTALL_PREFIX/share/man/man1/

cmp_dir="$HOME/.config/bash_completion"
mkdir -p "$cmp_dir"
cp -f ./completions/zoxide.bash "$cmp_dir"


source ~/.bashrc
zoxide --version
echo "zoxide installed."
if [[ "$(cat $HOME/.bashrc)" =~ "zoxide init bash" ]]; then
    echo '.bashrc already configured!'
else
    echo 'eval "$(zoxide init bash)"' >> "$HOME/.bashrc"
    echo '.bashrc updated!'
fi
