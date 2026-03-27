#!/usr/bin/env bash

# Rename a single file or directory using fzf prompt

file="$1"
[ -z "$file" ] && { echo "No file provided" >> /tmp/fzf-rename.log; exit 0; }
[ -e "$file" ] || { echo "File '$file' does not exist" >> /tmp/fzf-rename.log; exit 0; }
base=$(basename "$file")
dir=$(dirname "$file")
echo "Prompting for rename of '$base' in '$dir'" >> /tmp/fzf-rename.log
new_name=$(echo "$base" | fzf --print-query --prompt "Rename '$base' to: " | tail -n 1)
if [ -n "$new_name" ] && [ "$new_name" != "$base" ]; then
    mv -n "$file" "$dir/$new_name" 2>>/tmp/fzf-error.log
    [ $? -eq 0 ] && echo "Renamed '$base' to '$new_name'" >> /tmp/fzf-rename.log || echo "Rename failed for '$base'" >> /tmp/fzf-rename.log
else
    echo "No rename: empty or same name '$new_name'" >> /tmp/fzf-rename.log
fi
