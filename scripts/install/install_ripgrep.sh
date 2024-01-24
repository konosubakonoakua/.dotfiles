#INFO: tested, works

#!/bin/bash

PKG_FOLDER=~/Downloads/ripgrep
INSTALL_PREFIX=$HOME/.local/
arch="x86_64"
os="unknown-linux-musl"
filetype="tar.gz"

# https://github.com/BurntSushi/ripgrep/releases/latest
# https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz
version_latest=$(
	curl -L https://github.com/BurntSushi/ripgrep/releases/ |
		grep -oE 'ripgrep-[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/ripgrep-//' | awk 'NR==1{print $1}'
)
echo "Found ripgrep latest veriosn: $version_latest"
ripgrep_pkg_file=ripgrep-${version_latest}-${arch}-${os}.${filetype}
ripgrep_pkg_folder=ripgrep-${version_latest}-${arch}-${os}

[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $ripgrep_pkg_file ]]; then
  wget https://github.com/BurntSushi/ripgrep/releases/download/${version_latest}/${ripgrep_pkg_file}
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$ripgrep_pkg_file already exits."
	echo "Use cached version."
fi

tar -zxvf $ripgrep_pkg_file
cp -f ./$ripgrep_pkg_folder/rg $INSTALL_PREFIX/bin/rg

mkdir -p "$INSTALL_PREFIX/share/man/man1/"
cp -f ./$ripgrep_pkg_folder/doc/rg.1 $INSTALL_PREFIX/share/man/man1/rg.1

cmp_dir="$HOME/.config/bash_completion"
mkdir -p "$cmp_dir"
rg --generate complete-bash > "$cmp_dir/rg.bash"

source ~/.bashrc
rg --version
echo "ripgrep installed."
