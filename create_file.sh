#!/usr/bin/env bash

selected_dir="$(pwd)"
#new_file_name=$(zenity --entry --title="Enter New File Name" --text="Enter the name of the new file:")
#new_file_name=$(dialog --inputbox "Enter the name of the new file:" 10 40 3>&1 1>&2 2>&3)
#read -rp "Enter File Name: " new_file_name
file_names=$(dialog --stdout --inputbox "Enter file names separated by spaces:" 0 0)

# Create files based on user input
for file_name in $file_names; do
    touch "$file_name"
done

touch "${selected_dir}/${file_name}" && reset && kill $PPID && fzfm.sh

