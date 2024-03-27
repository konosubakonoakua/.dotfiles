#!/usr/bin/env bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

dst_conf_dir="$HOME"

check() {
    return 0 # do not check for neovide
}

do_install() {
    link_file "$src_conf/.blerc" "$dst_conf_dir/.blerc"
    return "$?"
}

install
