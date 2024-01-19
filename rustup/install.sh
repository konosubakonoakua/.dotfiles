check() {
    return 0
}

do_install() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    return $?
}

install
