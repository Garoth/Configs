#!/bin/bash
# Takes an interface name, checks to see if it's up. Returns 0/1
# Usage: check-interface-up.sh interafce_name

if [ $(ifconfig | grep -c "$1") -eq 0 ]; then
        exit 1
fi
