#INFO: tested, works

#!/bin/bash

# backup required
mv ~/.config/nvim{,.bak}

# # backup optional but recommended
# mv ~/.local/share/nvim{,.bak} #BUG: not working
# mv ~/.local/state/nvim{,.bak}
# mv ~/.cache/nvim{,.bak}

ln -s $(readlink -f ../nvim) $(readlink -f ~/.config/nvim)
cd ../nvim
git submodule init
git submodule update --remote
git checkout main
