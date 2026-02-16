#!/usr/bin/env bash

# Sync Jellyfin backdrop images to a flat screensaver folder.

SOURCE="${1:-/mnt/data/tyrm/media/}"
DEST="${2:-/mnt/data/tyrm/screensaver/}"

mkdir -p "$DEST"

find "$SOURCE" -type f -name "backdrop*" | while read -r file; do
    # Get path relative to source, e.g. "library/68/movies/SomeMovie/backdrop.jpg"
    rel="${file#$SOURCE/}"

    # Replace / with _ to flatten, e.g. "library_68_movies_SomeMovie_backdrop.jpg"
    flat_name="${rel//\//_}"

    dest_file="$DEST/$flat_name"

    if [ ! -f "$dest_file" ]; then
        cp "$file" "$dest_file"
        echo "Copied: $flat_name"
    fi
done

echo "Done. Total backdrops: $(ls -1 "$DEST" | wc -l)"

