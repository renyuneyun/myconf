if [ -f /etc/zsh/zprofile ]; then
	source /etc/zsh/zprofile
fi
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=20000
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

# fzf
f_fzf_base=/usr/share/fzf
f_fzf_kb=${f_fzf_base}/key-bindings.zsh
f_fzf_cmp=${f_fzf_base}/completion.zsh
[[ -s $f_fzf_kb ]] && source $f_fzf_kb
[[ -s $f_fzf_cmp ]] && source $f_fzf_cmp

# powerline {{{
TTY=`tty`
PY_VER=$(python -c 'import sys; v=sys.version_info; print("%s.%s" % (v.major, v.minor))')
plscript="/usr/lib/python${PY_VER}/site-packages/powerline/bindings/zsh/powerline.zsh"
[[ ! ("$TTY" =~ /dev/ttyS?[0-9]*) ]] && if [ -f $plscript ]; then source $plscript; fi
# }}}
