#!/usr/bin/env bash
# Sync Jellyfin backdrop images to a flat screensaver folder.

API_URL="http://asgard.local:8096"
API_KEY="646eb41ab39441298e09c79570530704"
OUTPUT_DIR="/mnt/data/tyrm/screensaver"

mkdir -p "$OUTPUT_DIR"

curl -s "$API_URL/Items?api_key=$API_KEY&Recursive=true&IncludeItemTypes=Series,Movie&Fields=BackdropImageTags" | \
  jq -r '.Items[] | select(.BackdropImageTags | length > 0) | "\(.Id) \(.BackdropImageTags | length)"' | \
  while read -r id count; do
    for i in $(seq 0 $((count - 1))); do
      filename="${id}-backdrop${i}.jpg"
      if [ -f "$OUTPUT_DIR/$filename" ]; then
        echo "Skipping $filename (already exists)"
        continue
      fi
      echo "Downloading $filename"
      curl -s "$API_URL/Items/$id/Images/Backdrop/$i" -o "$OUTPUT_DIR/$filename"
    done
  done

echo "Done. Downloaded to $OUTPUT_DIR/"

random=$(find $OUTPUT_DIR -type f | grep -v current | shuf | head -1)
cp "$random" "$OUTPUT_DIR/current.jpg"
