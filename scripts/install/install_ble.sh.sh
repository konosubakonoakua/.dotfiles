info() {
  printf '%s\n' "${BOLD}${GREY}>${NO_COLOR} $*"
}

mkdir -p $HOME/Downloads/blesh
cd $HOME/Downloads/blesh
rm -rf ./ble*
curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf -
bash ble-nightly/ble.sh --install ~/.local/share
if [[ "$(cat $HOME/.bashrc)" =~ "blesh/ble.sh" ]]; then
    info '.bashrc already configured!'
else
    echo '[ -f ~/.blerc ] && source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
    info '.bashrc updated!'
fi

