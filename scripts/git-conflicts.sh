#!/bin/zsh

git status | grep "both modified" | onespace.sh | cut -d: -f 2
