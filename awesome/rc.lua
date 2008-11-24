-- awesome 3 configuration file

-- Include awesome library, with lots of useful function!
require("awful")
require("beautiful")
require("invaders")
require("naughty")

-- Settings
theme_path = "/home/garoth/.config/awesome/dark.theme"
modkey = "Mod4"
use_titlebar = false
layouts = {
    "tile",
    "fairv",
    "fairh",
    "max",
    "dwindle",
    "floating"
}
floatapps = {
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["pidgin"] = true,
    ["epiphany"] = true,
    ["Skype"] = true,
    ["empathy"] = true
}
apptags = {
    ["Firefox"] = { screen = 1, tag = 2 },
    ["pidgin"] = { screen = 1, tag = 4 }
}

-- Program Variables
terminal = "sakura"
music_player = terminal .. " -e /home/garoth/.scripts/start-cmus.sh"
browser = "firefox"
mail_client = browser .. " http://gmail.com"

-- Naughty Config
naughty.config.height = 32
naughty.config.icon_size = 32

-- {{{ Initialization
beautiful.init(theme_path)
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    tags[s] = {}
    tags[s][1] = tag({ name = " Terms", layout = "fairv" })
    tags[s][1].screen = s
    tags[s][2] = tag({ name = " Browse", layout = "fairv" })
    tags[s][2].screen = s
    tags[s][3] = tag({ name = " Mail", layout = "fairv" })
    tags[s][3].screen = s
    tags[s][4] = tag({ name = " Chat", layout = layouts[6] })
    tags[s][4].screen = s
    tags[s][5] = tag({ name = " Spare", layout = "fairv" })
    tags[s][5].screen = s
    tags[s][1].selected = true
end
-- }}}

-- {{{ Statusbars
-- {{ Top statusbar
-- Create a laucher widget
mylauncher = awful.widget.launcher({ name = "mylauncher",
                                     image = beautiful.awesome_icon,
                                     command = terminal .. " -e man awesome"})

-- Create a systray
mysystray = widget({ type = "systray", name = "mysystray", align = "right" })


-- Create a wibox for each screen and add it
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
mytasklist = {}
mytasklist.buttons = { button({ }, 1, function (c) client.focus = c; c:raise() end),
                       button({ }, 4, function () awful.client.focus.byidx(1) end),
                       button({ }, 5, function () awful.client.focus.byidx(-1) end) }
-- Date box
datetextbox = widget({ type = "textbox", name = "mytextbox", align = "right" })
file = io.popen("date +\"%I:%M %p on %A %B %e \"") 
datetextbox.text = " " .. file:read()
file:close()
-- }}
-- {{ Bottom statusbar
-- Left padding
padding_left = widget({ type = "textbox", name = "left-padding",
                        align = "left" })
padding_left.text = " "
-- Right padding
padding_right = widget({ type = "textbox", name = "right-padding",
                        align = "right" })
padding_right.text = " "
-- }}

statusbartop = {}
statusbarbottom = {}
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = widget({ type = "textbox", name = "mypromptbox" .. s, align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", name = "mylayoutbox", align = "right" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    statusbartop[s] = wibox({ position = "left", name = "statusbartop" .. s,
                             fg = beautiful.fg_normal, bg = beautiful.bg_normal,
                             width=22, border_width = 1, border_color = beautiful.bg_focus})
    -- Add widgets to the wibox - order matters
    statusbartop[s].widgets = { mytaglist[s],
                           padding_left,
                           mypromptbox[s],
                           mytasklist[s],
                           padding_right,
                           datetextbox,
                           mylayoutbox[s],
                           s == 1 and mysystray or nil }

    statusbartop[s].screen = s
end
-- }}}

