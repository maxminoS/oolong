#!/bin/sh

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
