local awful = require("awful")

function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
      findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("fcitx-autostart")
run_once("klipper")
run_once("goldendict")
run_once("pasystray")
run_once("nm-applet")
run_once("guake")
run_once("conky")
run_once("xautolock -detectsleep -time 30 -locker 'systemctl suspend'")
run_once("numlockx")
run_once("powerline-daemon")
run_once("kdeconnect-indicator")
run_once("albert")
