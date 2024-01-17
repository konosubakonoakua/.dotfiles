# # backup optional but recommended
# mv ~/.local/share/nvim{,.bak} #BUG: not working well
# mv ~/.local/state/nvim{,.bak}
# mv ~/.cache/nvim{,.bak}

seconds="$(date +%s)"
dst="$HOME/.config/nvim"
repo="$HOME/.config/lazyvim.conf"
repo_url="https://github.com/konosubakonoakua/lazyvim.conf.git"
code_url="https://codeload.github.com/konosubakonoakua/lazyvim.conf/zip/refs/heads/main "
git_installed=false

if command -v git &> /dev/null; then
    git_installed=true
else
    echo "Git is not installed.\n Please use zipfile instead."
    exit 1
fi

if [ "$git_installed" = true ]; then
  [ ! -d "$repo" ] && git clone "$repo_url" "$repo"
  cd "$repo"
  git checkout main
  cd -
else
  mkdir -p "$repo"
  curl -L "$code_url" -o "$repo.zip"
  tar -zxvf "$repo.zip" -C "$repo"
fi

if [ -L "$dst" ]; then
  old_link=$(readlink -f "$dst")
  echo "symbol-link to $old_link already exists: $dst"
  echo "and will be removed."
  rm "$dst"
elif [ -d "$dst" ]; then
  echo "$dst already exists!!!"
  echo "backup to $dst.bak.$seconds"
  mv "$dst" "$dst.bak.$seconds"
fi

# ln -s <target> <linkname>
ln -s $(readlink -f "$repo") $(readlink -f "$dst") && \
  echo "Linked ${dst} to ${repo}" && \
  exit 0

echo "Failed!!!!!!!!!!!!!"
exit 1
