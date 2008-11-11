# .bashrc

#Pimping goes here
export PS1="\[\e[0;32m\]\H\[\e[m\]\[\e[0;0m\].\[\e[m\]\[\e[0;34m\]\u\[\e[m\] in \[\e[0;36m\]\W\[\e[m\]: "
#export PS1="\e[0;31m\u@\h \W\$ \e[m " #This just makes it red.

#USER PATHS
BOODLER_SOUND_PATH=/home/garoth/Programs/boodler/boodler-snd
export BOODLER_SOUND_PATH
BOODLER_EFFECTS_PATH=/home/garoth/Programs/boodler/effects
export BOODLER_EFFECTS_PATH
export PATH=$PATH:/home/garoth/.scripts

# User specific aliases and functions
alias date='date +"~ %I:%M %p on %A, the %eth of %B ~"'
if [ "$TERM" != "dumb" ]; then
	eval "`dircolors -b`"
	alias ls='ls --color=auto'
fi
alias dance='ssh dwc.mercenariesguild.net'
alias lolcatplx='ssh d.mercenariesguild.net'
alias uwsolaris='ssh -X aapachin@cpu10.student.cs.uwaterloo.ca'
alias uwsolarissftp='sftp aapachin@cpu10.student.cs.uwaterloo.ca'
alias uwlinux='ssh -X aapachin@mef-fe10.student.cs.uwaterloo.ca'
alias uwlinuxsftp='sftp aapachin@mef-fe10.student.cs.uwaterloo.ca'
alias boodler='aoss boodler'
alias definenote='cp ~garoth/Studies/UsefulBits/underline.png ./ && echo Defined'
alias frets='/home/garoth/Programs/FretsOnFire/FretsOnFire'
alias tremulous='/home/garoth/Programs/Tremulous/tremulous.x86'
alias :q='exit'
alias :q!='echo "Ok, ok!";exit'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
#export ALSA_OUTPUT_PORTS="128:0"
#export SCUMMVM_PORT=128:0
