#! /bin/sh
input=$1 # format: images/frame_%04d.png
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
    -vf "scale=iw-mod(iw\,2):ih-mod(ih\,2)" \
    -c:v libx264 \
    -pix_fmt yuv420p \
    $output
else
ffmpeg -r 25 \
    -i $input \
    -vf "scale=iw-mod(iw\,2):ih-mod(ih\,2)" \
    -c:v libx264 \
    -pix_fmt yuv420p \
    $output
fi

