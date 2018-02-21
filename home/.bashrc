#
# ~/.bashrc
#

if [ -f ~/.shrc ]; then
	source ~/.shrc
fi

[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

#powerline-shell settings{{{1
excf="~/git/net/powerline-shell/powerline-shell.py"
if [ -e $excf ]; then
	function _update_ps1() {
		export PS1="$(python2 $excf --colorize-hostname $? 2> /dev/null)"
	}
	export PROMPT_COMMAND=""
	TTY=`tty`
	[ -z "$TMUX" ] && [[ ! ("$TTY" =~ /dev/ttyS?[0-9]*) ]] && if [ -f $excf ]; then export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"; fi
fi
#1}}}

