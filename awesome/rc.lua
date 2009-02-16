-- awesome 3 configuration file

-- Include awesome library, with lots of useful function!
require("awful")
require("beautiful")
require("naughty")

-- Settings
theme_path = "/home/garoth/.config/awesome/dark.theme"
modkey = "Mod4"
use_titlebar = false

layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating
}

floatapps = {
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["epiphany"] = true,
    ["Skype"] = true
}

apptags = {
    ["pidgin"] = { screen = 1, tag = 4 }
}

globalkeys = {}
clientkeys = {}
fading_out_clients = {}
currently_fading = false

-- Program Variables
terminal = "terminal"
music_player = "songbird"
browser = "firefox"
mail_client = browser .. " http://gmail.com"

-- {{{ Initialization
beautiful.init(theme_path)

-- Naughty Config
naughty.config.height = 32
naughty.config.icon_size = 32

-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    tags[s] = {}
    tags[s][1] = tag("   λ  ")
    tags[s][1].screen = s
    awful.layout.set(layouts[2], tags[s][1])
    tags[s][2] = tag("   β  ")
    tags[s][2].screen = s
    awful.layout.set(layouts[2], tags[s][2])
    tags[s][3] = tag("   Ω  ")
    tags[s][3].screen = s
    awful.layout.set(layouts[2], tags[s][3])
    tags[s][4] = tag("   Ϙ  ")
    tags[s][4].screen = s
    awful.layout.set(layouts[4], tags[s][4])
    tags[s][5] = tag("   Σ  ")
    tags[s][5].screen = s
    awful.layout.set(layouts[2], tags[s][5])

    tags[s][1].selected = true
end
-- }}}

-- {{{ Personal Functions
-- Root Keybinding convenience function
function bind(tab, str, fnc)
        mykey = key(tab, str, fnc)
        table.insert(globalkeys, mykey)
end

-- Client Keybinding convenience function
function bindclient(tab, str, fnc)
        mykey = key(tab, str, fnc)
        table.insert(clientkeys, mykey)
end

-- Client Fade Out + Kill
function fade_out(c)
        for i = 1, #fading_out_clients do
                if c == fading_out_clients[i] then
                        return
                end
        end

        c.opacity = 1.0
        table.insert(fading_out_clients, c)
        awful.client.focus.byidx(-1)

        if currently_fading == false then
                awful.hooks.timer.register(0.02, fade_function)
                currently_fading = true
        end
end

-- Callback function to fade a client
function fade_function()
        for i = 1, #fading_out_clients do
                local client = fading_out_clients[i]

                -- Something's buggered up, ignore.
                if client == nil then
                        return
                end

                if client.opacity > 0.1 then
                        client.opacity = client.opacity - 0.1
                else
                        table.remove(fading_out_clients, i)
                        client:kill()
                end
        end

        if #fading_out_clients == 0 then
                awful.hooks.timer.unregister(fade_function)
                currently_fading = false
        end
end

-- Minimize Client
function minimize(c)
        c.minimized = true
        display_minimized_sign()
end

-- Unminimize All (for current tag(s))
function unminimize_all()
        local curtag
        local curtags = awful.tag.selectedlist()
        local client
        local clients

        for x, curtag in pairs(curtags) do
                clients = curtag:clients()
                for y, client in pairs(clients) do
                        client.minimized = false
                end
        end

        display_minimized_sign()
end

-- Minimize All (for current tag(s))
function minimize_all()
        local curtag
        local curtags = awful.tag.selectedlist()
        local client
        local clients

        for x, curtag in pairs(curtags) do
                clients = curtag:clients()
                for y, client in pairs(clients) do
                        client.minimized = true
                end
        end

        display_minimized_sign()
end

-- Does the tag have minimized windows?
function has_minimized(tag)
        local clients = tag:clients()
        local client
        local minimized = false

        for x, client in pairs(clients) do
                if client.minimized == true then
                        minimized = true
                end
        end

        return minimized
end

-- Check whether the minimize sign needs displaying + display it
function display_minimized_sign(curtags)
        local curtags = curtags or awful.tag.selectedlist()
        local curtag
        local minimized_found = false

        for x, curtag in pairs(curtags) do
               if has_minimized(curtag) then
                       minimized_found = true
               end
       end

       if minimized_found == true then
               taginfobox.text = "(M)"
       else
               taginfobox.text = ""
       end
end
--- }}}

