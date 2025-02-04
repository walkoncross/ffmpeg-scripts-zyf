#!/bin/bash
# author: zhaoyafei0210@gmail.com
# date: 20250204

cmd_name=$(basename $0)
show_usage() {
    echo "Rotate input video 90 degree counter-clockwise and save into h264 encoded video with .mp4 format, with film tune settings"
    echo "Usage: "
    echo "    ${cmd_name} -h"
    echo "    ${cmd_name} --help"
    echo "        Show this usage"
    echo "    ${cmd_name} <video> [<output_video>] [--fps <fps>]"
    echo "        <video>: path name for the input video"
    echo "        <output_video>: optional, path name ended with .mp4 for the output video"
    echo "        --fps <fps>: optional, frames per second, default is input video's fps"
}

if [[ $# -lt 1 || $# -gt 4 ]]; then
    show_usage
    exit
fi

input=$1
shift

output=""
fps=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --fps)
            fps=$2
            shift 2
            ;;
        *)
            if [[ -z "$output" ]]; then
                output=$1
            else
                show_usage
                exit
            fi
            shift
            ;;
    esac
done

if [[ -z "$output" ]]; then
    basename=${input##*/}
    output=${basename%%.*}.rotate90cw.mp4
fi

input_fps=$(ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate "$input" | awk -F'/' '{print $1/$2}' | bc -l)

echo "--> Input video: $input"
echo "--> Output video: $output"

echo "--> Input FPS: $input_fps"
if [[ -z "$fps" ]]; then
    echo "--> Output FPS: $input_fps"
else
    echo "--> Output FPS: $fps"
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

# Add your ffmpeg command here to rotate the video by 90 degrees counter-clockwise
if [[ -z "$fps" ]]; then
    # ffmpeg -i "$input" -vf "transpose=2" -c:v libx264 -preset slow -tune film -crf 22 -c:a copy "$output"
    ffmpeg -i "$input" -vf "transpose=2" -c:v libx264 -preset medium -c:a copy "$output"
else
    # ffmpeg -i "$input" -vf "transpose=2" -r "$fps" -c:v libx264 -preset slow -tune film -crf 22 -c:a copy "$output"
    ffmpeg -i "$input" -vf "transpose=2" -r "$fps" -c:v libx264 -preset medium -c:a copy "$output"
fi
echo 'saved into '${output}
