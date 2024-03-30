#!/bin/bash
## Author: zhaoyafei0210@gmail.com

## Add alpha channel into input video, save into .webm

function show_usage {
	cmd_name=$(basename $0)
    echo "Usage: "
	echo "	${cmd_name} -h"
	echo "	${cmd_name} --help"
    echo "		Show this usage"
	echo "	${cmd_name} <video> <alpha_video>"
    echo "		<video>: path name for the first video"
    echo "		<alpha_video>: path name for the video containing alpha channel"
}

if [[ $# -lt 1 ]]; then
	show_usage
    exit
fi

input_video=$1
alpha_video=$2
basename=$(basename $1)
output_video=${basename%%.*}'-add_alpha.webm'

echo "===> The output audio will be saved into: ${output_video}"
# ffmpeg -vn -i $1 -acodec copy ${output_video}

# ffmpeg -vcodec libvpx -i $1 -vf "movie=in_alpha.mkv [alpha]; [in][alpha] alphamerge [out]" -y ${output_video}
# ffmpeg -i $input_video -vf "movie=$alpha_video [alpha]; [in][alpha] alphamerge [out]" -y -pix_fmt yuv420p -vcodec libvpx-vp9 ${output_video}

ffmpeg -y -i $input_video -i $alpha_video \
	-filter_complex "[0:v][1:v] alphamerge" \
	-pix_fmt yuv420p -vcodec libvpx-vp9 ${output_video}
