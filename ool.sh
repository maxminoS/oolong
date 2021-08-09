#!/bin/sh

for file in *; do
  if [ -f "$file" ]; then
      DURATION=$(ffmpeg -i "$file" 2>&1 | grep Duration | awk '{print $2}' | cut -d. -f1 | tr : .)
      FIXED_HOUR=$(echo "$DURATION" | cut -d. -f1 | tail -c 3)
      FIXED_MINUTE=$(echo "$DURATION" | cut -d. -f2)
      FIXED_SECOND=$(echo "$DURATION" | cut -d. -f3)
      FIXED_DURATION="$FIXED_HOUR.$FIXED_MINUTE.$FIXED_SECOND"
      mv "$file" "${file%.*} [$FIXED_DURATION].${file##*.}"
  fi
done
echo "Added file durations"
