#!/bin/zsh
# Used to make a popup from shell (OSX)

osascript -e "tell app \"System Events\" to display dialog \"$1\""
