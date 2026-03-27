#!/bin/bash

# Create a new file in the current working directory or at a specified path using fzf prompt

current_dir=$(pwd)
echo "Prompting for new file from $current_dir" >> /tmp/fzf-create-file.log
tput reset 2>/dev/null
new_file_name=$(echo | fzf --print-query --prompt "Enter File Name: " | tail -n 1)
echo "User entered: $new_file_name" >> /tmp/fzf-create-file.log

if [ -n "$new_file_name" ]; then
    # Check if input is an absolute path (starts with /) or contains a slash (relative path)
    if [[ "$new_file_name" == /* ]] || [[ "$new_file_name" == */* ]]; then
        # Use the input as the full path
        file_path="$new_file_name"
    else
        # Create in current directory
        file_path="$current_dir/$new_file_name"
    fi
    echo "Attempting to create: $file_path" >> /tmp/fzf-create-file.log
    # Create parent directories if needed
    mkdir -p "$(dirname "$file_path")" 2>>/tmp/fzf-error.log
    touch "$file_path" 2>>/tmp/fzf-error.log
    if [ $? -eq 0 ]; then
        echo "Created file $file_path" >> /tmp/fzf-create-file.log
    else
        echo "Failed to create file $file_path" >> /tmp/fzf-create-file.log
    fi
else
    echo "No file created: empty name" >> /tmp/fzf-create-file.log
fi
