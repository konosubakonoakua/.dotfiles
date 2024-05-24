OLD_LIBC_RELEASE=https://github.com/neovim/neovim-releases/releases
MINIMAL_LIBC=2.31
source "$(cd -P "$(dirname "$0")" && pwd -P)/../shell/libc_version.sh"

cd ~/Downloads

libc_ver_lt "$MINIMAL_LIBC"
if [ $? -eq 1 ]; then
	echo
	echo "##########################################################################################################################################"
	echo "Current libc is older than minimal version $MINIMAL_LIBC"
	echo "Please download neovim which built with old libc at $OLD_LIBC_RELEASE"
	echo "##########################################################################################################################################"
	echo
	exit 1
fi

INSTALL_PREFIX=~/.local/
if [ "$1" = "nightly" ]; then
	echo "install nightly"
	nvim_pkg_url=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
	nvim_tarfile_name="nvim-linux64"
	nvim_version_file=$nvim_tarfile_name.tar.gz
else
	nvim_pkg_url=https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
	echo "install stable"
	version_latest=$(
		curl -L https://github.com/neovim/neovim/releases/tag/stable |
			grep -oE 'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
			sort -r --version-sort | uniq | sed 's/>v//' | awk 'NR==1{print $1}'
	)
	echo "Found neovim latest veriosn: $version_latest"
	nvim_tarfile_name="nvim-linux64"
	nvim_version_file=$nvim_tarfile_name.$version_latest.tar.gz
fi

if [[ ! -f $nvim_version_file ]]; then
	curl -L $nvim_pkg_url > $nvim_version_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$nvim_version_file already exits."
	echo "Use cached version."
fi

mkdir -p $nvim_tarfile_name
tar -zxvf $nvim_version_file #-C $nvim_tarfile_name
ls -all
cp -rfv ./$nvim_tarfile_name/* $INSTALL_PREFIX/
rm -rf ./$nvim_tarfile_name
nvim --version
echo "neovim installed."
