#!/bin/bash

sleep $1
if [[ -n "$2" ]]; then
    notify-send "$2"
else
    notify-send "$1 seconds have passed!"
fi
