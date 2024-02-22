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

alias nviml='nvim -R -u NONE -c "set nowrap nofoldenable ft= syntax=off ttyfast"'
alias viml='vim -R -u NONE -c "set nowrap nofoldenable ft= syntax=off ttyfast"'
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
mkdircd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}
scp_from () {
  if [ -z $SCP_SERVER ]; then
    echo "SCP_SERVER not defined"
    return 1
  fi
  src="$USER@$SCP_SERVER:$1"
  dst="$2"
  cmd="scp $src $dst"
  echo "Please confirm:"
  echo ">>>>$cmd"
  read -p "y[Y]? " -n 1 -r
  echo "" # newline
  [[ $REPLY =~ ^[Yy]$ ]] && bash -c "${cmd}"
  return 1
}
scp_to () {
  if [ -z $SCP_SERVER ]; then
    echo "SCP_SERVER not defined"
    return 1
  fi
  dst="$USER@$SCP_SERVER:$1"
  src="$2"
  cmd="scp $src $dst"
  echo "Please confirm:"
  echo ">>>>$cmd"
  read -p "y[Y]? " -n 1 -r
  echo "" # newline
  [[ $REPLY =~ ^[Yy]$ ]] && bash -c "${cmd}"
  return 1
}
[ -x "$(command -v exa)" ] && alias ls='exa -G --color auto --icons -a -s type'
[ -x "$(command -v exa)" ] && alias ll='exa -l --color always --icons -a -s type'
[ -x "$(command -v bat)" ] && alias bat='bat -pp --theme="Nord"'

[ -x "$(command -v difft)" ] && export GIT_EXTERNAL_DIFF="difft"
[ -z "$TMUX" ] && export EDITOR="vi" && export VISUAL="vi"
# [ -x "$(command -v vi)" -a -z "$TMUX" ] && export EDITOR="vi" && export VISUAL="vi"


[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(zoxide init bash)"
eval "$(starship init bash)"
