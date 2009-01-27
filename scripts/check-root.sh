#!/bin/bash
# Returns 0/1 for whether this script is being run by root.

if [ $(whoami) != "root" ]; then
        exit 1
fi

