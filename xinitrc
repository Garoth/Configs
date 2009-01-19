#!/bin/bash
nm-applet &
/home/garoth/.scripts/startup.sh &
/home/garoth/.scripts/check-dragoon-loop.sh &
gnome-settings-daemon &
pidgin &
/usr/local/bin/awesome
