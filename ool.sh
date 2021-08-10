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

case "$1" in
    -h|--help)
        help
        exit 0
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
    *)
        echo "oolong: unrecognized option '$1'"
        help
        exit 1
        ;;
esac
