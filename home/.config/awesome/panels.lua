local awful = require("awful")
local wibox = require("wibox")
local common = require("awful.widget.common")
local beautiful = require("beautiful")
require("widgets")

local theme = require("theme.theme")
local dpi = require("theme.utils").dpi

theme.panels = {
    top_height = dpi(24),
    left_width = dpi(26),
    taglist_margin = {
        dpi(6), dpi(0), dpi(2), dpi(2),
    },
}

panels = {}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients()
        end
    end
end
-- }}}

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
            bgb = wibox.container.background()
            m = wibox.container.margin(tb, table.unpack(theme.panels.taglist_margin))
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

function panels.setup_top_panel()

    local tasklist_buttons = awful.util.table.join(
                         awful.button({ }, 1, function (c)
                                                  if c == client.focus then
                                                      c.minimized = true
                                                  else
                                                      -- Without this, the following
                                                      -- :isvisible() makes no sense
                                                      c.minimized = false
                                                      if not c:isvisible() and c.first_tag then
                                                          c.first_tag:view_only()
                                                      end
                                                      -- This will also un-minimize
                                                      -- the client, if needed
                                                      client.focus = c
                                                      c:raise()
                                                  end
                                              end),
                         awful.button({ }, 3, client_menu_toggle_fn()),
                         awful.button({ }, 4, function ()
                                                  awful.client.focus.byidx(1)
                                              end),
                         awful.button({ }, 5, function ()
                                                  awful.client.focus.byidx(-1)
                                              end))

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
        s.mywibox = awful.wibar({ position = "top", screen = s, height=theme.panels.top_height })

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                panels.mylauncher,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mpdwidget,
                arrl_ld,
                rvbg(fswidget),
                arrl_dl,
                batwidget,
                arrl_ld,
                rvbg(netwidget),
                arrl_dl,
                mykeyboardlayout,
                mytextclock,
                s.mylayoutbox,
            },
        }
    end)
end


function panels.setup_left_panel(taglist_buttons)
    -- Create a wibox for each screen and add it
    local taglist_buttons = awful.util.table.join(
                        awful.button({ }, 1, function(t) t:view_only() end),
                        awful.button({ modkey }, 1, function(t)
                                                  if client.focus then
                                                      client.focus:move_to_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ modkey }, 3, function(t)
                                                  if client.focus then
                                                      client.focus:toggle_tag(t)
                                                  end
                                              end),
                        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                    )

    local isystray = wibox.widget.systray()
    isystray:set_horizontal(false)

    awful.screen.connect_for_each_screen(function(s)
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, nil, vert_list_update, wibox.layout.fixed.vertical())

        s.mywibox_left = awful.wibar({ position = "left", screen = s, width = theme.panels.left_width })
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
                cpuwidget,
                memwidget,
                swapwidget,
            },
        }
    end)
end

function panels.setup(mymainmenu)
    panels.mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = mymainmenu })

    panels.setup_top_panel()
    panels.setup_left_panel()
end

return panels
