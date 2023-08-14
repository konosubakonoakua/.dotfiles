cd ~/Downloads
INSTALL_PREFIX=~/.local/
version_latest=$(
	curl -L https://github.com/neovim/neovim/releases/tag/stable |
		grep -oE 'v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>v//' | awk 'NR==1{print $1}'
)
echo "Found neovim latest veriosn: $version_latest"
nvim_tarfile_name="nvim-linux64"
nvim_version_file=$nvim_tarfile_name.$version_latest.tar.gz
if [[ ! -f $nvim_version_file ]]; then
	wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -O $nvim_version_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$nvim_version_file already exits."
	echo "Use cached version."
fi
mkdir -p $nvim_tarfile_name
tar -zxvf $nvim_version_file #-C $nvim_tarfile_name
ls -all
cp -rf ./$nvim_tarfile_name/* $INSTALL_PREFIX/
rm -rf ./$nvim_tarfile_name
nvim --version
echo "neovim installed."
