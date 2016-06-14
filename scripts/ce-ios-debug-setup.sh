#!/bin/bash

IOS_PATH="$HOME/Programs/ios"

./build.py deps
echo "REBUILT dependencies"

rm -Rf "$IOS_PATH/CommonEditor/js" \
    "$IOS_PATH/CommonEditor/ios-deps.txt" \
    "$IOS_PATH/CommonEditor/en-ios-min.css"
echo "DELETED old files"

cp -R "dist/ios-deps.txt" "$IOS_PATH/CommonEditor/ios-deps.txt"
echo "COPIED ios-deps.txt"

cp -R "dist/ios/en-ios-min.css" "$IOS_PATH/CommonEditor/en-ios-min.css"
echo "COPIED en-ios-min.css"

cp -R "js" "$IOS_PATH/CommonEditor/js"
echo "COPIED js folder"
