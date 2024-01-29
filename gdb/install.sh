#!/usr/bin/env bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

do_install() {
    # curl -L https://raw.githubusercontent.com/hugsy/gef/main/gef.py -o "$HOME/.gitinit"
    # wget -P ~ https://git.io/.gdbinit || \
    link_file "$src_conf/gdbinit" "$HOME/.gdbinit"
    if [[ ! "$(cat $HOME/.bashrc)" =~ "gdb-tmux" ]]; then
        cat ./gdb-tmux.sh >> "$HOME/.bashrc"
    fi
}

install -c 'gdb'

# https://github.com/cyrus-and/gdb-dashboard
# https://github.com/hugsy/gef
