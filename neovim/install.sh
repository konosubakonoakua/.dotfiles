#!/usr/bin/env bash
source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

dst_conf="$HOME/.config/nvim"
repo="$HOME/.config/lazyvim.conf"
repo_url="https://github.com/konosubakonoakua/lazyvim.conf.git"

do_install() {
    [ ! -d "$repo" ] && git clone "$repo_url" "$repo"
    cd "$repo"
    git checkout main
    cd -
    # mkdir -p "$dst_conf" 2>/dev/null
    link_file "$repo" "$dst_conf"
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
