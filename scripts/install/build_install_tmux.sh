#INFO: tested, works good

#########################################
# https://github.com/tmux/tmux/wiki/Installing
#########################################

deps=(automake libevent-dev ncurses-dev build-essential bison pkg-config)
dpkg -s ${deps[*]} >/dev/null
[[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

PKG_FOLDER=~/Downloads/tmux
INSTALL_PREFIX=$HOME/.local/
git clone https://github.com/tmux/tmux.git $PKG_FOLDER
cd $PKG_FOLDER
sh autogen.sh
./configure --prefix=$INSTALL_PREFIX
make && make install && echo "Tmux installed"
