#!/bin/bash
# Given two files, this will output the first file minus the lines that
# also exist in the second file.

first=$1
second=$2
foundfile="/tmp/subtract-foundfile"

cat $first | while linefirst=$(line); do
        echo "0" > $foundfile
        cat $second | while linesecond=$(line); do 
                if [ "$linefirst" = "$linesecond" ]; then
                        echo "1" > $foundfile
                fi
        done

        if [ $(cat $foundfile) = "0" ]; then
                echo $linefirst
        fi
done

rm $foundfile
