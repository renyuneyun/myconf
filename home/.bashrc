#
# ~/.bashrc
#

if [ -f ~/.shrc ]; then
	source ~/.shrc
fi

[[ $- != *i* ]] && return

#set en locale for tty {{{1
TTY=`tty`
[[ ($TTY =~ /dev/ttyS?[0-9]*) ]] && export LANG='en_US.UTF-8'
#1}}}

#powerline-shell settings{{{1
function _update_ps1() {
	export PS1="$(python2 ~/git/net/powerline-shell/powerline-shell.py --colorize-hostname $? 2> /dev/null)"
}
export PROMPT_COMMAND=""
TTY=`tty`
[ -z "$TMUX" ] && [[ ! ("$TTY" =~ /dev/ttyS?[0-9]*) ]] && export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#1}}}

