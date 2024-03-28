#! /usr/bin/env bash

selected_dir="$(pwd)"
read -rp "Enter Directory Name: " new_dir_name
#mkdir -p "${selected_dir}/${new_dir_name}" && kill $PPID && fzfm.sh
mkdir -p "${selected_dir}/${new_dir_name}"
