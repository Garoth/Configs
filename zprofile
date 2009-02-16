export PATH=/usr/local/bin:/home/garoth/Programs/bin:$PATH:/opt/kde/bin:/home/garoth/.scripts

if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/vc/1 ]]; then
  startx
fi
