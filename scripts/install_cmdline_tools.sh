#INFO: tested, works

rustup -V
if [[ $? -ne 0 ]]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

cargo version
if [[ $? -ne 0 ]]; then
	echo "Cargo should be installed."
	exit 1
fi

cargo_tools=(
	ripgrep
	fd-find
	bat
	miniserve
	zellij
	starship
	procs
	du-dust
	exa
	git-delta
	zoxide
	dua
)
cargo install --locked ${cargo_tools[*]}

bashrc_exa="
  if hash exa 2>/dev/null; then
      alias ls='exa'
      alias l='exa -l --all --group-directories-first --git'
      alias ll='exa -l --all --all --group-directories-first --git'
      alias lt='exa -T --git-ignore --level=2 --group-directories-first'
      alias llt='exa -lT --git-ignore --level=2 --group-directories-first'
      alias lT='exa -T --git-ignore --level=4 --group-directories-first'
  else
      alias l='ls -lah'
      alias ll='ls -alF'
      alias la='ls -A'
  fi
"
