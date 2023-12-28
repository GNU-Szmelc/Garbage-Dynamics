#!/bin/bash

# Default animation rate
animation_rate=0.066 # Corresponds to approximately 30 frames per second

# Function to convert GIF to frames
convert_gif() {
    local gif_file=$1
    local base_name=$(basename "$gif_file" .gif)
    local frames_folder="${base_name}_frames"

    mkdir -p "$frames_folder"
    convert "$gif_file" -coalesce -set dispose previous "$frames_folder/frame-%05d.png"
    echo "GIF converted and saved in $frames_folder"
}

# Function to animate frames
animate() {
    local frames_folder=$1
    local frame_count=$(ls $frames_folder | wc -l)

    update_frame() {
        local frame_number=$1
        cp "$frames_folder/frame-$(printf '%05d' $frame_number).png" frame.png
    }

    while true; do
        for ((i=0; i<frame_count; i++)); do
            update_frame $i
            sleep $animation_rate
        done
    done
}

# Function to list converted GIFs
list_converted_gifs() {
    local i=1
    for folder in *_frames; do
        echo "$i) ${folder%_frames}"
        i=$((i+1))
    done
}

# Main menu
echo "Welcome to the GIF tool"
PS3='Please enter your choice: '
options=("Convert GIF" "Animate GIF" "Set Animation Rate" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Convert GIF")
            echo "Enter the path to the GIF file:"
            read gif_path
            if [[ -f $gif_path ]]; then
                convert_gif "$gif_path"
            else
                echo "File not found: $gif_path"
            fi
            ;;
        "Animate GIF")
            echo "Select a GIF to animate:"
            list_converted_gifs
            read gif_number
            folders=(*_frames)
            if [[ $gif_number -gt 0 && $gif_number -le ${#folders[@]} ]]; then
                animate "${folders[$((gif_number-1))]}"
            else
                echo "Invalid selection."
            fi
            ;;
        "Set Animation Rate")
            echo "Current rate is $animation_rate seconds per frame. Enter new rate (e.g., 0.033):"
            read new_rate
            if [[ $new_rate =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                animation_rate=$new_rate
                echo "Animation rate set to $animation_rate seconds per frame."
            else
                echo "Invalid input. Please enter a numeric value."
            fi
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
