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
	eza
	git-delta
	zoxide
	dua
)
cargo install --locked ${cargo_tools[*]}

bashrc_eza="
if hash eza 2>/dev/null; then
	alias l='eza --color=auto --icons -F'
	alias ls='eza -l --color=auto --icons -F --group-directories-first --git'
	alias ll='eza -l --color=auto --icons -F --all --group-directories-first --git'
	alias lt='eza -T --color=auto --icons -F --git-ignore --level=2 --group-directories-first'
	alias llt='eza -lT --color=auto --icons -F --git-ignore --level=2 --group-directories-first'
	alias lT='eza -T --color=auto --icons -F --git-ignore --level=4 --group-directories-first'
else
	alias l='ls -lah'
	alias ll='ls -alF'
	alias la='ls -A'
fi
"
