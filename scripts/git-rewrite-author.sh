git filter-branch --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "Andrei Thorp" ];
        then
                GIT_COMMITTER_NAME="Andrei Thorp";
                GIT_AUTHOR_NAME="Andrei Thorp";
                GIT_COMMITTER_EMAIL="garoth@gmail.com";
                GIT_AUTHOR_EMAIL="garoth@gmail.com";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD
