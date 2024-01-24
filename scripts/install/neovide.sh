bash install_from_github_release.sh \
	~/Downloads/neovide \
	~/.local/bin \
	'https://github.com' \
	'neovide/neovide/releases' \
	'neovide/neovide/releases/download' \
	'>[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' \
	's/>//' \
	'' \
	'' \
	'neovide' \
	'neovide-linux-x86_64.tar.gz' \
	'zip' \
	'tar -zxvf'
