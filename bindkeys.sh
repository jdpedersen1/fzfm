#!/usr/bin/env bash

set -e

export find_cmd="ls -av --group-directories-first"

# {} -> single file operations
# {+} -> multi-file operations
# [<key>]="<execute operations>"
declare -A BINDINGS=(
    [left]="pos(2)+accept"
    [right]="accept"
    [shift-up]="preview-up"
    [shift-down]="preview-down"
    [ctrl-d]="execute(bash -c 'fzf_mkdir {}')+reload($find_cmd)"
    [ctrl-f]="execute(bash -c 'fzf_touch {}')+reload($find_cmd)"
    [ctrl-t]="execute(trash {+})+reload($find_cmd)"
    [ctrl-y]="execute(bash -c 'fzf_copy {+}')+reload($find_cmd)"
    [ctrl-m]="execute(bash -c 'fzf_move {+}')+reload($find_cmd)"
    [ctrl-r]="execute(bash -c 'fzf_remove {+}')+reload($find_cmd)"
    [esc]="abort"
    [space]="toggle"
)

build_bind_keys() {
    local -n bindings_ref="BINDINGS"
    local bind_keys=""

    for key in "${!bindings_ref[@]}"; do
        binding="${bindings_ref[$key]}"
        bind_keys+=",$key:$binding"
    done

    echo "${bind_keys#,}"
}

export -f build_bind_keys
