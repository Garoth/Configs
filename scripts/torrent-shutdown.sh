#!/bin/bash

# NOTE: this fails due to lack of period at 100%
PERCENT_DONE=$(transmission-remote -t1 -i | grep "Percent Done" | sed "s/^.* //" | sed "s/\..*//")

if [ $PERCENT_DONE -ge 100 ]; then
        sleep 300
        NOW=$(date)
        echo "Torrent done, shutting down computor at $NOW." >> SHUTDOWN.log
        sudo shutdown -hP now
fi
