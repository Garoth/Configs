#!/bin/bash
PATH=/home/garoth/.scripts:$PATH
xcompmgr &

setxkbmap us dvorak &
xmodmap -e 'remove Lock = Caps_Lock' &
xmodmap -e 'keysym Caps_Lock = Escape' &

sudo /home/garoth/.scripts/wl-connect-home &
/home/garoth/.scripts/check-dragoon-loop.sh &

gnome-settings-daemon &
pidgin &
/usr/local/bin/awesome &> /home/garoth/Info/awesome.log
