#INFO: tested, works good

###
# download fonts https://www.nerdfonts.com/font-downloads
# extract them into ~/.fonts/
# refresh fonts with fc-cache
# PS: size=12 family=blex
###

release_link=https://github.com/ryanoasis/nerd-fonts/releases
download_link=$release_link/download
fonts=(IBMPlexMono JetBrainsMono Lilex)
PKG_FOLDER=~/Downloads/nerdfonts
INSTALL_PREFIX=$HOME/.fonts/
mkdir -p $INSTALL_PREFIX && mkdir -p $PKG_FOLDER
cd $PKG_FOLDER

version_latest=$(
	curl -L $release_link |
		grep -oE '>v[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' |
		sort -r --version-sort | uniq | sed 's/>v//' | awk 'NR==1{print $1}'
)
echo "Found nerdfonts latest veriosn: $version_latest"

for font in ${fonts[@]}; do
	echo "Installing $font...."
	if [[ ! -f $font.zip ]]; then
		wget $download_link/v$version_latest/${font}.zip
		[[ ! $? -eq 0 ]] && echo "Install $font failed." && exit 1
	else
		echo "$font.zip already exits."
		echo "Use cached version."
	fi

	rm -rf ./*.md
	rm -rf ./*.txt
	unzip $font.zip
	mv ./*.ttf $INSTALL_PREFIX || rm -f ./*.ttf

	echo "Installed $font...."
done

# fc-cache [ -EfrsvVh ] [ –error-on-no-fonts ]
#   [ –force ] [ –really-force ] [ [ -y dir ]
#   [ –sysroot dir ] ] [ –system-only ]
#   [ –verbose ] [ –version ] [ –help ] [ dir… ]
fc-cache -fv
