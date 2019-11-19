if [ -f /etc/zsh/zprofile ]; then
	source /etc/zsh/zprofile
fi
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

fpath=(.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/share/zsh/site-functions $fpath)
autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall

zstyle ':completion:*' menu select  # 選擇自動補全項目
# 自動cd
setopt autocd
#擴展路徑
setopt complete_in_word
# 歷史記錄去重複
setopt HIST_IGNORE_DUPS

if [ -f ~/.shrc ]; then
	source ~/.shrc
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# fish風格的命令提示
f_zas=/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -s $f_zas ]] && source $f_zas

# autojump
f_aj=$HOME/.autojump/etc/profile.d/autojump.sh
[[ -s $f_aj ]] && source $f_aj

# fzf-z
f_fzf_z=/home/ryey/vcs/fzf-z/fzf-z.plugin.zsh
[[ -s $f_fzf_z ]] && source $f_fzf_z && export FZFZ_RECENT_DIRS_TOOL=autojump

# powerline {{{
TTY=`tty`
plscript='/usr/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh'
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

