#!/usr/bin/env bash

source "$(cd -P "$(dirname "$0")" && pwd -P)/../base.sh"

# copy scripts as executable to "~/.local/bin"
do_install() {
    script_dst=$HOME/.local/bin
    if [[ ! $PATH =~ $script_dst ]]; then
        echo 'PATH=$HOME/.local/bin:$PATH' >> "$HOME/.bashrc"
    fi

    mkdir -p "$script_dst" 2>/dev/null
    find "$src_conf" -name '*install.sh' -prune \
        -o -path '*/\.git' -prune \
        -o -path '*/install' -prune \
        -o -executable -type f -print | {
        while read -r file; do
            link_file "$file" "$script_dst/$(basename $file)" </dev/tty
        done
    }
}

install
