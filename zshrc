# Completion
autoload -Uz compinit
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"
compinit

# VCS
autoload -Uz vcs_info
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' actionformats '.%F{2}%b%F{3}.%F{1}%a%f'
zstyle ':vcs_info:*' formats '.%F{2}%b%%f'
zstyle ':vcs_info:*' enable git svn

# Auto Mime Type Running
autoload -Uz zsh-mime-setup
autoload -Uz pick-web-browser
zstyle ':mime:*' mailcap ~/.mailcap
zstyle ':mime:.txt:' flags needsterminal
zsh-mime-setup
alias -s html=pick-web-browser

# Colors
autoload colors zsh/terminfo
eval "$(dircolors -b)"
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

setopt autocd
setopt prompt_subst
unsetopt beep notify
bindkey -v # Vim mode

#Aliases
alias date='date +"~ %I:%M %p on %A, the %eth of %B ~"'
alias ls='ls --color=auto'
alias althack='telnet nethack.alt.org'
alias mgirc='ssh irssi.mercenariesguild.net'
alias uwsolaris='ssh -X aapachin@cpu10.student.cs.uwaterloo.ca'
alias uwlinux='ssh -X aapachin@mef-fe10.student.cs.uwaterloo.ca'
alias preparenote="cp $HOME/Studies/UsefulBits/underline.png ./ && echo Done"
alias crawl="crawl -dir \"$HOME/.crawl\""
alias cdplu="cd $HOME/Coding/C/plutocracy"
alias cddra="cd $HOME/Coding/C/dragoon"
alias pacman="sudo pacman-color"
alias ftp="gftp-text"
alias scons="/usr/bin/python /usr/bin/scons"
alias tram="transmission-remote"
alias top="htop"

# Variables
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
export EDITOR=/usr/bin/vim
export PROMPT='$PR_GREEN%m$PR_WHITE.$PR_BLUE%n$PR_WHITE $PR_MAGENTA%c\
$PR_WHITE${vcs_info_msg_0_}: '

# ZSH functions
precmd() {
        vcs_info
}

# Modified cd/ls functions
TODO_OPTIONS="--summary"

ls()
{
        devtodo ${TODO_OPTIONS}
        /bin/ls --color=auto "$@"
}

cd()
{
        if builtin cd "$@"; then
                devtodo ${TODO_OPTIONS}
                /bin/ls --color=auto
        fi
}

#Execute these as a terminal opens
date
devtodo ${TODO_OPTIONS}
