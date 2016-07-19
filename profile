# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export PATH=/usr/local/bin:/home/garoth/Programs/bin:$PATH:/opt/kde/bin:/home/garoth/.scripts
# Initialization for FDK command line tools.Mon Jul 18 11:41:22 2016
FDK_EXE="/Users/athorp/bin/FDK/Tools/osx"
PATH=${PATH}:"/Users/athorp/bin/FDK/Tools/osx"
export PATH
export FDK_EXE
