#!/bin/bash
PATH=/home/garoth/.scripts:$PATH
xcompmgr &

setxkbmap us dvorak &
(
xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'keysym Caps_Lock = Escape'
) &

sudo /home/garoth/.scripts/wl-connect-home &

# These things will only start after internet is established
(
while true; do
        check-connection.sh
        if [ $? -eq 0 ]; then
                # Give connection a little while to settle
                sleep 8

                # List of programs (background them)
                skype &
                pidgin &
                /home/garoth/.scripts/check-dragoon-loop.sh &

                break
        fi
        sleep 3
done
) &

# Make sure that the user DBUS Session is online
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
        ## if not found, launch a new one
        eval `dbus-launch --sh-syntax --exit-with-session`
        echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi


/usr/local/bin/awesome &> /home/garoth/Info/awesome.log
