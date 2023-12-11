#!/bin/bash

# Ensure a GIF file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <gif-file>"
    exit 1
fi

gif_file=$1
frames_folder="frames"

# Create frames directory if it doesn't exist
mkdir -p $frames_folder

# Extract frames from the GIF
convert "$gif_file" "$frames_folder/frame-%05d.png"

# Count the number of frames
frame_count=$(ls $frames_folder | wc -l)

# Function to update frame.png
update_frame() {
    local frame_number=$1
    cp "$frames_folder/frame-$(printf '%05d' $frame_number).png" frame.png
}

# Start the loop
while true; do
    for ((i=0; i<frame_count; i++)); do
        update_frame $i
        # Sleep for 1/30th of a second
        sleep 0.033
    done
done
