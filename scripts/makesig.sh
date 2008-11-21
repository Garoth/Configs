#!/bin/bash
# makes a signature using fortune

/usr/bin/fortune 70% bofh-excuses 20% linux 10% /usr/share/fortune > $HOME/.signature-fortune
cat $HOME/.signature-default $HOME/.signature-fortune
