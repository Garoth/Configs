#!/usr/bin/python
import commands

here = "/home/garoth/Configs/"

rules = [
        ["awesome", "/home/garoth/.config/awesome"]
]

for rule in rules:
        rule[0] = here + rule[0]
        print "Linking '" + rule[0] + "' to '" + rule[1] + "'"
        commands.getstatusoutput("ln -s " + rule[0] + " " + rule[1])
