#!/bin/bash
PATH=/home/garoth/.scripts:/home/garoth/Programs/bin:$PATH
setxkbmap us dvorak
xmodmap - << EOF
remove Lock = Caps_Lock
keysym Caps_Lock = Escape
EOF

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

# Launch a DBus session if one is not running.
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
        eval `dbus-launch --sh-syntax --exit-with-session`
        echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi

hourly-break.sh &
unclutter &
xcompmgr &
awesome &> /home/garoth/Info/awesome.log
