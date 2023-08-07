#INFO: tested, works good

#########################################
# Maybe need make uninstall first then install when you encountered wierd errors
# make $GIT_SRC install
# https://github.com/neovim/neovim/wiki/Building-Neovim
#########################################

deps=(git build-essential make ninja-build gettext cmake unzip curl)
dpkg -s ${deps[*]} >/dev/null
[[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

GIT_SRC=~/Downloads/neovim
INSTALL_PREFIX=$HOME/.local/
MAKE_FLAGS=CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX
MAKE_FLAGS+=\ CMAKE_BUILD_TYPE=RelWithDebInfo

git clone https://github.com/neovim/neovim $GIT_SRC
[[ ! -d $GIT_SRC ]] && return 1
cd $GIT_SRC && git checkout stable
make distclean
make $MAKE_FLAGS install -j
