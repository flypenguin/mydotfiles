#!/usr/bin/env bash

# crazy long line.
new_pointer_map=$(xmodmap -pp 2>&1 \
    | grep -E '[[:space:]]*[0-9]+[[:space:]]+[0-9]+' \
    | awk '{print $2}' \
    | tr "\n" " " \
    | sed 's/4 5/5 4/g')

xmodmap -e "pointer = ${new_pointer_map}"

