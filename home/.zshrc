if [ -f /etc/zsh/zprofile ]; then
	source /etc/zsh/zprofile
fi
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
#擴展路徑
setopt complete_in_word

if [ -f ~/.shrc ]; then
	source ~/.shrc
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# powerline {{{
TTY=`tty`
plscript='/usr/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh'
[[ ! ("$TTY" =~ /dev/ttyS?[0-9]*) ]] && if [ -f $plscript ]; then source $plscript; fi
# }}}

eval $(thefuck --alias)
