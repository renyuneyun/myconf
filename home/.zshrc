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
zstyle :compinstall filename '~/.zshrc'

fpath=(.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit
# End of lines added by compinstall
zstyle ':completion:*' menu select #選擇自動補全項目
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
plscript='/usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh'
[[ ! ("$TTY" =~ /dev/ttyS?[0-9]*) ]] && if [ -f $plscript ]; then source $plscript; fi
# }}}

hash thefuck &>/dev/null && eval $(thefuck --alias)

export VENV_LOCATION=$HOME/venvs
function venv {
	env_name=$1
	env_dir=$VENV_LOCATION/$env_name
	if [ -d $env_dir ]; then
		source $env_dir/bin/activate
	else
		echo Virtual Environment $env_name doesn\'t exist
	fi
}

