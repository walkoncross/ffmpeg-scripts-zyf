#!/bin/bash
## Author: zhaoyafei0210@gmail.com

## Extract audio stream from input videos, save into .wav

function show_usage {
	cmd_name=$(basename $0)
    echo "Usage: "
	echo "	${cmd_name} -h"
	echo "	${cmd_name} --help"
    echo "		Show this usage"
	echo "	${cmd_name} <video>"
    echo "		<video>: path name for the first video"
}

if [[ $# -lt 1 ]]; then
	show_usage
    exit
fi

basename=$(basename $1)
output_audio=${basename%%.*}'.wav'

echo "===> The output audio will be saved into: ${output_audio}"
ffmpeg -hide_banner -i $1 -vn ${output_audio}
