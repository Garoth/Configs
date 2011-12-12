. ~/.zprofile
. ~/.scripts/zsh-jump

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
zstyle ':vcs_info:*' enable git svn hg

# Auto Mime Type Running
autoload -Uz zsh-mime-setup
autoload -Uz pick-web-browser
zstyle ':mime:*' mailcap ~/.mailcap
# Example: to make it not background an app
# zstyle ':mime:.txt:' flags needsterminal
zsh-mime-setup
alias -s html=pick-web-browser

# Colors
autoload -Uz colors
autoload -Uz zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

### ZSH options
# pushd options
setopt auto_pushd           # pushes visited dirs on a stack to popd
setopt pushd_silent         # pushd silently
setopt pushd_to_home        # "pushd" w/o args takes you home
# completion options
setopt auto_list            # outputs completion opts immediately on ambig
setopt list_types           # shows types of possible completion opts
setopt complete_in_word     # complete while in mid of word, and don't move cursor
setopt extended_glob        # extra zsh glob features
# history options
setopt share_history        # all zsh sessions merge history
setopt hist_ignore_dups     # don't put duplicates in history
setopt hist_reduce_blanks   # remove extra spaces hist commands
# input/output options
setopt aliases              # expand aliases
setopt clobber              # allow > and >> to clobber/create files
setopt interactive_comments # allow comments in interactive shell
# job control options
setopt no_hup               # don't kill bg jobs as terminal ends
unsetopt notify             # output status of bg'd jobs just before prompt
# prompt options
setopt prompt_subst         # allow param expansion, command subst, arith in prompt
# misc
unsetopt beep               # never beep please
setopt auto_cd              # you can cd by just typing a folder name
setopt vi                   # vim mode

#Aliases
alias -g dra="$HOME/Coding/C/dragoon"
alias -g kasuko="garoth@mediapc.thruhere.net"
alias -g mgirc="garoth@irc.o09.us"
alias -g plu="$HOME/Coding/C/plutocracy"
alias -g slog='log -b $(hg branch)'
alias -g sto="/home/storage"
alias -g uwask="aapachin@acesulfame-potassium.csclub.uwaterloo.ca"
alias -g uwcsc="aapachin@csclub.uwaterloo.ca"
alias -g uwlin="aapachin@mef-fe10.student.cs.uwaterloo.ca"
alias -g uwsol="aapachin@cpu10.student.cs.uwaterloo.ca"
alias    althack='telnet nethack.alt.org'
alias    caocrawl='ssh joshua@crawl.akrasiac.org'
alias    cscmusic="ssh aapachin@strombola"
alias    date='date +"~ %I:%M %p on %A, the %eth of %B ~"'
alias    ftp="gftp-text"
alias    music="ncmpcpp"
alias    pacman="sudo clyde"
alias    pwmd="pwd" # I typo this 90% of the time
alias    top="htop"
alias    tram="transmission-remote"
alias    tree='tree -AC'

# Variables
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
export PROMPT='$PR_GREEN%m$PR_WHITE.$PR_BLUE%n$PR_WHITE $PR_MAGENTA%c\
$PR_WHITE${vcs_info_msg_0_}: '

# ZSH HOOKS
# Needed for revision control identification
precmd_vcs() {
        vcs_info
}
# Add your function to these lists to register a hook
precmd_functions+=("precmd_vcs")
chpwd_functions+=()
zshexit_functions+=()

# Modified cd/ls functions
TODO_OPTIONS="--summary"

ls()
{
        /bin/ls -G "$@"
}

# For old find compat, automatically add searchdir of '.' if none supplied
find()
{
    if [[ ! -d "$1" && "$1" == -* ]]; then
        /usr/bin/find . $@
    else
        /usr/bin/find $@
    fi
}

#Execute these as a terminal opens
date
