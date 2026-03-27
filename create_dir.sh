#!/bin/bash

# Create a directory in the current working directory or at a specified path using fzf prompt

current_dir=$(pwd)
echo "Prompting for new directory from $current_dir" >> /tmp/fzf-create-dir.log
tput reset 2>/dev/null
new_dir_name=$(echo | fzf --print-query --prompt "Enter Directory Name: " | tail -n 1)
echo "User entered: $new_dir_name" >> /tmp/fzf-create-dir.log

if [ -n "$new_dir_name" ]; then
    # Check if input is an absolute path (starts with /) or contains a slash (relative path)
    if [[ "$new_dir_name" == /* ]] || [[ "$new_dir_name" == */* ]]; then
        # Use the input as the full path
        dir_path="$new_dir_name"
    else
        # Create in current directory
        dir_path="$current_dir/$new_dir_name"
    fi
    echo "Attempting to create: $dir_path" >> /tmp/fzf-create-dir.log
    mkdir -p "$dir_path" 2>>/tmp/fzf-error.log
    if [ $? -eq 0 ]; then
        echo "Created directory $dir_path" >> /tmp/fzf-create-dir.log
    else
        echo "Failed to create directory $dir_path" >> /tmp/fzf-create-dir.log
    fi
else
    echo "No directory created: empty name" >> /tmp/fzf-create-dir.log
fi
