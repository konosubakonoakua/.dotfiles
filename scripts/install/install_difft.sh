PKG_FOLDER=~/Downloads/difft
INSTALL_PREFIX=$HOME/.local/

version_latest=$(
	curl -L https://github.com/Wilfred/difftastic/releases/ |
		grep -oE '>[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>//' | awk 'NR==1{print $1}'
)
echo "Found difft latest veriosn: $version_latest"
difft_pkg_file=difft-x86_64-unknown-linux-gnu.tar.gz
difft_pkg_folder=difft-x86_64-unknown-linux-gnu

# https://github.com/Wilfred/difftastic/releases/download/0.54.0/difft-x86_64-unknown-linux-gnu.tar.gz
[[ ! -d $PKG_FOLDER ]] && mkdir $PKG_FOLDER
cd $PKG_FOLDER

if [[ ! -f $difft_pkg_file ]]; then
	wget https://github.com/Wilfred/difftastic/releases/download/$version_latest/$difft_pkg_file
	[[ ! $? -eq 0 ]] && exit 1
else
	echo "$difft_pkg_file already exits."
	echo "Use cached version."
fi

tar -zxvf $difft_pkg_file
chmod +x ./difft && cp -f ./difft $INSTALL_PREFIX/bin/
echo "difft installed."
