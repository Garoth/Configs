#!/bin/sh
# makes a signature using fortune

/usr/bin/fortune /usr/share/fortune > $HOME/.signature-fortune
cat $HOME/.signature-default $HOME/.signature-fortune
