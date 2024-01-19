#!/usr/bin/env bash
source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

dst_conf="$HOME/.config/nvim"

do_install() {
    mkdir -p "$dst_conf" 2>/dev/null
    link_file "$src_conf/nvim" "$dst_conf"
    return "$?"
}

check() {
    if [[ -z $(command -v nvim) ]]; then
        warn "nvim not installed!!!!!!."
        warn "consider using \"./scripts/install/install_neovim.sh nightly\""
        warn "https://github.com/neovim/neovim"
        return 0 # alway install the config even if neovim is not isntalled yet
    fi
}

install
