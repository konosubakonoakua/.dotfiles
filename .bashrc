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
export PATH=$PATH:$HOME/rfe1wx/.local/bin:

# export http_proxy=http://127.0.0.1:3128
# export https_proxy=http://127.0.0.1:3128
# export ftp_proxy=http://127.0.0.1:3128

alias bat='bat -pp --theme="Nord"'
alias ls='exa -G --color auto --icons -a -s type'
alias ll='exa -l --color always --icons -a -s type'
alias tmux="TERM=screen-256color-bce tmux"
alias nvim='nvim --listen /tmp/nvim-server.pipe'

alias rce='nvim ~/.bashrc'
alias rcr='source ~/.bashrc'
alias uniq_hist='awk "!a[$0]++" $HISTFILE > $HISTFILE.tmp && mv $HISTFILE.tmp $HISTFILE'

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(zoxide init bash)"
eval "$(starship init bash)"