-- {{{ Statusbars
mysystray = widget({
        type = "systray",
        name = "mysystray",
        align = "right"
})

mypromptbox = {}

mylayoutbox = {}

mytaglist = {}
mytaglist.buttons = { 
        button({ }, 1, awful.tag.viewonly),
        button({ modkey }, 1, awful.client.movetotag),
        button({ }, 3, function (tag) tag.selected = not tag.selected end),
        button({ modkey }, 3, awful.client.toggletag)
}

-- External scripts change this
random_text = widget({
        type = "textbox",
        name = "random_text",
        align = "left"
})
random_text.text = ""

-- Padding widgets
divider_l = widget({
        type = "imagebox",
        name = "divider_l",
        align = "left"
})
divider_l.image = image(os.getenv("HOME") .. "/.config/awesome/div.png")

divider_r = widget({
        type = "imagebox",
        name = "divider_r",
        align = "right"
})
divider_r.image = image(os.getenv("HOME") .. "/.config/awesome/div.png")

-- Date box
datetextbox = widget({
        type = "textbox",
        name = "mytextbox",
        align = "right"
})
datetextbox.text = os.date("%a %b %e")

-- Has minimized windows text box
taginfobox = widget({
        type = "textbox",
        name = "taginfobox",
        align = "left"
})

statusbartop = {}
for s = 1, screen.count() do
    mypromptbox[s] = widget({
            type = "textbox",
            name = "mypromptbox" .. s,
            align = "left"
    })

    -- Create an imagebox widget which will contains an icon indicating
    -- which layout we're using.
    mylayoutbox[s] = widget({
            type = "imagebox",
            name = "mylayoutbox",
            align = "right"
    })

    mylayoutbox[s]:buttons({
            button({ }, 1, function () awful.layout.inc(layouts, 1) end),
            button({ }, 3, function () awful.layout.inc(layouts, -1) end),
            button({ }, 4, function () awful.layout.inc(layouts, 1) end),
            button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    })

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s,
            awful.widget.taglist.label.all,
            mytaglist.buttons)

    -- Create the wibox
    statusbartop[s] = wibox({ 
            position = "left",
            name = "statusbartop" .. s,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            width=22,
            border_width = 0,
            border_color = beautiful.bg_focus
    })

    -- Add widgets to the wibox - order matters
    statusbartop[s].widgets = {
            mytaglist[s],
            divider_l,
            taginfobox,
            random_text,
            mypromptbox[s],
            divider_r,
            datetextbox,
            divider_r,
            mylayoutbox[s],
            s == 1 and mysystray or nil
    }

    statusbartop[s].screen = s
end
-- }}}

-- {{{ Key bindings

keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Make automatic binds for things with number keys
for i = 1, keynumber do
    bind({ modkey }, i,
           function ()
               local screen = mouse.screen
               if tags[screen][i] then
                   awful.tag.viewonly(tags[screen][i])
               end

               display_minimized_sign()
           end)
    bind({ modkey, "Shift" }, i,
           function ()
               local screen = mouse.screen
               if tags[screen][i] then
                   tags[screen][i].selected = not tags[screen][i].selected
               end

               display_minimized_sign()
           end)
    bind({ modkey, "Control" }, i,
           function ()
               if client.focus then
                   if tags[client.focus.screen][i] then
                       awful.client.movetotag(tags[client.focus.screen][i])
                   end
               end
awful.tag.selectedlist()
               display_minimized_sign()
           end)
    bind({ modkey, "Control", "Shift" }, i,
           function ()
               if client.focus then
                   if tags[client.focus.screen][i] then
                       awful.client.toggletag(tags[client.focus.screen][i])
                   end
               end

               display_minimized_sign()
           end)
end

-- Standard program
bind({ modkey }, "Return", function () awful.util.spawn(terminal) end)
bind({ modkey, "Control" }, "r", awesome.restart)
bind({ modkey, "Control", "Shift" }, "q", awesome.quit)
bind({ modkey }, "s", function ()
                client.focus.sticky = not client.focus.sticky
        end)
bind({ modkey }, "Left", awful.tag.viewprev)
bind({ modkey }, "Right", awful.tag.viewnext)

-- Media Keys
bind({ }, "#129", function () awful.util.spawn(music_player) end)
bind({ }, "#236", function () awful.util.spawn(mail_client) end)
bind({ }, "#178", function () awful.util.spawn(browser) end)
bind({ }, "#161", function ()
        naughty.notify({text = "calculator", timeout = 7})
end)

-- Client manipulation
bindclient({ modkey, "Control" }, "space", awful.client.floating.toggle)
bindclient({ modkey }, "m", function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical = not c.maximized_vertical
        end)
bindclient({ modkey }, "i", function(c) awful.client.maximumize(c) end)
bindclient({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end)
bindclient({ modkey, "Shift" }, "m", function () minimize(client.focus) end)
bindclient({ modkey }, "c", function() fade_out(client.focus) end)
bind({ modkey, "Shift", "Control" }, "m", unminimize_all)
bind({ modkey, "Control" }, "m", minimize_all)

-- Focus by direction (vi keys)
bind({ modkey }, "j", function ()
                awful.client.focus.bydirection("down")
                client.focus:raise()
        end)
bind({ modkey }, "k", function ()
                awful.client.focus.bydirection("up")
                client.focus:raise()
        end)
bind({ modkey }, "l", function ()
                awful.client.focus.bydirection("right")
                client.focus:raise()
        end)
bind({ modkey }, "h", function ()
                awful.client.focus.bydirection("left");
                client.focus:raise()
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

-- Multiscreen Keybindings
bind({ modkey, "Control" }, "l", function () awful.screen.focus(1) end)
bind({ modkey, "Control" }, "h", function () awful.screen.focus(-1) end)
bind({ modkey }, "o", awful.client.movetoscreen)

-- Change Layouts
bind({ modkey }, "space", function () awful.layout.inc(layouts, 1) end)
bind({ modkey, "Shift" }, "space", function ()
                awful.layout.inc(layouts, -1)
        end)

-- Run Prompt
bind({ modkey }, "F1", function ()
                            awful.prompt.run({ prompt = "Run: " },
                            mypromptbox[mouse.screen],
                            awful.util.spawn, awful.completion.bash,
                            awful.util.getdir("cache") .. "/history")
                       end)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for
    -- a split second.
    client.focus = c
    
    -- Set key bindings
    c:keys(clientkeys)

    c.size_hints_honor = false
    awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Date Update Hook
awful.hooks.timer.register(3, function ()
    datetextbox.text = os.date("%a %b %e")
end)
-- }}}
