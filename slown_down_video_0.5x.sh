#!/bin/bash
# author: zhaoyafei0210@gmail.com
# date: 20250427

function show_usage {
	cmd_name=$(basename $0)
    echo "Slow down video by 2x and save into h264 encoded video with .mp4 format"
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

if [[ $# -gt 1 ]]; then
output=$2
else
basename=${input##*/}
output=${basename%%.*}.speed_0.5x.mp4
fi

# Reference: https://trac.ffmpeg.org/wiki/Encode/H.264
# -preset:
    # ultrafast
    # superfast
    # veryfast
    # faster
    # fast
    # medium – default preset
    # slow
    # slower
    # veryslow
    # placebo – ignore this as it is not useful (see FAQ)
# -tune:
    # film – use for high quality movie content; lowers deblocking
    # animation – good for cartoons; uses higher deblocking and more reference frames
    # grain – preserves the grain structure in old, grainy film material
    # stillimage – good for slideshow-like content
    # fastdecode – allows faster decoding by disabling certain filters
    # zerolatency – good for fast encoding and low-latency streaming
    # psnr – ignore this as it is only used for codec development
    # ssim – ignore this as it is only used for codec development

# -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2"
# ffmpeg -hide_banner -i $input -vf "setpts=2.0*PTS" -pix_fmt yuv420p -vcodec libx264 -preset fast -tune film $output
# ffmpeg -hide_banner -i $input -vf "setpts=2.0*PTS" -pix_fmt yuv420p -vcodec libx264 -tune film $output
ffmpeg -hide_banner -i $input -vf "setpts=2.0*PTS" -pix_fmt yuv420p -vcodec libx264 $output

echo 'saved into '${output}
