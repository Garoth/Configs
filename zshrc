. ~/.zprofile
. ~/.gcextras

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
# Example: to make it not background an app
# zstyle ':mime:.txt:' flags needsterminal
zsh-mime-setup
alias -s html=pick-web-browser

# Colors
autoload -Uz colors
autoload -Uz zsh/terminfo
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

### ZSH options
# pushd options
setopt auto_pushd # pushes visited dirs on a stack to popd
setopt pushd_silent # pushd silently
setopt pushd_to_home # "pushd" w/o args takes you home
# completion options
setopt auto_list # outputs completion opts immediately on ambig
setopt list_types # shows types of possible completion opts
setopt complete_in_word # complete while in mid of word, and don't move cursor
setopt extended_glob # extra zsh glob features
# history options
setopt share_history # all zsh sessions merge history
setopt hist_ignore_dups # don't put duplicates in history
setopt hist_reduce_blanks # remove extra spaces hist commands
# input/output options
setopt aliases # expand aliases
setopt clobber # allow > and >> to clobber/create files
setopt interactive_comments # allow comments in interactive shell
# job control options
setopt no_hup # don't kill bg jobs as terminal ends
unsetopt notify # output status of bg'd jobs just before prompt
# prompt options
setopt prompt_subst # allow param expansion, command subst, arith in prompt
# misc
unsetopt beep # never beep please
setopt auto_cd # you can cd by just typing a folder name
setopt vi # vim mode

#Aliases
alias date='date +"~ %I:%M %p on %A, the %eth of %B ~"'
alias ls='ls --color=auto'
alias althack='telnet nethack.alt.org'
alias -g mgirc="garoth@irc.o09.us"
alias -g uwsol="aapachin@cpu10.student.cs.uwaterloo.ca"
alias -g uwlin="aapachin@mef-fe10.student.cs.uwaterloo.ca"
alias -g uwcsc="aapachin@csclub.uwaterloo.ca"
alias -g uwask="aapachin@acesulfame-potassium.csclub.uwaterloo.ca"
alias preparenote="cp $HOME/Studies/UsefulBits/underline.png ./ && echo Done"
alias crawl="crawl -dir \"$HOME/.crawl\""
alias -g plu="$HOME/Coding/C/plutocracy"
alias -g dra="$HOME/Coding/C/dragoon"
alias -g sto="/home/storage"
alias pacman="sudo pacman-color"
alias ftp="gftp-text"
alias tram="transmission-remote"
alias top="htop"
alias music="ncmpcpp"

# Variables
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
export EDITOR=/usr/bin/vim
export PROMPT='$PR_GREEN%m$PR_WHITE.$PR_BLUE%n$PR_WHITE $PR_MAGENTA%c\
$PR_WHITE${vcs_info_msg_0_}: '
export _JAVA_AWT_WM_NONREPARENTING=1

# ZSH functions
precmd() {
        # Needed for revision control identification
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

# Devin's extract
xtr () {
    local ARCHIVE
    local archive
    local unrecognized
    local success
    for ARCHIVE in "$@"; do
        echo -n Extracting "$ARCHIVE"... ''
        archive=`echo "$ARCHIVE"|tr A-Z a-z`
        unrecognized=0
        success=0
        case "$archive" in
            *.tar)
                tar xf "$ARCHIVE" && success=1
                ;;
            *.tar.gz|*.tgz)
                tar xzf "$ARCHIVE" && success=1
                ;;
            *.tar.bz2|*.tbz2)
                tar xjf "$ARCHIVE" && success=1
                ;;
            *.gz)
                gunzip "$ARCHIVE" && success=1
                ;;
            *.bz2)
                bunzip2 "$ARCHIVE" && success=1
                ;;
            *.zip|*.jar|*.pk3|*.pk4)
                unzip -o -qq "$ARCHIVE" && success=1
                ;;
            *.rar)
                unrar e -y -idp -inul "$ARCHIVE" && success=1
                ;;
            *)
                unrecognized=1
                ;;
        esac
        if [ $unrecognized = 1 ]; then
            echo -e '[\e[31;1munrecognized file format\e[0m]'
        elif [ $success = 1 ]; then
            echo -e '[\e[32;1mOK\e[0m]'
        fi
    done
}

#Execute these as a terminal opens
date
devtodo ${TODO_OPTIONS}
