#!/bin/bash
# makes a signature using fortune

/usr/bin/fortune -s 70% linux 30% /usr/share/fortune > $HOME/.signature-fortune
cat $HOME/.signature-default $HOME/.signature-fortune
