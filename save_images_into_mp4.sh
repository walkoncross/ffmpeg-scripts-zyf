#! /bin/sh
input=$1
output=output.mp4

if [[ $# -gt 1 ]]; then
output=$2
fi

if [[ $# -gt 2 ]]; then
audio=$2
output=$3

ffmpeg -r 25 \
    -i $input \
    -i $audio \
    -c:v libx264 \
    -pix_fmt yuv420p \
    $output
else
ffmpeg -r 25 \
    -i $input \
    -c:v libx264 \
    -pix_fmt yuv420p \
    $output
fi

