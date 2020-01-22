local awful = require("awful")
local clientkeys = require("hotkeys").client

local clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

function default_rule(beautiful)
    return {
        -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }
end

-- Floating clients.
function floating_clients(beautiful)
    return {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer"
                ,"Gvim"
                ,"Skype"
                ,"Wire"
            },

            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, properties = { floating = true }
    }
end

client_rules = {}

function client_rules.rules(beautiful)
    return {
        default_rule(beautiful),
        floating_clients(beautiful),
        -- Add titlebars to normal clients and dialogs
        --{ rule_any = {type = { "normal", "dialog" }
        --  }, properties = { titlebars_enabled = true }
        --},
        { rule_any = {type = { "dialog" }
            }, properties = { titlebars_enabled = true }
        },
        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- { rule = { class = "Firefox" },
        --   properties = { screen = 1, tag = "2" } },
        { rule = { class = "Wire" },
    properties = { tag = awful.screen.focused().tags[-1] } },
    }
end

return client_rules
