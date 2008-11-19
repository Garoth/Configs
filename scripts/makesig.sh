#!/bin/bash
# makes a signature using fortune

/usr/bin/fortune 65% bofh-excuses 25% linux 10% /usr/share/fortune > $HOME/.signature-fortune
cat $HOME/.signature-default $HOME/.signature-fortune
