#!/bin/bash
# author: zhaoyafei0210@gmail.com
# date: 20201114

function show_usage {
	cmd_name=$(basename $0)
    echo "Save input video into vp9 encoded video with .mp4 format, with film tune settings"
    echo "Usage: "
	echo "	${cmd_name} -h"
	echo "	${cmd_name} --help"
    echo "		Show this usage"
	echo "	${cmd_name} <video> [<output_video>]"
    echo "		<video>: path name for the input video"
    echo "		<output_video>: optional, path name ended with .mp4 for the output video"
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
	show_usage
    exit
fi

input=$1
offset=$2 # time offset in seconds, e.g. 0.1 makes audio delay for 100ms, -0.1 makes audio 

if [[ $# -gt 1 ]]; then
output=$2
else
basename=${input##*/}
output=${basename%%.*}.vp9.mp4
fi

# Reference: 
#   https://trac.ffmpeg.org/wiki/Encode/VP9
ffmpeg -hide_banner -i $input -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2"  -pix_fmt yuv420p -vcodec libvpx-vp9 $output

ffmpeg -i $input -map 0:v:0 -map 0:a -c:v prores_ks -pix_fmt yuva444p10le -profile:v 4444 -alpha_bits 8 -c:a copy $output

echo 'saved into '${output}
