curl -sS https://starship.rs/install.sh | sh
[[ "$?" != "0" ]] && exit 1
[[ "$(cat ~/.bashrc)" =~ "starship init bash" ]] || echo 'eval "$(starship init bash)"'
