#INFO: tested, works

#!/bin/bash
if [ -d ~/.dotfiles ]; then
	echo "already installed!!!"
	exit 1
else
	git clone --recurse-submodules https://github.com/konosubakonoakua/.dotfiles ~/.dotfiles
fi

# backup required
# delete old backups
if [ -d ~/.config/nvim.bak ]; then
	rm -rf ~/.config/nvim.bak
fi
if [ -d ~/.config/nvim ]; then
	mv ~/.config/nvim ~/.config/nvim.bak
fi

# # backup optional but recommended
# mv ~/.local/share/nvim{,.bak} #BUG: not working
# mv ~/.local/state/nvim{,.bak}
# mv ~/.cache/nvim{,.bak}

cd ~/.dotfiles
ln -s $(readlink -f ./.config/nvim) $(readlink -f ~/.config/nvim)
cd ./.config/nvim && git checkout main
