#!/bin/zsh

get_artist() {
    if [ -n $1 ]; then
        eyeD3 --no-color "$1" 2>/dev/null | grep "^artist:" | cut -d":" -f2
    fi
}

for file in *; do
    local ARTIST="$( get_artist $file )"
    if [ -n "$ARTIST" ]; then
        eyeD3 --no-color \
            --artist "$ARTIST" \
            --album-artist "$ARTIST" \
            --album "$ARTIST SoundCloud" \
            --to-v1.1 \
            $file &>/dev/null
        echo "Processed $file"
    else
        echo "FAIL on $file"
    fi
done
