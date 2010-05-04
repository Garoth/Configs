-- awesome 3 configuration file
require("awful")
require("awful.rules")
require("awful.autofocus")
require("beautiful")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/dark.theme.lua")
require("naughty")
require("obvious.popup_run_prompt")
require("obvious.clock")
require("obvious.basic_mpd")
require("obvious.keymap_switch")
require("obvious.wlan")
require("obvious.battery")

-- {{{ Settings
terminal = "terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

layouts = {
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.magnifier
}

globalkeys = {}
clientkeys = {}
-- }}}

-- {{{ Obvious Configuration
-- Run Prompt Config
obvious.popup_run_prompt.set_opacity(0.7)
obvious.popup_run_prompt.set_slide(true)

-- Clock Config
obvious.clock.set_editor(terminal .. " -x vim")
obvious.clock.set_shortformat("%a %b %d")
obvious.clock.set_longformat("%T %a %b %d %Y")

-- Basic MPD Config
obvious.basic_mpd.set_format("$title - $artist - $album")

-- Keymap Switcher
obvious.keymap_switch.set_layouts({ "us", "us(dvorak)" })
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({"   λ  ", "   β  ", "   Ω  ", "   Ϙ  ", "   Σ  " },
        s, layouts[2])
end
-- }}}

-- {{{ Personal Functions
-- Root Keybinding convenience function
function bind(tab, str, fnc)
    mykey = awful.key(tab, str, fnc)
    globalkeys = awful.util.table.join(globalkeys, mykey)
end

-- Client Keybinding convenience function
function bindclient(tab, str, fnc)
    mykey = awful.key(tab, str, fnc)
    clientkeys = awful.util.table.join(clientkeys, mykey)
end
-- }}}

-- {{{ Wibox
-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mylayoutbox = {}
mytaglist = {}
random_text = widget({ type = "textbox" })
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width=250 })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)

divider = widget({
    type = "imagebox",
    align = "left"
})
divider.image = image(os.getenv("HOME") .. "/.config/awesome/div.png")

for s = 1, screen.count() do
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
       awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
       awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
       awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
       awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all,
        mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
        return awful.widget.tasklist.label.currenttags(c, s)
    end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    mywibox[s].height = 18
    mywibox[s].opacity = 0.7
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            obvious.basic_mpd(),
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mysystray or nil,
        mylayoutbox[s],
        divider,
        obvious.clock(),
        divider,
        obvious.battery(),
        divider,
        obvious.wlan():set_type("textbox"):set_layout(awful.widget.layout.horizontal.rightleft),
        divider,
        obvious.keymap_switch(),
        divider,
        random_text,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Key bindings
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Make automatic binds for things with number keys
for i = 1, keynumber do
    bind({ modkey }, i, function ()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
        end
    end)
    bind({ modkey, "Shift" }, i, function ()
        local screen = mouse.screen
        if tags[screen][i] then
            tags[screen][i].selected = not tags[screen][i].selected
        end
    end)
    bind({ modkey, "Control" }, i, function ()
        if client.focus then
            if tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end
        awful.tag.selectedlist()
    end)
    bind({ modkey, "Control", "Shift" }, i, function ()
        if client.focus then
            if tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end
    end)
end

-- Standard program
bind({ modkey }, "Return", function () awful.util.spawn(terminal) end)
bind({ modkey, "Control" }, "r", awesome.restart)
bind({ modkey, "Control", "Shift" }, "q", awesome.quit)

-- Client manipulation
bindclient({ modkey, "Control" }, "space", awful.client.floating.toggle)
bindclient({ modkey }, "m", function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical = not c.maximized_vertical
end)
bindclient({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end)
bindclient({ modkey, "Shift" }, "m", function () minimize(client.focus) end)
bindclient({ modkey }, "c", function() fade_out(client.focus) end)
bindclient({ modkey, "Shift"}, "c", function (c) c:kill() end)
bind({ modkey, "Shift", "Control" }, "m", unminimize_all)
bind({ modkey, "Control" }, "m", minimize_all)

-- Focus by direction (vi keys)
bind({ modkey }, "j", function ()
    awful.client.focus.bydirection("down")
    if client.focus then client.focus:raise() end
end)
bind({ modkey }, "k", function ()
    awful.client.focus.bydirection("up")
    if client.focus then client.focus:raise() end
end)
bind({ modkey }, "l", function ()
    awful.client.focus.bydirection("right")
    if client.focus then client.focus:raise() end
end)
bind({ modkey }, "h", function ()
    awful.client.focus.bydirection("left");
    if client.focus then client.focus:raise() end
end)

-- Swap by direction (vi keys)
bind({ modkey, "Shift" }, "j", function ()
    awful.client.swap.bydirection("down")
end)
bind({ modkey, "Shift" }, "k", function ()
    awful.client.swap.bydirection("up")
end)
bind({ modkey, "Shift" }, "l", function ()
    awful.client.swap.bydirection("right")
end)
bind({ modkey, "Shift" }, "h", function ()
    awful.client.swap.bydirection("left")
end)

-- Column Manipulation
bind({ modkey, "Shift"}, "g", function () awful.tag.incncol(1) end)
bind({ modkey, "Shift"}, "f", function () awful.tag.incncol(-1) end)
bind({ modkey, "Control"}, "g", function () awful.tag.incnmaster(1) end)
bind({ modkey, "Control"}, "f", function () awful.tag.incnmaster(-1) end)

-- Multiscreen Keybindings
bind({ modkey, "Control" }, "l", function ()
    awful.screen.focus_relative(1)
end)
bind({ modkey, "Control" }, "h", function ()
    awful.screen.focus_relative(-1)
end)
bind({ modkey }, "o", awful.client.movetoscreen)

-- Change Layouts
bind({ modkey, "Shift" }, "space", function ()
    awful.layout.inc(layouts, -1)
end)
bind({ modkey }, "space", function () awful.layout.inc(layouts, 1) end)

-- Plugins
bind({ modkey }, "p", function ()
    obvious.basic_mpd.connection:toggle_play()
end)
bind({ modkey, "Shift" }, "=", function ()
    obvious.basic_mpd.connection:volume_up(5)
end)
bind({ modkey }, "-", function ()
    obvious.basic_mpd.connection:volume_down(5)
end)
bind({ modkey, "Shift" }, ",", function ()
    obvious.basic_mpd.connection:previous()
    obvious.basic_mpd.update()
end)
bind({ modkey, "Shift" }, ".", function ()
    obvious.basic_mpd.connection:next()
    obvious.basic_mpd.update()
end)
bind({ modkey }, "F1", obvious.popup_run_prompt.run_prompt)

-- Set keys
root.keys(globalkeys)
-- }}}

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { }, properties = { border_width = beautiful.border_width,
                                 border_color = beautiful.border_normal,
                                 focus = true,
                                 keys = clientkeys,
                                 buttons = clientbuttons } },
    { rule = { class = "MPlayer" }, properties = { floating = true } },
    { rule = { class = "Pidgin" }, properties = { tag = tags[#tags][4] } },
    { rule = { class = "gimp" }, properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- awful.titlebar.add(c, { modkey = modkey })
    c.size_hints_honor = false

    if not startup then
        if not c.size_hints.user_position and
           not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.add_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}
