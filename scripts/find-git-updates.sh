#!/bin/bash
# Usage: find-git-updates.sh /path/to/git/repo

function usage {
        echo "Tells you if there are updates to a git repo's master."
        echo "If a command is specified to run, it will be run. Otherwise,"
        echo "this will just echo. For the command, use the var \$OUTPUTSTRING"
        echo "to access the regular output string."
        echo "Note: This will git-fetch on your repo."
        echo
        echo "Usage: find-git-updates.sh /path/to/repo [\"command to run\"]"
}

if [ ! -d "$1" ]; then
        usage
        exit 1
fi

if [ "$2" = "" ]; then
        COMMAND="echo \$OUTPUTSTRING"
else
        COMMAND="$2"
fi

cd $1
FOLDERNAME=$(python -c "print '$1'.split('/')[-1]")

git fetch &> /dev/null
LOCALCOUNT=$(git log --pretty=oneline master | grep -c "")
REMOTECOUNT=$(git log --pretty=oneline origin/master | grep -c "")

if [ $LOCALCOUNT -lt $REMOTECOUNT ]; then
        COUNTDIFF=$(python -c "print $REMOTECOUNT - $LOCALCOUNT")
        if [ "$COUNTDIFF" == "1" ]; then
                OUTPUTSTRING="1 Update Available in $FOLDERNAME"
        else
                OUTPUTSTRING="$COUNTDIFF Updates Available in $FOLDERNAME"
        fi
        eval $COMMAND
fi
