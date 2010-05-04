#!/bin/bash
# Remove all but latest 2 of each package (meant for /var/cache/pacman/pkg)

/bin/ls | sed "s/-.*//" | uniq | while read line; do /bin/ls | grep "${line}" | sort -n | head -n "-2" | xargs sudo rm; done
