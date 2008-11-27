#!/bin/bash
# Given two files, this will output the first file minus the lines that
# also exist in the second file.

first=$1
second=$2
workfile="/tmp/subtract-modfile"

cp $first $workfile

cat $second | while myline=$(line); do
        sed -i "/$myline/d" $workfile
done

cat $workfile
rm $workfile
