#!/bin/zsh

local numlines=$(find /home/garoth/Work/gridcentric/www/src/ -iname '*.java' |
    xargs wc -l |
    tail -n1 |
    sed 's/^  *//' |
    cut -d ' ' -f 1)
echo "random_text.text =  '${numlines} lines'" | DISPLAY=:0 awesome-client
