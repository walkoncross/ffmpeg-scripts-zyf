#!/bin/bash
# author: zhaoyafei0210@gmail.com

function show_usage {
	cmd_name=$(basename $0)
    echo "Trim input video in the range between <start> and <end> into a new video "
    echo ""
    echo "Usage: "
	echo "	${cmd_name} -h"
	echo "	${cmd_name} --help"
    echo "		Show this usage"
	echo "	${cmd_name} <video> <start_x> <start_y> <out_w> <out_h>"
    echo "		<video>: path name for the video"
    echo "		<start_x>: start_x of cropped region"
    echo "		<start_y>: start_y of cropped region"
    echo "		<out_w>: width of cropped region"
    echo "		<out_h>: height of cropped region"
}

if [[ $# -lt 2 ]]; then
    show_usage
    exit
fi

input=$1

start_x=$2
start_y=$3

out_w=$4
out_h=$5

base_name=$(basename ${input})
# echo "base name: ${base_name}"

name=${base_name%%.*}
save_name=${name}_crop_${out_w}x${out_h}_from_${start_x}_${start_y}.mp4

echo "input: ${input}"
echo "start_x: ${start_x}"
echo "start_y: ${start_y}"
echo "out_w: ${out_w}"
echo "out_h: ${out_h}"
echo "save_name: ${save_name}"

ffmpeg -hide_banner -i ${input} -vf crop=${out_w}:${out_h}:${start_x}:${start_y} ${save_name}
