#!/usr/bin/env bash

# Created By: Jake@Linux
# Created On: Fri 21 Mar 2025 07:12:27 AM CDT
# Project: Fuzzy File manager

mkdir /tmp/copied

imgview() {
    local file="$1"
    [[ -f "$file" ]] || return
    kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@20x1 "$file"
}

vidview() {
    local file="$1"
    [[ -f "$file" ]] || return
    
    local cache_dir="/tmp/fzf_video_cache"
    mkdir -p "$cache_dir"
    
    local file_hash=$(echo "$file" | md5sum | cut -d' ' -f1)
    local thumb="$cache_dir/${file_hash}.jpg"
    
    if [[ ! -f "$thumb" ]]; then
        timeout 5 ffmpeg -i "$file" -ss 00:00:01 -vframes 1 "$thumb" -y 2>/dev/null
    fi
    
    # Show text info at top
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📹 Video: $(basename "$file")"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if command -v ffprobe >/dev/null; then
        ffprobe -v error -show_entries \
            format=duration,size:stream=codec_name,width,height,r_frame_rate \
            -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null | \
            awk 'NR==1{w=$1} NR==2{h=$1} NR==3{fps=$1} NR==4{codec=$1} 
                 NR==5{dur=$1; printf "Resolution: %dx%d\nCodec: %s\nFPS: %s\nDuration: %.0fs\n", w, h, codec, fps, dur}'
    fi
    
    echo ""
    echo "💡 Press 'alt+s' to play in fullscreen"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Display thumbnail below text (starting at row 10)
    if [[ -f "$thumb" ]]; then
        # Use remaining space for image
        local img_height=$((FZF_PREVIEW_LINES - 12))
        kitten icat --clear --transfer-mode=memory --stdin=no \
            --place=${FZF_PREVIEW_COLUMNS}x${img_height}@0x10 "$thumb"
    fi
}

fileview() {
    local file="$1"
    [[ -f "$file" ]] || return
    bat --style=numbers --theme=ansi --color=always "$file"
}

copy_files() {
    echo "$@" | tr ' ' '\n' | xargs -I {} sh -c '
    base=$(basename "{}")
    dest="/tmp/copied/${base}.copy"
    counter=1
    while [ -e "$dest" ]; do
        dest="/tmp/copied/${base}.copy${counter}"
        counter=$((counter + 1))
    done
    cp -R "{}" "$dest" 2>/dev/null
    '
}

move_files() {
    echo "$@" | tr ' ' '\n' | xargs -I {} sh -c '
    base=$(basename "{}")
    dest="/tmp/copied/${base}.copy"
    counter=1
    while [ -e "$dest" ]; do
        dest="/tmp/copied/${base}.copy${counter}"
        counter=$((counter + 1))
    done
    mv -n "{}" "$dest" 2>/dev/null
    '
}

set_background() {
    local file="$1"
    if [ $XDG_SESSION_TYPE = "x11" ]; then
        xwallpaper --zoom "$file"
    else
        swww img "$file"
    fi
}

trash() {
    local file="$@"
    trash-put "$file"
}

