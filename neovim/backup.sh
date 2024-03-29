CUR_DIR=$(cd -P "$(dirname "$0")" && pwd -P)

backup-nvim() {
  local timestamp=$(date "+%Y-%m-%d-%H%M")
  echo "Backup following directories:"
  echo "  ~/.config/nvim"
  echo "  ~/.local/share/nvim"
  echo "  ~/.local/state/nvim"
  echo "  ~/.cache/nvim"

  pushd $HOME

  tar -cvzf $CUR_DIR/neovim.data.bak.${timestamp}.tar.gz \
    .local/share/nvim \
    .local/state/nvim \
    .cache/nvim

  tar -hcvzf $CUR_DIR/neovim.config.bak.${timestamp}.tar.gz \
    .config/nvim

  popd
}

restore-nvim() {
  echo "Found backups:"
  ls -lh neovim.data.*.tar.gz
  ls -lh neovim.config.*.tar.gz

  echo "Removing following directories:"
  echo "  ~/.config/nvim"
  echo "  ~/.local/share/nvim"
  echo "  ~/.local/state/nvim"
  echo "  ~/.cache/nvim"

  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.cache/nvim

  echo "Restoring directories..."
  tar -xvzf neovim.config.*.tar.gz -C $HOME
  tar -xvzf neovim.data.*.tar.gz -C $HOME
}

if [ "$1" == "backup" ];
then
  backup-nvim
elif [ "$1" == "restore" ]; then
  restore-nvim
else
  echo "./backup.sh [backup | restore]"
fi
