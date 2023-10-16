#INFO: tested, works good

#########################################
# Maybe need make uninstall first then install when you encountered wierd errors
# make $PKG_FOLDER install
# https://github.com/neovim/neovim/wiki/Building-Neovim
#########################################

# TODO: using `which` first to test installed
# deps=(git build-essential make ninja-build gettext xclip cmake unzip curl python3.10-venv)
# dpkg -s ${deps[*]} >/dev/null
# [[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

PKG_FOLDER=~/Downloads/neovim
INSTALL_PREFIX=$HOME/.local/
MAKE_FLAGS=CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX
# MAKE_FLAGS+=\ CMAKE_BUILD_TYPE=RelWithDebInfo
MAKE_FLAGS+=\ CMAKE_BUILD_TYPE=Release

if [ -d $PKG_FOLDER ]; then
	echo "$PKG_FOLDER already exists"
	cd $PKG_FOLDER
	git pull origin
else
	git clone https://github.com/neovim/neovim $PKG_FOLDER
	cd $PKG_FOLDER
fi

if [ "$1" = "nightly" ]; then
	echo "checking out to nightly"
	git checkout master
else
	echo "checking out to stable"
	git checkout stable
fi
make distclean
make $MAKE_FLAGS install -j
# rm -rf $PKG_FOLDER
