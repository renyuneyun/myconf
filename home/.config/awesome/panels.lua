local awful = require("awful")
local wibox = require("wibox")
local common = require("awful.widget.common")

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

local mywibox_left={}

local mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

local isystray = wibox.widget.systray()
isystray:set_horizontal(false)

function setup_left_panel(count)
    for s = 1, count do
        mywibox_left[s] = awful.wibox({ position = "left", screen = s, width = 40 })
        local layout = wibox.layout.align.vertical()

        mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons, nil, vert_list_update, wibox.layout.fixed.vertical())

        local top_layout = wibox.layout.fixed.vertical()
        top_layout:add(mytaglist[s])

        local bottom_layout = wibox.layout.fixed.vertical()
        if s == 1 then bottom_layout:add(isystray) end

        layout:set_top(top_layout)
        layout:set_bottom(bottom_layout)

        mywibox_left[s]:set_widget(layout)
    end
    return mywibox_left
end

