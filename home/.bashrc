#
# ~/.bashrc
#
export PATH="$PATH:$HOME/bin"
export EDITOR="vim"

[[ $- != *i* ]] && return

#ENGLISH LOCALE {{{1
TTY=`tty`
[[ ($TTY =~ /dev/ttyS?[0-9]*) ]] && export LANG='en_US.UTF-8'
#1}}}

#powerline-shell settings{{{1
function _update_ps1() {
	export PS1="$(python2 ~/git/web/powerline-shell/powerline-shell.py --colorize-hostname $? 2> /dev/null)"
}
export PROMPT_COMMAND=""
TTY=`tty`
[[ ! ("$TTY" =~ /dev/ttyS?[0-9]*) ]] && export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#1}}}

#alias{{{2
alias vim='env -u PYTHONPATH vim'
alias ls='ls --color=auto'
alias ll='ls -l'
#2}}}
