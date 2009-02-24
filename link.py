#!/usr/bin/python
import commands
import os

home = "/home/garoth/"
here = home + "Configs/"

rules = [
        ["Terminal", home + ".config/Terminal"],
        ["awesome", home + ".config/awesome"],
        ["bashrc", home + ".bashrc"],
        ["fonts", home + ".fonts"],
        ["forward", home + ".forward"],
        ["gitconfig", home + ".gitconfig"],
        ["gvimrc", home + ".gvimrc"],
        ["htoprc", home + ".htoprc"],
        ["mailcap", home + ".mailcap"],
        ["muttrc", home + ".muttrc"],
        ["ncmpc", home + ".ncmpc"],
        ["ncmpcpp", home + ".ncmpcpp"],
        ["plutocracy", home + ".plutocracy"],
        ["procmailrc", home + ".procmailrc"],
        ["profile", home + ".profile"],
        ["screenrc", home + ".screenrc"],
        ["scripts", home + ".scripts"],
        ["signature-default", home + ".signature-default"],
        ["vim", home + ".vim"],
        ["vimrc", home + ".vimrc"],
        ["xinitrc", home + ".xinitrc"],
        ["zprofile", home + ".zprofile"],
        ["zshrc", home + ".zshrc"]
]

for rule in rules:
        rule[0] = here + rule[0]
        if not os.path.exists(rule[1]):
                print "Linking '" + rule[0] + "' to '" + rule[1] + "'"
                commands.getstatusoutput("ln -s " + rule[0] + " " + rule[1])
        else:
                print "Already Exists: '" + rule[1] + "' -- not linking."
