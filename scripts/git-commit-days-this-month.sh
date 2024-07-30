#!/bin/bash

# Check if the current directory is a git repository
if [ ! -d .git ]; then
  echo "This is not a git repository."
  exit 1
fi

# Get the current year and month
repo_name=$(basename -s .git $(git config --get remote.origin.url))
current_year=$(date +"%Y")
current_month=$(date +"%m")

# Get the list of commit dates in YYYY-MM-DD format for the current month
commit_dates=$(git log --since="$current_year-$current_month-01" --until="$(date -d '+1 month' +"%Y-%m-01")" --pretty=format:%ad --date=format:%Y-%m-%d)
commit_count=$(echo "$commit_dates" | wc -l)

# Count the unique dates
unique_dates=$(echo "$commit_dates" | sort | uniq)

# Count the number of unique dates
commit_days_count=$(echo "$unique_dates" | wc -l)

# Output the number of days with commits
echo "Repo Summary for $(date +"%B")"
echo "Repo Summary for $(date +"%B")" | tr "[a-zA-Z]" "-"
echo -e "⁍ repo name: \e[32;1m$repo_name\e[0m"
echo -e "⁍ days with commits this month: \e[34;1m$commit_days_count\e[0m"
echo -e "⁍ number of commits this month: \e[34;1m$commit_count\e[0m"
