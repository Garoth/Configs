#!/bin/zsh
source ~/.zprofile

for file in $@; do
    TMPFILE=$(mktemp -u --tmpdir="/tmp" pngcrush.XXXXX)
    echo -n "Crushing file ${file}... "
    pngcrush ${file} ${TMPFILE} > /dev/null
    echo "$(du -bh ${file} | cut -f1) ==> $(du -bh ${TMPFILE} | cut -f1)"
    mv ${TMPFILE} ${file}
done
