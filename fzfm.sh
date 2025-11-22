#!/usr/bin/env bash

# previewer
fzf_preview() {
    local selected="$1"
    if [[ -d "$selected" ]]; then
        if command -v lsd &>/dev/null; then
            lsd -a --icon=always --color=always "$selected"
        else
            ls "$selected" --color -Av --group-directories-first
        fi
    elif [[ -f "$selected" ]]; then
        local mime=$(file --mime-type -b $selected)
        case "$mime" in
        text/*)
            bat --style=numbers --theme=gruvbox-dark --color=always "$selected" || cat "$selected"
            ;;
        image/*)
            # might need to update this
            kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@20x1 "$selected"
            ;;
        esac
    fi
}

# file opener
fzf_file_handlers() {
    local selected="$1"
    local mime=$(file --mime-type -b $selected)
    case $mime in
    text/*)
        nvim -u $HOME/.config/nvim/init.lua "$selected"
        ;;
    image/*)
        for fType in $selected; do
            if [[ "${fType}" == *.xcf ]]; then
                gimp 2>/dev/null "$selected"
            else
                sxiv "$selected"
            fi
        done
        ;;
    video/*)
        mpv -fs "$selected" >/dev/null
        ;;
    application/*)
        for fType in $selected; do
            if [[ "${fType}" == *.docx ]] || [[ "${fType}" == *.odt ]]; then
                devour libreoffice "$selected" >/dev/null
            elif [[ "${fType}" == *.pdf ]]; then
                zathura 2>/dev/null "$selected"
            fi
        done
        ;;

    inode/*)
        nvim -u $HOME/.config/nvim/init.lua "$selected"
        ;;
    esac
}

# import files
curr_dir=$(dirname "$0")
source $curr_dir/utils.sh
source $curr_dir/bindkeys.sh # source utils before bindkeys
export -f fzf_preview fzf_file_handlers

fzf_opts="--color=fg:#d0d0d0,fg+:#d0d0d0,bg+:#262626 --color=hl:#5f87af,hl+:#487caf,info:#afaf87,marker:#274a37 \
    --color=pointer:#a62b2b,spinner:#af5fff,prompt:#876253,header:#87afaf --preview-window=right:65% \
    --height 95% --pointer  --reverse --multi --info inline-right"
bind_keys=$(build_bind_keys)

fzfm() {
    # main loop
    # find_cmd is defined in bindkeys.sh so it can use it for reloading fzf
    while true; do
        selection=$(eval "\$find_cmd" | fzf $fzf_opts --bind "$bind_keys" \
            --prompt "Search: " \
            --border "bold" \
            --border-label "$(pwd)/" \
            --preview="bash -c 'fzf_preview {}'" --exit-0)

        if [[ -d ${selection} ]]; then
            cd "$selection"
            continue
        elif [[ -f "$selection" ]]; then
            fzf_file_handlers "$selection"
        else
            break
        fi
    done
}

clear
fzfm
