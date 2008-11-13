#!/usr/bin/python
import commands
import os

here = "/home/garoth/Configs/"

rules = [
        ["awesome", "/home/garoth/.config/awesome"],
	["vim", "/home/garoth/.vim"],
	["vimrc", "/home/garoth/.vimrc"],
        ["gitconfig", "/home/garoth/.gitconfig"],
        ["screenrc", "/home/garoth/.screenrc"],
        ["scripts", "/home/garoth/.scripts"],
        ["zshrc", "/home/garoth/.zshrc"],
        ["bashrc", "/home/garoth/.bashrc"],
        ["fonts", "/home/garoth/.fonts"],
        ["gvimrc", "/home/garoth/.gvimrc"],
        ["plutocracy", "/home/garoth/.plutocracy"],
        ["muttrc", "/home/garoth/.muttrc"],
        ["forward", "/home/garoth/.forward"],
        ["procmail", "/home/garoth/.procmail"]
]

for rule in rules:
        rule[0] = here + rule[0]
        if not os.path.exists(rule[1]):
                print "Linking '" + rule[0] + "' to '" + rule[1] + "'"
                commands.getstatusoutput("ln -s " + rule[0] + " " + rule[1])
        else:
                print "Already Exists: '" + rule[1] + "' -- not linking."
