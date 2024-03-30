#!/bin/bash
## Author: zhaoyafei0210@gmail.com

## Extract alpha channel from input webm videos, save into .mp4

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
output_video=${basename%%.*}'-alpha.mp4'

echo "===> The output audio will be saved into: ${output_video}"
ffmpeg -vn -i $1 -acodec copy ${output_video}

ffmpeg -vcodec libvpx -i $1 -vf "alphaextract" -y ${output_video}
