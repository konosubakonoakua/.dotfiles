#!/bin/bash

rm -rf /tmp/rustup.sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
chmod +x /tmp/rustup.sh

# send enter using echo
echo | /tmp/rustup.sh

