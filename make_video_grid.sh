#!/bin/bash
# author: zhaoyafei0210@gmail.com

if [ $# -lt 7 ]; then
  echo "Usage: $0 -r <rows> -c <cols> -w <width> -h <height> -t <duration> -s <scale_algorithm> -D <root_dir> -o <output_grid.mp4> <video_list.txt> [output_grid.mp4]"
  exit 1
fi

rows=1
cols=1
width=0
height=0
duration=5
scale_algorithm="bicubic"
video_list=""

while getopts "r:c:w:h:t:s:D:o:" opt; do
  case $opt in
    "r")
      rows=$OPTARG
      ;;
    "c")
      cols=$OPTARG
      ;;
    "w")
      width=$OPTARG
      ;;
    "h")
      height=$OPTARG
      ;;
    "t")
      duration=$OPTARG
      ;;
    "D")
      root_dir=$OPTARG
      ;;
    "s")
      scale_algorithm=$OPTARG
      ;;
    "o")
      output_grid=$OPTARG
      ;;
    *)
      echo "Invalid option: $opt"
      exit 1
      ;;
  esac
done

output_grid="output_grid-${rows}x${cols}-${width}x${height}-${duration}s.mp4"

# 移除已处理的选项，剩下的是位置参数
shift $((OPTIND - 1))

if [ $# -lt 1 ]; then
  echo "Error: video list file is not specified"
  exit 1
fi

video_list=$1
if [ $# -gt 1 ]; then
  output_grid=$2
fi

echo "--> video_list: $video_list"
echo "--> output_grid: $output_grid"
echo "--> rows: $rows"
echo "--> cols: $cols"
echo "--> width: $width"
echo "--> height: $height"
echo "--> duration: $duration"
echo "--> scale_algorithm: $scale_algorithm"
echo "--> root_dir: $root_dir"

if [ -z $video_list ]; then
  echo "Error: video list file is not specified"
  exit 1
fi

# 检查视频列表文件是否存在
if [ ! -f $video_list ]; then
  echo "Error: video list file ($video_list) does not exist"
  exit 1
fi

# 检查视频列表文件中的视频是否存在
while read -r video; do
  full_video_path=$root_dir/$video
  echo "--> check full_video_path: $full_video_path"
  if [ ! -f $full_video_path ]; then
    echo "Error: video file ($full_video_path) does not exist"
    exit 1
  fi
done < $video_list

input_videos=""
video_count=0

num_videos=$(cat $video_list | wc -l)
echo "--> num_videos: $num_videos"

if [ $num_videos -lt $((rows * cols)) ]; then
  echo "Error: number of videos ($num_videos) is less than rows ($rows) * cols ($cols)"
  exit 1
else
  echo "number of videos ($num_videos) is greater than or equal to rows ($rows) * cols ($cols), will make a grid video with $rows rows and $cols cols."
fi

fps1=`ffprobe -v error \
	-select_streams v:0 \
	-show_entries stream=r_frame_rate \
	-of csv=s=x:p=0 \
	$root_dir/${video_list[0]}`

echo "---> fps of the first video (${video_list[0]}): $fps1"

# 读取视频列表文件
while read -r video; do
  input_videos="$input_videos -i $root_dir/$video"
  video_count=$((video_count + 1))
  echo "--> video_count: $video_count"
  if [ $video_count -ge $((rows * cols)) ]; then
    break
  fi
done < $video_list

echo "--> input_videos: $input_videos"

# 为每个输入视频生成缩放过滤器
scale_filters=""
xstack_inputs=""

if [ $width -gt 0 ] && [ $height -gt 0 ]; then
  for ((i=0; i<video_count; i++)); do
      scale_filters+="[$i:v]scale=w=${width}:h=${height}:flags=${scale_algorithm}:force_original_aspect_ratio=disable:force_divisible_by=2[v$i];"
      xstack_inputs+="[v$i]"
  done
fi

echo "--> scale_filters: $scale_filters"
echo "--> xstack_inputs: $xstack_inputs"

xstack_filter="${xstack_inputs}xstack=inputs=$video_count:grid=${rows}x${cols}:fill=black[stacked];"

echo "--> xstack_filter: $xstack_filter"

ffmpeg -r $fps1 $input_videos \
  -filter_complex "${scale_filters}${xstack_filter}" \
  -map "[stacked]" -c:v libx264 -crf 23 -preset medium -sws_flags $scale_algorithm -t $duration $output_grid
