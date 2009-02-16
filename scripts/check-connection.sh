#!/bin/bash

NUMCON=$(ls /var/run | egrep "dhcpcd.*pid" | wc -l)

if [ "$NUMCON" -ge 1 ]; then
        exit 0
else
        exit 1
fi
