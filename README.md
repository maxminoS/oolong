# oolong
Requirement: `ffmpeg`

A shell script to deal with simple media file editing.

## Video
### Join
`ool -j <source> <source>`

Join two video files together.

### Trim
`ool -t <start> <stop> <source>`

Rename source file to include their lengths (in hh.mm.ss).

### Subtitle
`ool -s <subtitle> <source>`

Add subtitle to video file.

### Compress
`ool -c <source>`

Compress video file to a H.265/AAC `.mp4` encoding.

## Audio
### Extract Audio
`ool -a <source>`

Extract audio from a video file.

### Mute
`ool -m <source>`

Mute audio in a video file.

## Tool
### Help
`ool -h`

Print help message.

### Duration
`ool -d <source>`

Rename source file to include their lengths (in hh.mm.ss).

#### Example
`Harry Potter and the Sorcerer's Stone (Audiobook).mp3`

into:

`Harry Potter and the Sorcerer's Stone (Audiobook) [08.18.02].mp3`

### Gif
`ool -g <source>`

Convert video file to a GIF file.
