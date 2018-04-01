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
=/usr/local/bin:/home/garoth/Programs/bin:$PATH:/opt/kde/bin:/home/garoth/.scripts
# Initialization for FDK command line tools.Sun Mar 25 16:18:41 2018
FDK_EXE="/Users/lung/bin/FDK/Tools/osx"
PATH=${PATH}:"/Users/lung/bin/FDK/Tools/osx"
export PATH
export FDK_EXE
