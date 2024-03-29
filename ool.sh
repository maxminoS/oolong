#!/bin/sh

help() {
    echo "Syntax: ool [--all] [option] [...]"
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
    echo '  -x, --extract-audio <source>'
    echo '          Extract audio from video'
    echo ''
    echo '  -m, --mute <source>'
    echo '          Mute video'
    echo ''
    echo '  -3, --mp3 <source>'
    echo '          Convert audio to mp3'
    echo ''
    echo 'tool options:'
    echo '  -h, --help'
    echo '          Print this help message and exit'
    echo ''
    echo '  -a, --all'
    echo '          Apply following ool command to all files in directory'
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

case "$1" in
    -h|--help)
        help
        exit 0
        ;;
    --all)
        shift
        for i in *; do ool "$@" "$i"; done
        ;;
    -at|-as)
        flag="-$(echo "$1" | tail -c 2)"
        shift
        for i in *; do ool "$flag" "$@" "$i"; done
        ;;
    -ac|-ax|-a3|-am|-ad|-ag)
        for i in *; do ool "-$(echo "$1" | tail -c 2)" "$i"; done
        ;;
    -j|--join)
        tmp_file="${TMPDIR:-/tmp/}ool.$(awk 'BEGIN {srand();printf "%d\n", rand() * 10^10}')"
        echo "file '$PWD/$2'\nfile '$PWD/$3'" > "$tmp_file"
        ffmpeg -f concat -safe 0 -i tmp_file -c copy "${2%.*}-ext.${2##*.}"
        rm "$tmp_file"
        touch -r "$2" "${2%.*}-ext.${2##*.}"
        ;;
    -t|--trim)
        ffmpeg -ss "$2" -to "$3" -i "$4" -codec copy "${4%.*}-trimmed.${4##*.}"
        touch -r "$4" "${4%.*}-trimmed.${4##*.}"
        ;;
    -s|--subtitle)
        ffmpeg -i "$3" -i "$2" -c copy -c:s mov_text "${3%.*}-subbed.${3##*.}"
        touch -r "$3" "${3%.*}-subbed.${3##*.}"
        ;;
    -c|--compress)
        ffmpeg -i "$2" -c:v libx265 -crf 28 -c:a aac -b:a 128k -tag:v hvc1 "${2%.*}-min.mp4"
        touch -r "$2" "${2%.*}-min.mp4"
        ;;
    -x|--extract-audio)
        ffmpeg -i "$2" -vn -ab 256 "${2%.*}.mp3"
        touch -r "$2" "${2%.*}.mp3"
        ;;
    -3|--mp3)
        ffmpeg -i "$2" -vn -ar 44100 -ac 2 -b:a 192k "${2%.*}.mp3"
        touch -r "$2" "${2%.*}.mp3"
        ;;
    -m|--mute)
        ffmpeg -i "$2" -an "${2%.*}-mute.${2##*.}"
        touch -r "$2" "${2%.*}-mute.${2##*.}"
        ;;
    -d|--duration)
        if [ -f "$2" ]; then
            duration="$(get_duration "$2")"
            mv "$2" "${2%.*} [$duration].${2##*.}"
            echo "Duration [$2]: $duration"
        else
            echo "'$2' is not a file"
        fi
        ;;
    -g|--gif)
        ffmpeg -i "$2" -vf scale=500:-1 -t 10 -r 10 "${2%.*}.gif"
        ;;
    *)
        echo "oolong: unrecognized option '$1'"
        help
        exit 1
        ;;
esac
