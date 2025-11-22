#!/usr/bin/env bash

set -e

fzf_touch() {
    local selected=$(dirname "$1")
    read -e -p "File Name(s): " file_names
    printf '%s\n' $file_names | xargs -I{} touch "$selected/{}"
}

fzf_mkdir() {
    local selected=$(dirname "$1")
    read -e -p "Dir Name(s): " dir_names
    printf '%s\n' $dir_names | xargs -I{} mkdir -p "$selected/{}"
}

fzf_copy() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done
    echo "Copy the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "$PWD/" dest_dir

    # create basedir
    if [[ ! -d "$dest_dir" ]]; then
        echo -e "$dest_dir does not exist."
        read -e -p "Create $dest_dir Dir? (y/n): " prompt
        if [[ "$prompt" =~ ^[Yy]$ ]]; then
            mkdir -p "$dest_dir"
        else
            echo "Directory creation cancelled"
            sleep 0.3
        fi
    fi
    for item in "${selected[@]}"; do
        cp -r "$item" "$dest_dir"
    done
}

fzf_move() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done
    echo "Move the following items:"
    printf '  %s\n' "${selected[@]}"
    read -e -p "Dest dir: " -i "$PWD/" dest_dir
    mkdir -p "$dest_dir"
    mv "${selected[@]}" "$dest_dir"
}

fzf_remove() {
    local selected=()
    for arg in "$@"; do
        selected+=("$arg")
    done

    echo "The following items will be PERMANENTLY removed:"
    printf '  %s\n' "${selected[@]}"

    read -e -p "Remove all above items? (y/N): " prompt
    if [[ "$prompt" =~ ^[Yy]$ ]]; then
        rm -rf "${selected[@]}"
    else
        echo "Deletion cancelled"
        sleep 0.3
    fi
}

# export functions as fzf does not recognize functions not available on base shell
export -f fzf_touch fzf_mkdir fzf_copy fzf_move fzf_remove
