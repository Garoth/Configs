#!/bin/zsh

# Some fancier options for scaling and stuff:
# ffmpeg -i inccommand2.gif -filter:v "setpts=0.2*PTS"
#        -vf scale=630:-1 incscale.gif 

ffmpeg -i $1 -pix_fmt rgb24 tmp.gif
convert -layers Optimize tmp.gif ${1%\.*}.gif
rm tmp.gif