-- {{{ Key bindings
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = 
                                                    not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Control" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(
                                                  tags[client.focus.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(
                                                  tags[client.focus.screen][i])
                           end
                       end
                   end):add()
end

-- Standard program
keybinding({ modkey }, "Return", function () awful.util.spawn(terminal) end):add()
keybinding({ modkey, "Control" }, "r", awesome.restart):add()
keybinding({ modkey, "Control", "Shift" }, "q", awesome.quit):add()
keybinding({ modkey }, "i", function () invaders.run() end):add()
keybinding({ modkey }, "s", function () client.focus.sticky = true end):add()
keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()

-- Media Keys
keybinding({ }, "#129", function () awful.util.spawn(music_player) end):add()
keybinding({ }, "#236", function () awful.util.spawn(mail_client) end):add()
keybinding({ }, "#178", function () awful.util.spawn(browser) end):add()
keybinding({ }, "#161", function () naughty.notify({text = "calculator", timeout = 7}) end):add()

keybinding({ }, "#162", function () naughty.notify({text = "pause/play", timeout = 7}) end):add()
keybinding({ }, "#174", function () naughty.notify({text = "volume down", timeout = 7}) end):add()
keybinding({ }, "#176", function () naughty.notify({text = "volume up", timeout = 7}) end):add()
keybinding({ }, "#160", function () naughty.notify({text = "mute volume", timeout = 7}) end):add()

-- Client manipulation
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey, "Shift" }, "m", function () client.focus.minimize=true end):add()
keybinding({ modkey }, "c", function () client.focus:kill() end):add()

-- Focus by direction (vi keys)
keybinding({ modkey }, "j", function () awful.client.focus.bydirection("down");
                                        client.focus:raise() end):add()
keybinding({ modkey }, "k", function () awful.client.focus.bydirection("up");
                                        client.focus:raise() end):add()
keybinding({ modkey }, "l", function () awful.client.focus.bydirection("right");
                                        client.focus:raise() end):add()
keybinding({ modkey }, "h", function () awful.client.focus.bydirection("left");
                                        client.focus:raise() end):add()
-- Swap by direction (vi keys)
keybinding({ modkey, "Shift" }, "j", function ()
                                awful.client.swap.bydirection("down") end):add()
keybinding({ modkey, "Shift" }, "k", function ()
                                awful.client.swap.bydirection("up") end):add()
keybinding({ modkey, "Shift" }, "l", function ()
                                awful.client.swap.bydirection("right") end):add()
keybinding({ modkey, "Shift" }, "h", function ()
                                awful.client.swap.bydirection("left") end):add()

-- Multiscreen Keybindings
keybinding({ modkey, "Control" }, "l", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.screen.focus(-1) end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()

-- Change Layouts
keybinding({ modkey }, "space", function ()
                                        awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function ()
                                       awful.layout.inc(layouts, -1) end):add()

-- Run Prompt
keybinding({ modkey }, "F1", function ()
             awful.prompt.run({ prompt = "Run: " }, mypromptbox[mouse.screen],
             awful.util.spawn, awful.completion.bash,
             os.getenv("HOME") .. "/.cache/awesome/history")
         end):add()

-- Show client information
keybinding({ modkey, "Ctrl" }, "i", function ()
    if mypromptbox.text then
        mypromptbox.text = nil
    else
        mypromptbox.text = nil
        if client.focus.class then
            mypromptbox.text = "Class: " .. client.focus.class .. " "
        end
        if client.focus.instance then
            mypromptbox.text = mypromptbox.text .. "Instance: "..
                               client.focus.instance .. " "
        end
    end
end):add()
-- }}}

-- {{{ General Functions
function replace (str)
    if str then
    end
end
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
awful.hooks.manage.register(function (c)
    c.opacity = 50
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey, "Shift" }, 1, function(c) c.minimize=true end),
        button({ modkey }, 1, function (c) c:mouse_move() end),
        button({ modkey }, 3, function (c) c:mouse_resize() end)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
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

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows,
    -- set this to false.
    c.honorsizehints = false
    c.name = " " .. c.name;
    awful.placement.no_overlap(c)
    awful.placement.no_offscreen(c)
end)

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.get(screen)
    if layout then
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

-- Hook called every so often
awful.hooks.timer.register(3, function ()
    file = io.popen("date +\"%I:%M %p on %A %B %e \"")
    if file == nil then
    else 
        text = file:read()
        if text == nil then
            text = "ERROR"
        end
        datetextbox.text = " " .. text
        file:close()
    end
end)
-- }}}
