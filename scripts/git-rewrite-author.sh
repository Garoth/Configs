git filter-branch --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "Andrei Edell" ];
        then
                GIT_COMMITTER_NAME="Andrei Edell";
                GIT_AUTHOR_NAME="Andrei Edell";
                GIT_COMMITTER_EMAIL="andrei@nugbase.com";
                GIT_AUTHOR_EMAIL="andrei@nugbase.com";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD
