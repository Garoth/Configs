#!/bin/zsh

docker rm $(docker ps -q -f 'status=exited')
docker rmi $(docker images -q -f "dangling=true")
echo
echo "Removed Docker Garbage. Probably got you like 60GB back, nerd"
