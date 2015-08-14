#!/bin/sh
LOG=/tmp/startx.log

echo $# > $LOG
echo $* >> $LOG

export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE="zh_CN.UTF-8:zh_CN.GB18030:zh_TW:en_US"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#export OXYGEN_DISABLE_INNER_SHADOWS_HACK=1 #A hack for monodevelop

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
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

S_KDE="/usr/bin/startkde"
S_KDE_FAILSAFE="/usr/bin/startkde --failsafe"
S_GNOME="/usr/bin/gnome-session"
S_ENLIGHTENMENT="/usr/bin/enlightenment_start"
S_AWESOME="/usr/bin/awesome"
S_I3="/usr/bin/i3"
S_QTILE="/usr/bin/qtile-session"
S_DEFAULT=$S_AWESOME

T_DE="de"
T_WM="wm"
T_DEFAULT=$T_WM

function run_session() {
	case $TYPE in
		$T_WM)
			nm-applet &
			guake &
			goldendict &
			conky &
			pasystray &
			xautolock -detectsleep -time 30 -locker 'systemctl suspend' &
			;;
	esac
	numlockx &
	fcitx-autostart &
	exec $SESSION
}

SESSION=$S_DEFAULT
TYPE=$T_DEFAULT
if [ $# -gt 0 ]; then
	iSESSION=$*
	case "${iSESSION:6}" in
		$S_KDE|"kde")
			SESSION=$S_KDE
			TYPE=$T_DE
			;;
		$S_KDE_FAILSAFE|"kde failsafe")
			SESSION=$S_KDE_FAILSAFE
			TYPE=$T_DE
			;;
		$GNOME|"gnome")
			SESSION=$S_GNOME
			TYPE=$T_DE
			;;
		$S_AWESOME|"awesome")
			SESSION=$S_AWESOME
			TYPE=$T_WM
			;;
		$S_ENLIGHTENMENT|"enlightenment")
			SESSION=$S_ENLIGHTENMENT
			TYPE=$T_DE
			;;
		$S_I3|"i3")
			SESSION=$S_I3
			TYPE=$T_WM
			;;
		$S_QTILE|"qtile")
			SESSION=$S_QTILE
			TYPE=$T_WM
			;;
	esac
fi
run_session $TYPE
