#!/bin/sh

for file in *; do
	if [ -f "$file" ]; then
		mv "$file" "${file%.*} [$(ffmpeg -i "$file" 2>&1 | grep Duration | awk '{print $2}' | cut -d '.' -f 1)].${file##*.}"
	fi
done
echo "Duration of all files shown"
