#!/bin/bash
# author: zhaoyafei0210@gmail.com

if [ $# -lt 1 ]; then
  echo "Usage: $0 -a <scale_algorithm> <input> [output]"
  exit 1
fi

scale_algorithm="bicubic"

while getopts "a:" opt; do
  case $opt in
    "a")
      scale_algorithm=$OPTARG
      ;;
    *)
      echo "Invalid option: $opt"
      exit 1
      ;;
  esac
done

# 移除已处理的选项，剩下的是位置参数
shift $((OPTIND - 1))

input=$1
output=""

if [ $# -lt 2 ]; then
  output=$(echo $input | sed "s/\.[^.]*$/.720p-${scale_algorithm}.mp4/")
else
  output=$2
fi

echo "input: $input"
echo "output: $output"
echo "scale_algorithm: $scale_algorithm"

original_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0:s=x $input)
original_height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0:s=x $input)

echo "original_width: $original_width"
echo "original_height: $original_height"

if [ $original_height -gt $original_width ]; then
  output_width=720
  output_height=1280
else
  output_width=1280
  output_height=720
fi

echo "output_width: $output_width"
echo "output_height: $output_height"

ffmpeg -i $input \
    -vf "scale=$output_width:$output_height:force_original_aspect_ratio=decrease,pad=$output_width:$output_height:(ow-iw)/2:(oh-ih)/2:color=black" \
    -sws_flags $scale_algorithm \
    -c:a copy $output
