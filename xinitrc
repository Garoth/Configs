#!/bin/bash
PATH=/home/garoth/.scripts:$PATH
xcompmgr &

setxkbmap us dvorak &
(
xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'keysym Caps_Lock = Escape'
) &

sudo /home/garoth/.scripts/wl-connect-home &
/home/garoth/.scripts/check-dragoon-loop.sh &

# These things will only start after internet is established
(
while true; do
        check-connection.sh
        if [ $? -eq 0 ]; then
                # Give connection a little while to settle
                sleep 8

                # List of programs (background them)
                pidgin &

                break
        fi
        sleep 3
done
) &

/usr/local/bin/awesome &> /home/garoth/Info/awesome.log
