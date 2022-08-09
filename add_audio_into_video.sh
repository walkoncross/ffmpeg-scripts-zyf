#!/bin/bash
# author: zhaoyafei0210@gmail.com
# date: 20220810

## Add audio stream into input video

function show_usage {
	cmd_name=$(basename $0)
    echo "Usage: "
	echo "	${cmd_name} -h"
	echo "	${cmd_name} --help"
    echo "		Show this usage"
	echo "	${cmd_name} <video> <audio> [<output_video>]"
    echo "		<video>: path name for the input video"
    echo "		<audio>: path name for the input audio/video to extract audio streams"
    echo "		<output_video>: optional, path name ended with .mp4 for the output video"
}

echo $#

if [[ $# -lt 2 || $# -gt 4 ]]; then
	show_usage
    exit
fi

input_video=$1
input_audio=$2

if [[ $# -gt 2 ]]; then
output=$3
else
output=${input_video%%.*}_add_audio.mp4
fi

ffmpeg -hide_banner \
    -i $input_video \
    -i $input_audio \
    -vcodec copy -acodec copy \
    -map 0:v -map 1:a $output