paste_files() {
    local copied_dir="/tmp/copied"
    local dest_dir="."
    [ -d "$copied_dir" ] || { echo "No copied files found" >> /tmp/fzf-paste.log; return 0; }

    for src in "$copied_dir"/*; do
        [ -e "$src" ] || continue
        local base_name=$(basename "$src")
        echo "Processing $base_name" >> /tmp/fzf-paste.log

        # Remove .copy or .copyN suffix to get original name
        local orig_name="${base_name%%.copy*}"
        local target="$dest_dir/$orig_name"

        if [ ! -e "$target" ]; then
            # Original name is free, use it
            mv -n "$src" "$target" 2>>/tmp/fzf-error.log
            [ $? -eq 0 ] && echo "Pasted $base_name as $orig_name" >> /tmp/fzf-paste.log || echo "Failed to paste $base_name as $orig_name" >> /tmp/fzf-paste.log
        else
            # Original name exists, try .copy
            local copy_target="$dest_dir/$orig_name.copy"
            if [ ! -e "$copy_target" ]; then
                mv -n "$src" "$copy_target" 2>>/tmp/fzf-error.log
                [ $? -eq 0 ] && echo "Pasted $base_name as $orig_name.copy" >> /tmp/fzf-paste.log || echo "Failed to paste $base_name as $orig_name.copy" >> /tmp/fzf-paste.log
            else
                # .copy exists, increment suffix
                local counter=1
                while [ -e "$dest_dir/$orig_name.copy$counter" ]; do
                    counter=$((counter + 1))
                done
                mv -n "$src" "$dest_dir/$orig_name.copy$counter" 2>>/tmp/fzf-error.log
                [ $? -eq 0 ] && echo "Pasted $base_name as $orig_name.copy$counter" >> /tmp/fzf-paste.log || echo "Failed to paste $base_name as $orig_name.copy$counter" >> /tmp/fzf-paste.log
            fi
        fi
    done

    # Clean up /tmp/copied/
    rm -rf "$copied_dir"/* 2>>/tmp/fzf-error.log
    [ $? -eq 0 ] && echo "Cleaned $copied_dir" >> /tmp/fzf-paste.log
}

rename_file() {
    local file="$1"
    [ -e "$file" ] || return 0
    local base=$(basename "$file")
    local dir=$(dirname "$file")
    local new_name
    new_name=$(echo "$base" | fzf --print-query --prompt "Rename '$base' to: " --query "$base" | tail -n 1)
    if [ -n "$new_name" ] && [ "$new_name" != "$base" ]; then
        mv -n "$file" "$dir/$new_name" 2>/dev/null
    fi
}

rem_copied() {
    if [[ -d /tmp/copied ]]; then
        rm -rf /tmp/copied/ 2>/dev/null
    fi
}

export -f rem_copied
export -f fileview
export -f imgview
export -f vidview
export -f copy_files
export -f move_files
export -f rename_file
export -f paste_files
export -f set_background

fzfm () {
    while true; do
        selection="$(lsd -a | fzf \
            --bind "left:pos(2)+accept" \
            --bind "right:accept" \
            --bind "enter:accept" \
            --bind "alt-up:preview-up" \
            --bind "alt-down:preview-down" \
            --bind "alt-d:execute(bash -e ~/.local/fzfm/create_dir.sh; sync)+reload(lsd -a)" \
            --bind "alt-f:execute(bash -e ~/.local/fzfm/create_file.sh; sync)+reload(lsd -a)" \
            --bind "alt-t:execute(trash {+2})+reload(lsd -a)" \
            --bind "alt-c:execute-silent(copy_files {+})+reload(lsd -a)" \
            --bind "alt-m:execute(move_files {+})+reload(lsd -a)" \
            --bind "alt-p:execute-silent(paste_files)+reload(lsd -a)" \
            --bind "alt-r:execute(bash -e ~/.local/fzfm/rename.sh {}; sync)+reload(lsd -a)" \
            --bind "alt-b:execute(set_background "$(pwd)"/{2})+reload(lsd -a)" \
            --bind "alt-s:execute(mpv -fs {2} >/dev/null 2>&1 &)" \
            --bind "esc:execute(rem_copied)+abort" \
            --bind "space:toggle" \
            --color=fg:#d0d0d0,fg+:#4b443e,bg+:#000000 \
            --color=hl:#5f87af,hl+:#487caf,info:#afaf87,marker:#274a37 \
            --color=pointer:#4b443e,spinner:#af5fff,prompt:#4b443e,header:#87afaf,info:#417070 \
            --height 100% \
            --pointer  \
            --reverse \
            --multi \
            --info inline-right \
            --prompt "$(pwd) " \
            --border "bold" \
            --border-label " Fuzzy File Manager " \
            --preview-window=right:65% \
            --preview 'cd_pre="$(echo $(pwd)/$(echo {2}))";
        echo "Folder: " $cd_pre;
        lsd -a --icon=always --color=always "${cd_pre}";
        kitten icat --clear break 2>/dev/null
        case "$(file --mime-type -b {2})" in
            text/*)
                fileview {2}
                ;;
            image/*)
                imgview {2}
                ;;
            video/*)
                vidview {2}
                ;;
        esac' | awk '{print $2}')"
            if [[ -d ${selection} ]]; then
                >/dev/null cd "${selection}"
            elif [[ -f "${selection}" ]]; then
                file_type=$(file -b --mime-type "${selection}" | cut -d'/' -f1)
                case $file_type in
                    "text")
                        nvim -u $HOME/.config/nvim/init.lua "${selection}"
                        ;;
                    "image")
                        for fType in ${selection}
                        do 
                            if [[ "${fType}" == *.xcf ]]; then
                                gimp 2>/dev/null "${selection}"
                            else
                                sxiv "${selection}"
                            fi
                        done
                        ;;
                    "video")
                        mpv -fs "${selection}" > /dev/null
                        ;;
                    "application")
                        for fType in ${selection}
                        do
                            if [[ "${fType}" == *.docx ]] || [[ "${fType}" == *.odt ]]; then
                                devour libreoffice "${selection}" > /dev/null
                            elif [[ "${fType}" == *.pdf ]]; then
                                zathura 2>/dev/null "${selection}"
                            elif [[ "${fType}" == *.aup3 ]]; then
                                audacity "${selection}" > /dev/null
                            fi
                        done
                        ;;

                    "inode")
                        nvim -u $HOME/.config/nvim/init.lua "${selection}"
                        ;;
                esac
            else
                break
            fi
        done
    }
clear
fzfm
