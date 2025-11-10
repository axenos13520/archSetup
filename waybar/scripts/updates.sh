#!/bin/bash

updates=$(checkupdates 2>/dev/null | wc -l)

if [ "$updates" -eq 0 ]; then
    text="󰸞"
else
    text="$updates"
fi

echo "{\"text\": \"󰏗  $text\", \"tooltip\": \"click for 'pacman -Syu'\"}"
