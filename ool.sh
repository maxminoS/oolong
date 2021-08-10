#!/bin/sh

help() {
    echo "Syntax: ool [option] [...]"
    echo ''
    echo 'video options:'
    echo '  -j, --join <source> <source>'
    echo '          Join two video files together'
    echo ''
    echo '  -t, --trim <start> <stop> <source>'
    echo '          Trim file with the appropriate timestamps'
    echo ''
    echo '  -s, --subtitle <subtitle> <source>'
    echo '          Add subtitle to video'
    echo ''
    echo '  -c, --compress <source>'
    echo '          Compress video'
    echo ''
    echo 'audio options:'
    echo '  -a, --audio <source>'
    echo '          Extract audio from video'
    echo ''
    echo '  -m, --mute <source>'
    echo '          Mute video'
    echo ''
    echo 'tool options:'
    echo '  -h, --help'
    echo '          Print this help message and exit'
    echo ''
    echo '  -d, --duration <source>'
    echo '          Rename file to have duration'
    echo ''
    echo '  -g, --gif <source>'
    echo '          Convert video to GIF'
}

# Duration (HH:mm:ss)
get_duration()
{
    duration=$(ffmpeg -i "$1" 2>&1 | grep Duration | awk '{print $2}' | cut -d. -f1 | tr : .)
    fixed_hour=$(echo "$duration" | cut -d. -f1 | tail -c 3)
    fixed_minute=$(echo "$duration" | cut -d. -f2)
    fixed_second=$(echo "$duration" | cut -d. -f3)
    echo "$fixed_hour.$fixed_minute.$fixed_second"
}

# Time (HH:mm:ss) in seconds
get_sec()
{
    hour=$(echo $1 | cut -d: -f1)
    minute=$(echo $1 | cut -d: -f2)
    second=$(echo $1 | cut -d: -f3)
    echo $(((hour*60*60)+(minute*60)+second))
}

# Time difference in (HH:mm:ss)
get_diff()
{
    diff=$(($(get_sec $2)-$(get_sec $1)))
    [ $diff -lt 0 ] && diff=$((-diff))
    echo "$((diff/3600)):$((diff/60%60)):$((diff%60))"
}

case "$1" in
    -h|--help)
        help
        exit 0
        ;;
    -j|--join)
        # Join
        # ool --join <input> <input>
        tmp_file="${TMPDIR:-/tmp/}ool.$(awk 'BEGIN {srand();printf "%d\n", rand() * 10^10}')"
        echo "file '$PWD/$2'\nfile '$PWD/$3'" > tmp_file
        ffmpeg -f concat -safe 0 -i tmp_file -c copy "${2%.*}-ext.${2##*.}"
        rm tmp_file
        ;;
    -t|--trim)
        # Trim
        # ool --trim <first_timestamp> <second_timestamp> <input>
        ffmpeg -ss "$2" -i "$4" -codec copy -t "$(get_diff $2 $3)" "${4%.*}-trimmed.${4##*.}"
        ;;
    -s|--subtitle)
        # Subtitle
        # ool --subtitle <subtitle> <input>
        ffmpeg -i "$3" -i "$2" -c copy -c:s mov_text "${3%.*}-subbed.${3##*.}"
        ;;
    -c|--compress)
        # Compress
        # ool --compress <input>
        ffmpeg -i "$2" -c:v libx265 -crf 28 -c:a aac -b:a 128k -tag:v hvc1 "${2%.*}-min.mp4"
        ;;
    -a|--audio)
        # Audio
        # ool --audio <input>
        ffmpeg -i "$2" -vn -ab 256 "${2%.*}.mp3"
        ;;
    -m|--mute)
        # Mute
        # ool --mute <input>
        ffmpeg -i "$2" -an "${2%.*}-mute.${2##*.}"
        ;;
    -d|--duration)
        # Duration
        # ool --duration <input>
        if [ -f "$2" ]; then
            duration="$(get_duration $2)"
            mv "$2" "${2%.*} [$duration].${2##*.}"
            echo "Duration [$2]: $duration"
        else
            echo "'$2' is not a file"
        fi
        ;;
    -g|--gif)
        # Gif
        # ool --gif <input>
        ffmpeg -i "$2" -vf scale=500:-1 -t 10 -r 10 "${2%.*}.gif"
        ;;
    *)
        echo "oolong: unrecognized option '$1'"
        help
        exit 1
        ;;
esac
