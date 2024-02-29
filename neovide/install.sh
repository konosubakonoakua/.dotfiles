#!/usr/bin/env bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

dst_conf_dir="$HOME/.config/neovide"
mkdir -p "$dst_conf_dir"

check() {
    return 0 # do not check for neovide
}

do_install() {
    link_file "$src_conf/config.toml" "$dst_conf_dir/config.toml"
    return "$?"
}

install
