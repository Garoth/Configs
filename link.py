#!/usr/bin/python
import sys
import commands
import os
import errno

# Locations
home = "/Users/athorp/"
here = home + "Configs/"

# Some colour code helpers
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

# List of things to symlink
rules = [
    ["Terminal",           home + ".config/Terminal"   ] ,
    ["awesome",            home + ".config/awesome"    ] ,
    ["bashrc",             home + ".bashrc"            ] ,
    ["fetchmailrc",        home + ".fetchmailrc"       ] ,
    ["fonts",              home + ".fonts"             ] ,
    ["forward",            home + ".forward"           ] ,
    ["gcextras",           home + ".gcextras"          ] ,
    ["gitconfig",          home + ".gitconfig"         ] ,
    ["golorize",           home + ".golorize"          ] ,
    ["gvimrc",             home + ".gvimrc"            ] ,
    ["hg",                 home + ".hg"                ] ,
    ["hgrc",               home + ".hgrc"              ] ,
    ["htoprc",             home + ".htoprc"            ] ,
    ["jshintrc",           home + ".jshintrc"          ] ,
    ["mailcap",            home + ".mailcap"           ] ,
    ["muttrc",             home + ".muttrc"            ] ,
    ["ncmpc",              home + ".ncmpc"             ] ,
    ["ncmpcpp",            home + ".ncmpcpp"           ] ,
    ["nethackrc",          home + ".nethackrc"         ] ,
    ["pentagon",           home + ".pentagon"          ] ,
    ["plutocracy",         home + ".plutocracy"        ] ,
    ["procmailrc",         home + ".procmailrc"        ] ,
    ["profile",            home + ".profile"           ] ,
    ["screenrc",           home + ".screenrc"          ] ,
    ["scripts",            home + ".scripts"           ] ,
    ["signature-default",  home + ".signature-default" ] ,
    ["sup/hooks",          home + ".sup/hooks"         ] ,
    ["vim",                home + ".vim"               ] ,
    ["vimrc",              home + ".vimrc"             ] ,
    ["nvim",               home + ".config/nvim"       ] ,
    ["xinitrc",            home + ".xinitrc"           ] ,
    ["zprofile",           home + ".zprofile"          ] ,
    ["zshrc",              home + ".zshrc"             ]
]

# Build go scripts & append them to the rules list
for dir in os.listdir(here + "scripts_go/src"):
    if dir != "github.com":

        os.putenv("GOPATH", here + "scripts_go")
        os.chdir(here + "scripts_go")

        print("Getting dependencies for " + dir)
        result = commands.getstatusoutput("go get " + dir)
        if result[0] != 0:
            print("Could not get deps for go script: " + dir)
            print(result[1])
            sys.exit(1)

        print("Building go script: " + dir)
        result = commands.getstatusoutput("go build -o bin/" + dir + " " + dir)
        if result[0] != 0:
            print("Could not build go script: " + dir)
            print(result[1])
            sys.exit(1)

        rules.append(["scripts_go/bin/" + dir, home + ".scripts/" + dir])

# Actually does the symlinking & pretty printing
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
