#!/usr/bin/python
import commands
import os

home = "/Users/athorp/"
here = home + "Configs/"

rules = [
        ["Terminal", home + ".config/Terminal"],
        ["awesome", home + ".config/awesome"],
        ["bashrc", home + ".bashrc"],
        ["fetchmailrc", home + ".fetchmailrc"],
        ["fonts", home + ".fonts"],
        ["forward", home + ".forward"],
        ["gcextras", home + ".gcextras"],
        ["gitconfig", home + ".gitconfig"],
        ["gvimrc", home + ".gvimrc"],
        ["hg", home + ".hg"],
        ["hgrc", home + ".hgrc"],
        ["htoprc", home + ".htoprc"],
        ["mailcap", home + ".mailcap"],
        ["muttrc", home + ".muttrc"],
        ["ncmpc", home + ".ncmpc"],
        ["ncmpcpp", home + ".ncmpcpp"],
        ["nethackrc", home + ".nethackrc"],
        ["plutocracy", home + ".plutocracy"],
        ["procmailrc", home + ".procmailrc"],
        ["profile", home + ".profile"],
        ["screenrc", home + ".screenrc"],
        ["scripts", home + ".scripts"],
        ["signature-default", home + ".signature-default"],
        ["sup/hooks", home + ".sup/hooks"],
        ["vim", home + ".vim"],
        ["vimpagerrc", home + ".vimpagerrc"],
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
