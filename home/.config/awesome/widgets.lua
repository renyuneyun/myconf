local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")
local lain  = require("lain")
local theme = require("beautiful").get()

function rvbg(mywidget)
    return wibox.container.background(mywidget, theme.bg_focus)
end

local function hex_proportion(hexstr, percent)
    local num = tonumber(hexstr, 16)
    num = math.floor(num + (255 - num) * percent)
    return num
end

local function pp_rgb(color, percent)
    -- Higher percent value is, deeper the color is
    if type(percent) ~= "number" then percent = tonumber(percent) end
    if percent > 100 then percent = 100 end
    if percent > 1 then percent = percent / 100 end
    if percent < 0 then percent = 0 end
    local r = hex_proportion(color:sub(2,3), percent)
    local g = math.floor(tonumber(color:sub(4,5), 16) * (1-percent))
    local b = math.floor(tonumber(color:sub(6,7), 16) * (1-percent))
    return string.format("#%X%X%X", r, g, b)
end

local markup = lain.util.markup

local separators = lain.util.separators
arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
arrl_ld = separators.arrow_left("alpha", theme.bg_focus)

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
--mytextclock = awful.widget.textclock(" %Y年%m月%d日 %H:%M:%S %a ", 1)
mytextclock = wibox.widget.textclock(" %m月%d日 %H:%M:%S %a ", 1)

-- Calendar
theme.cal = lain.widget.calendar({
    attach_to = { mytextclock },
    notification_preset = {
        font = "xos4 Terminus 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- MPD widget {{{
-- Initialize widget
local mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdwidget = wibox.widget.textbox()
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
function (mpdwidget, args)
    local state = args["{state}"]
    if state == "Stop" then
        mpdicon:set_image(theme.widget_music)
        return " - "
    else
        if state == "Pause" then
            mpdicon:set_image(theme.widget_music)
        else
            mpdicon:set_image(theme.widget_music_on)
        end
        return args["{Artist}"]..' - '.. args["{Title}"]
    end
end, 10)
mpdwidget = wibox.widget {
    mpdicon,
    mpdwidget,
    layout = wibox.layout.align.horizontal
}
mpdwidget:buttons(awful.util.table.join(
awful.button({ }, 1, function () awful.util.spawn("mpc toggle") end),
awful.button({ }, 4, function () awful.util.spawn("mpc volume +5") end),
awful.button({ }, 5, function () awful.util.spawn("mpc volume -5") end)
))
-- }}}

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget.value = mem_now.perc
    end
})
mem.widget = wibox.widget {
    min_value = 0,
    max_value = 100,
    thickness = 4,
    widget = wibox.container.arcchart
}
memwidget = wibox.widget {
    memicon,
    mem.widget,
    layout = wibox.layout.stack
}

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget.value = cpu_now.usage
    end
})
cpu.widget = wibox.widget {
    min_value = 0,
    max_value = 100,
    thickness = 4,
    widget = wibox.container.arcchart
}
cpuwidget = wibox.widget {
    cpuicon,
    cpu.widget,
    layout = wibox.layout.stack
}

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})
tempwidget = wibox.widget {
    tempicon,
    temp,
    layout = wibox.layout.align.horizontal
}

-- / fs
local fsicon = wibox.widget.imagebox(theme.widget_hdd)
theme.fs = lain.widget.fs({
    options  = "--exclude-type=tmpfs",
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "xos4 Terminus 10" },
    settings = function()
        local color = pp_rgb(theme.fg_normal, 100-fs_now.used)
        widget:set_markup(markup.font(theme.font, string.format(" <span color=\"%s\">%d</span>%% ", color, fs_now.used)))
    end
})
fswidget = wibox.widget {
    fsicon,
    theme.fs.widget,
    layout = wibox.layout.align.horizontal
}

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                widget:set_markup(markup.font(theme.font, " AC "))
                baticon:set_image(theme.widget_ac)
                return
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            local color = pp_rgb(theme.fg_normal, 100-bat_now.perc)
            widget:set_markup(markup.font(theme.font, string.format(" <span color=\"%s\">%d</span>%% <span color=\"#2976F2\">餘</span>%s ", color, bat_now.perc, bat_now.time)))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})
batwidget = wibox.widget {
    baticon,
    bat,
    layout = wibox.layout.align.horizontal
}

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(theme.font,
                          markup("#7AC82E", " " .. net_now.received)
                          .. " " ..
                          markup("#46A8C3", " " .. net_now.sent .. " ")))
    end
})
netwidget = wibox.widget {
    neticon,
    net.widget,
    layout = wibox.layout.align.horizontal
}

