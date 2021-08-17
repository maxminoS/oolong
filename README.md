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
`ool -x <source>`

Extract audio from a video file.

### Mute
`ool -m <source>`

Mute audio in a video file.

### mp3
`ool -3 <source>`

Convert audio file into `mp3`.

## Tool
### Help
`ool -h`

Print help message.

### All
Executes following `ool` command to all files in directory.
Works only with trim, subtitle, compress, extract audio, mute, duration, and GIF.

#### Usage
Trim: `ool -at <start> <stop>`

Subtitle: `ool -as <subtitle>`

Compress: `ool -ac`

Extract audio: `ool -ax`

Mute: `ool -am`

Duration: `ool -ad`

GIF `ool -ag`

### Duration
`ool -d <source>`

Rename source file to include their lengths (in hh.mm.ss).

#### Example
`Harry Potter and the Sorcerer's Stone (Audiobook).mp3`

into:

`Harry Potter and the Sorcerer's Stone (Audiobook) [08.18.02].mp3`

### GIF
`ool -g <source>`

Convert video file to a GIF file.
