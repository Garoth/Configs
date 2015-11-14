#!/bin/zsh

ffmpeg -i $1 -pix_fmt rgb24 tmp.gif
convert -layers Optimize tmp.gif ${1%\.*}.gif
rm tmp.gif
