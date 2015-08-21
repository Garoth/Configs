#!/bin/zsh

# Git lets you use very readable time formats!
cutoff_time="1 year ago"
# other examples:
# cutoff_time="July 23, 2010"
# cutoff_time="yesterday"

set -x
git for-each-ref refs/heads --format='%(refname)' | egrep -v 'master|other-whitelisted-branch' |
while read branch; do
    git reflog --expire="$cutoff_time" $branch
    if [ "$(git reflog show -1 $branch | wc -l)" -eq 0 ]; then
        # git branch -D ${branch#refs/heads/}
        echo ${branch#refs/heads/}
    fi
done
