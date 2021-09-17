#!/bin/zsh

if [[ "$1" == "-f" ]]; then
    docker rmi -f $(docker images -q)
elif [[ "$1" == "-p" ]]; then
    docker system prune -a
else
    docker rm $(docker ps -q -f "status=exited")
    docker rmi $(docker images -q -f "dangling=true")
fi

echo "Removed Docker Garbage. Probably got you like 60GB back, nerd"
