#!/bin/bash
setxkbmap us dvorak
xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'keysym Caps_Lock = Escape'
