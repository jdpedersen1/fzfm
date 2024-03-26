#!/bin/bash
target=$@

trash $target && reset && kill $PPID && fzfm.sh

