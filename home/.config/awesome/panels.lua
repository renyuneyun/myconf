local awful = require("awful")
local wibox = require("wibox")
local common = require("awful.widget.common")
local vicious = require("vicious")

local function vert_list_update(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, m, l
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            m   = cache.m
        else
            ib = wibox.widget.imagebox()
            tb = wibox.widget.textbox()
            bgb = wibox.widget.background()
            m = wibox.layout.margin(tb, 12, 4)
            l = wibox.layout.fixed.vertical()

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ib)
            l:add(m)

            -- And all of this gets a background
            bgb:set_widget(l)

            bgb:buttons(common.create_buttons(buttons, o))

            data[o] = {
                ib = ib,
                tb = tb,
                bgb = bgb,
                m   = m
            }
        end

        local text, bg, bg_image, icon = label(o)
        -- The text might be invalid, so use pcall
        if not pcall(tb.set_markup, tb, text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        end
        bgb:set_bg(bg)
        if type(bg_image) == "function" then
            bg_image = bg_image(tb,o,m,objects,i)
        end
        bgb:set_bgimage(bg_image)
        ib:set_image(icon)
        w:add(bgb)
    end
end

-- MPD widget {{{
-- Initialize widget
mpdwidget = wibox.widget.textbox()
mpdwidget:buttons(awful.util.table.join(
awful.button({ }, 1, function () awful.util.spawn("mpc toggle") end),
awful.button({ }, 4, function () awful.util.spawn("mpc volume +5") end),
awful.button({ }, 5, function () awful.util.spawn("mpc volume -5") end)
))
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
function (mpdwidget, args)
    if args["{state}"] == "Stop" then 
        return " - "
    else 
        return args["{Artist}"]..' - '.. args["{Title}"]
    end
end, 10)
-- }}}

-- {{{ CPU
-- Initialize widget
cpuwidget = wibox.widget.textbox()
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, " | $1%")
-- CPU }}}

-- {{{ net
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, " | D:${wlp2s0 down_kb} | U:${wlp2s0 up_kb} ")
-- net }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
--mytextclock = wibox.widget.textclock()
mytextclock = awful.widget.textclock(" %Y年%m月%d日 %H:%M:%S %a ", 1)

function setup_panels(taglist_buttons, tasklist_buttons)
    setup_top_panel(tasklist_buttons)
    setup_left_panel(taglist_buttons)
end

function setup_top_panel(tasklist_buttons)
    awful.screen.connect_for_each_screen(function(s)
        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contains an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(awful.util.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)))

        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

        -- Create the wibox
        s.mywibox = awful.wibar({ position = "top", screen = s })

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mpdwidget,
                cpuwidget,
                netwidget,
                mykeyboardlayout,
                mytextclock,
                s.mylayoutbox,
            },
        }
    end)
end


function setup_left_panel(taglist_buttons)
    local isystray = wibox.widget.systray()
    isystray:set_horizontal(false)

    awful.screen.connect_for_each_screen(function(s)
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, nil, vert_list_update, wibox.layout.fixed.vertical())

        s.mywibox_left = awful.wibox({ position = "left", screen = s, width = 40 })
        s.mywibox_left:setup {
            layout = wibox.layout.align.vertical,
            { -- Top widgets
                layout = wibox.layout.fixed.vertical,
                s.mytaglist,
            },
            {
                layout = wibox.layout.fixed.vertical,
            },
            { -- Bottom widgets
                layout = wibox.layout.fixed.vertical,
                isystray,
            },
        }
    end)
end
