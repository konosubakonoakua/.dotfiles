#!/usr/bin/env bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

dst_conf_dir="$HOME/.config/lazygit"
mkdir -p "$dst_conf_dir"

check() {
    return 0 # do not check for neovide
}

do_install() {
    link_file "$src_conf/config.yml" "$dst_conf_dir/config.yml"
    return "$?"
}

install
