# oolong
Requirement: `ffmpeg`

A shell script to deal with simple media file editing.

## Trim
`ool -t <start> <stop> <source>`

Rename source file to include their lengths (in hh.mm.ss).

### Example
`ool -t 0:02:12 0:21:24 movie.mkv`

Outputs a trimmed `movie.mkv` from `2:12`-`21:24`

## Duration
`ool -d <source>`

Rename source file to include their lengths (in hh.mm.ss).

### Example
`Harry Potter and the Sorcerer's Stone (Audiobook).mp3`

into:

`Harry Potter and the Sorcerer's Stone (Audiobook) [08.18.02].mp3`

## Compress
`ool -c <source>`

Compress video file to a H.265/AAC `.mp4` encoding.

## Gif
`ool -g <source>`

Convert video file to a GIF file.
