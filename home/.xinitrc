#!/bin/sh

export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE="zh_CN.UTF-8:zh_CN.GB18030:zh_TW:en_US"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#export OXYGEN_DISABLE_INNER_SHADOWS_HACK=1

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi
# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/* ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

function run_progs() {
	fcitx-autostart &
	env -u PYTHONPATH calised &
	#Now as systemd daemon[[[0
	#transmission-daemon
	#exec aria2c &
	#0]]]
}
run_progs

S_KDE="/usr/bin/startkde"
S_KDE_FAILSAFE="/usr/bin/startkde --failsafe"
S_GNOME="/usr/bin/gnome-session"
S_ENLIGHTENMENT="/usr/bin/enlightenment_start"
S_AWESOME="/usr/bin/awesome"
S_QTILE="/usr/bin/qtile-session"
DEFAULT_SESSION=$S_AWESOME

function run_session() {
	case $1	in
		$S_KDE)
			exec $S_KDE
			;;
		$S_KDE_FAILSAFE)
			exec $S_KDE_FAILSAFE
			;;
		$S_GNOME)
			exec $S_GNOME
			;;
		$S_AWESOME)
			exec nm-applet &
			exec guake &
			exec $S_AWESOME
			;;
		$S_QTILE)
			exec $S_QTILE
			;;
		*)
			exec nm-applet &
			exec guake &
			#exec $SESSION
			exec $S_KDE
			;;
	esac
}

SESSION=$DEFAULT_SESSION
if [ -n $2 ]; then
	case $2 in
		$S_KDE | "kde")
			SESSION=$S_KDE
			;;
		$S_KDE_FAILSAFE|"kde failsafe")
			SESSION=$S_KDE_FAILSAFE
			;;
		$GNOME|"gnome")
			SESSION=$S_GNOME
			;;
		$S_AWESOME|"awesome")
			SESSION=$S_AWESOME
			;;
		$S_QTILE|"qtile")
			SESSION=$S_QTILE
			;;
		*)
			SESSION=$DEFAULT_SESSION
			;;
	esac
else
	SESSION=$DEFAULT_SESSION
fi
run_session $SESSION

function clean_up() {
	calised --stop
}
clean_up
