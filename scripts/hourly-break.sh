#!/bin/bash
# Makes a libnotify popup on the hour to remind you to take a break.

SECONDS_IN_HOUR=3600

function notify {
    DISPLAY=:1
    echo "mywibox[1].bg='darkgreen'" | awesome-client
    echo "mywibox[2].bg='darkgreen'" | awesome-client
    sleep 3
    echo "mywibox[1].bg=beautiful.bg_normal" | awesome-client
    echo "mywibox[2].bg=beautiful.bg_normal" | awesome-client
}

# Initial snap to hour.
sleep $(( $SECONDS_IN_HOUR - ($(/bin/date +%s) % $SECONDS_IN_HOUR) ))
notify &

# And every hour after that.
while true; do
    sleep $SECONDS_IN_HOUR
    notify &
done
