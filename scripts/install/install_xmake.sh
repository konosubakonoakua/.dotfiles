#!/bin/bash
if [[ ! -z "$(command -v curl)" ]]; then
    curl -fsSL https://xmake.io/shget.text | bash
elif [[ ! -z "$(command -v curl)" ]]; then
    wget https://xmake.io/shget.text -O - | bash
else
    echo "curl or wget not found."
fi

## powershell
# Invoke-Expression (Invoke-Webrequest 'https://xmake.io/psget.text' -UseBasicParsing).Content
#
