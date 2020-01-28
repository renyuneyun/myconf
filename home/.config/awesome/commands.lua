local commands = {
    lock = "xscreensaver-command -lock",
    hangup = "systemctl suspend",
    shutdown = "zenity --question --title '关机' --text '你确定关机吗？' --default-cancel --timeout 30 && systemctl poweroff",
}

return commands
