#!/bin/zsh

LENGTH=${1}
typeset -a DOMAIN
DOMAIN=( 0 1 2 3 4 5 6 7 8 9 a b c d e f )

for i in {1..${LENGTH}}; do
    echo -n ${DOMAIN[${RANDOM}%${#DOMAIN} + 1]}
done
echo
