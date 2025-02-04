#!/bin/bash
# author: zhaoyafei0210@gmail.com

function show_usage {
	cmd_name=$(basename $0)
    echo "Extract frames in the range between <start> and <end> "
    echo ""
    echo "Usage: "
	echo "	${cmd_name} -h"
	echo "	${cmd_name} --help"
    echo "		Show this usage"
	echo "	${cmd_name} <video> <start> <end>"
    echo "		<video>: path name for the video"
}

if [[ $# -lt 2 ]]; then
	show_usage
    exit
fi

input=$1

base_name=$(basename ${input})
# echo "base name: ${base_name}"

name=${base_name%%.*}
save_dir=${name}_frames

fps=`ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate ${input} | bc`

echo "input: ${input}"
echo "fps: ${fps}"
echo "save dir: ${save_dir}"

mkdir -p ${save_dir}

ffmpeg -hide_banner -i ${input} ${save_dir}/frame_%04d.jpg
