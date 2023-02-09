#!/bin/bash

# Show help and exit.
function show_help () {
    echo "Flame: creates mp3 audio files from stdin."
    echo ""
    echo "https://github.com/fffilo/flame"
    echo ""

    exit 0
}

# Show error and exit with non-zero status code.
function error_log () {
    echo "flame: $1" >&2

    exit 1
}

# Check dependency.
if ! [ -x "$(command -v lame)" ]; then
    error_log "lame is not installed"
fi

# Check if pipe exists on stdin.
if [ ! -p /dev/stdin ]; then
    show_help
fi

# Read stdin line by line.
files=()
while IFS= read line; do
    if [ -z "$line" ]; then
        continue
    elif [ -d "$line" ]; then
        continue
    elif [ ! -f "$line" ]; then
        error_log "file does not exist $line"
    fi

    # Append audio file to files list.
    if [[ "$(file --mime-type -b "$line")" == audio/* ]]; then
        files+=("$line")
    fi
done

# Destination directory.
outdir=""
args=("$@")
for i in "${!args[@]}"; do
    if [ "${args[$i]}" == "--out-dir" ]; then
        outdir="${args[$((i+1))]}"
        if [ -z "$outdir" ]; then
            error_log "output directory not provided"
        elif [ ! -d "$outdir" ]; then
            error_log "output directory does not exist $outdir"
        fi

        outdir="$(realpath "$outdir")"

        break
    fi
done

# Iterate files.
for i in "${files[@]}"; do
    src="$(realpath "$i")"
    dst="${src%.*}.mp3"

    if [ "$outdir" == "/" ]; then
        dst="/$(basename "$dst")"
    elif [ ! -z "$outdir" ]; then
        dst="${outdir}/$(basename "$dst")"
    fi

    # Execute lame on file.
    lame ${@} "${src}" "${dst}"

    # Exit on fail.
    status=$?
    if [ $status -ne 0 ]; then
        exit $status
    fi
done
