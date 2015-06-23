# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/guhua/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
if [ -f ~/.shrc ]; then
	source ~/.shrc
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# powerline {{{
TTY=`tty`
plscript='/usr/share/zsh/site-contrib/powerline.zsh'
[ -z "$TMUX" ] && [[ ! ("$TTY" =~ /dev/ttyS?[0-9]*) ]] && if [ -f $plscript ]; then source $plscript; fi
# }}}
