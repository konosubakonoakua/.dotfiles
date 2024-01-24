# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="&:ls:[bf]g:exit:pwd:clear"

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# EXPORTS
export FZF_DEFAULT_OPTS="--height 16"
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:
# export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/.local/lib/pkgconfig:$HOME/.local/lib/x86_64-linux-gnu/pkgconfig:
export PATH=$HOME/.local/bin:$PATH:

# export http_proxy=http://127.0.0.1:3128
# export https_proxy=http://127.0.0.1:3128
# export ftp_proxy=http://127.0.0.1:3128

alias tmux="TERM=screen-256color-bce tmux"
# alias nvim='nvim --listen /tmp/nvim-server.pipe'
alias rce='nvim ~/.bashrc'
alias rcr='source ~/.bashrc'
rcc() {
  datetime=$(date +%s)
  mkdir -p $HOME/.bash_history_bak
  cp $HOME/.bash_history $HOME/.bash_history_bak/.bash_history.$datetime
  awk '$1=$1' $HISTFILE > $HISTFILE.tmp     # remove all unnecessary spaces
  awk '!a[$0]++' $HISTFILE.tmp > $HISTFILE  # remove all dups
  rm $HISTFILE.tmp
}
mkcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}
[ -x "exa" ] && alias ls='exa -G --color auto --icons -a -s type'
[ -x "exa" ] && alias ll='exa -l --color always --icons -a -s type'
[ -x "bat" ] && alias bat='bat -pp --theme="Nord"'

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(zoxide init bash)"
eval "$(starship init bash)"
