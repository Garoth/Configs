#!/usr/bin/python
import commands
import os
import errno

home = "/Users/athorp/"
here = home + "Configs/"

class ansicolor:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

    def disable(self):
        self.HEADER = ''
        self.OKBLUE = ''
        self.OKGREEN = ''
        self.WARNING = ''
        self.FAIL = ''
        self.ENDC = ''

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
    ["jshintrc", home + ".jshintrc"],
    ["mailcap", home + ".mailcap"],
    ["muttrc", home + ".muttrc"],
    ["ncmpc", home + ".ncmpc"],
    ["ncmpcpp", home + ".ncmpcpp"],
    ["nethackrc", home + ".nethackrc"],
    ["pentagon", home + ".pentagon"],
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

everyOther = 0
for rule in rules:
    colour = ansicolor.WARNING if everyOther == 0 else ""
    end = ansicolor.ENDC
    everyOther = (everyOther + 1) % 5
    rule[0] = here + rule[0]

    if not os.path.exists(rule[1]):
        try:
            os.makedirs(os.path.dirname(rule[1]))
            print "Made directory " + os.path.dirname(rule[1])

        except OSError as exc:
            if exc.errno == errno.EEXIST and \
                    os.path.isdir(os.path.dirname(rule[1])):
                pass
            else:
                raise

        out = "Linking '" + rule[0] + "' to '" + rule[1] + "'"
        print colour + out + end
        commands.getstatusoutput("ln -s " + rule[0] + " " + rule[1])
    else:
        out1 = "Already Exists: '" + rule[1] + "'"
        out2 = "(not linking)"
        numspaces = 75 - len(out1) - len(out2)

        if numspaces >= 0:
            print colour + out1 + (" " * numspaces) + out2 + end
        else:
            print colour + out1 + " " + out2 + end
