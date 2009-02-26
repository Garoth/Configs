#!/bin/bash
# Automatically downloads all the music lst.fm is willing to give us
# Usage: lastfmdl.sh http://ws.audioscrobbler.com/2.0/user/garoth/podcast.rss

if [ "$1" = "" ]; then
        RSS="http://ws.audioscrobbler.com/2.0/user/garoth/podcast.rss"
else
        RSS=$1
fi

WORKSPACE="$HOME/Library/auto-downloaded/script"
MUSIC_DESTDIR="$HOME/Library/auto-downloaded"
mkdir -p $WORKSPACE
cd $WORKSPACE

# Clean up our workspace
rm $(ls | grep "rss") &> /dev/null
rm "music.txt" &> /dev/null

# If the previously completed list isn't around, create a blank one
if [ ! -d downloaded ]; then
        touch downloaded
fi

# Get the latest podcast and figure out the new paths
wget $RSS
grep "freedownloads" podcast.rss | \
          perl -p -e "s/.*?\"//" | \
                  sed "s/\".*//" > music.txt

# Let's do it...
cat music.txt | while read line; do
        OUTPUTNAME=$(echo ${line} | sed "s/^.*\///")
        FOUND=$(grep "${line}" downloaded)
        if [ "$FOUND" != "" ]; then
                echo "Skipping: $OUTPUTNAME"
        else
                echo "Downloading: $OUTPUTNAME"
                wget -O $MUSIC_DESTDIR/$OUTPUTNAME "${line}" && \
                echo "${line}" >> downloaded
        fi
done
