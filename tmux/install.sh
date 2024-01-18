#!/usr/bin/env bash
source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

do_install() {
    mkdir -p "$dst_conf" 2>/dev/null
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/konosubakonoakua/.tmux/master/install.sh)"
    link_file "$src_conf/tmux.conf.lcoal" "$dst_conf/tmux.conf.lcoal"
}

install
