#INFO: tested, works good

#########################################
# https://github.com/tmux/tmux/wiki/Installing
#########################################

deps=(libevent-dev ncurses-dev build-essential bison pkg-config)
dpkg -s ${deps[*]} >/dev/null
[[ ! $? -eq 0 ]] && sudo apt install ${deps[*]}

GIT_SRC=~/Downloads/tmux
INSTALL_PREFIX=$HOME/.local/
git clone https://github.com/tmux/tmux.git $GIT_SRC
cd $GIT_SRC
sh autogen.sh
./configure --prefix=$INSTALL_PREFIX
make && make install && echo "Tmux installed"
