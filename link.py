#!/usr/bin/python
import commands
import os

home = "/home/garoth/"
here = home + "Configs/"

rules = [
        ["awesome", home + ".config/awesome"],
        ["vim", home + ".vim"],
        ["vimrc", home + ".vimrc"],
        ["gitconfig", home + ".gitconfig"],
        ["screenrc", home + ".screenrc"],
        ["scripts", home + ".scripts"],
        ["zshrc", home + ".zshrc"],
        ["zprofile", home + ".zprofile"],
        ["bashrc", home + ".bashrc"],
        ["profile", home + ".profile"],
        ["fonts", home + ".fonts"],
        ["gvimrc", home + ".gvimrc"],
        ["plutocracy", home + ".plutocracy"],
        ["mailcap", home + ".mailcap"],
        ["muttrc", home + ".muttrc"],
        ["forward", home + ".forward"],
        ["procmailrc", home + ".procmailrc"],
        ["signature-default", home + ".signature-default"],
        ["Terminal", home + ".config/Terminal"],
        ["xinitrc", home + ".xinitrc"]
]

for rule in rules:
        rule[0] = here + rule[0]
        if not os.path.exists(rule[1]):
                print "Linking '" + rule[0] + "' to '" + rule[1] + "'"
                commands.getstatusoutput("ln -s " + rule[0] + " " + rule[1])
        else:
                print "Already Exists: '" + rule[1] + "' -- not linking."
