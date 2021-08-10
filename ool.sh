#!/bin/sh

help() {
    echo "Syntax: ool [option] [...]"
    echo ''
    echo 'options:'
    echo '  -h, --help'
    echo '          Print this help message and exit'
    echo ''
    echo '  -t, --trim <start> <stop> <source>'
    echo '          Trim file with the appropriate timestamps'
    echo ''
    echo '  -d, --duration <source>'
    echo '          Rename file to have duration'
    echo ''
    echo '  -c, --compress <source>'
    echo '          Compress video'
    echo ''
    echo '  -s, --subtitle <subtitle> <source>'
    echo '          Add subtitle to video'
    echo ''
    echo '  -g, --gif <source>'
    echo '          Convert video to GIF'
}

# Duration (HH:mm:ss)
get_duration()
{
    DURATION=$(ffmpeg -i "$1" 2>&1 | grep Duration | awk '{print $2}' | cut -d. -f1 | tr : .)
    FIXED_HOUR=$(echo "$DURATION" | cut -d. -f1 | tail -c 3)
    FIXED_MINUTE=$(echo "$DURATION" | cut -d. -f2)
    FIXED_SECOND=$(echo "$DURATION" | cut -d. -f3)
    echo "$FIXED_HOUR.$FIXED_MINUTE.$FIXED_SECOND"
}

# Time (HH:mm:ss) in seconds
get_sec()
{
    HOUR=$(echo $1 | cut -d: -f1)
    MINUTE=$(echo $1 | cut -d: -f2)
    SECOND=$(echo $1 | cut -d: -f3)
    echo $(((HOUR*60*60)+(MINUTE*60)+SECOND))
}

# Time difference in (HH:mm:ss)
get_diff()
{
    DIFF=$(($(get_sec $2)-$(get_sec $1)))
    [ $DIFF -lt 0 ] && DIFF=$((-DIFF))
    echo "$((DIFF/3600)):$((DIFF/60%60)):$((DIFF%60))"
}

case "$1" in
    -h|--help)
        help
        exit 0
        ;;
    -t|--trim)
        # Trim
        # ool --trim <first_timestamp> <second_timestamp> <input>
        ffmpeg -ss "$2" -i "$4" -codec copy -t "$(get_diff $2 $3)" "${4%.*}-trimmed.${4##*.}"
        ;;
    -d|--duration)
        # Duration
        # ool --duration <input>
        if [ -f "$2" ]; then
            DURATION="$(get_duration $2)"
            mv "$2" "${2%.*} [$DURATION].${2##*.}"
            echo "Duration [$2]: $DURATION"
        else
            echo "'$2' is not a file"
        fi
        ;;
    -c|--compress)
        # Compress
        # ool --compress <input>
        ffmpeg -i "$2" -c:v libx265 -crf 28 -c:a aac -b:a 128k -tag:v hvc1 "${2%.*}-min.mp4"
        ;;
    -s|--subtitle)
        # Subtitle
        # ool --subtitle <subtitle> <input>
        ffmpeg -i "$3" -i "$2" -c copy -c:s mov_text "${3%.*}-subbed.${3##*.}"
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
