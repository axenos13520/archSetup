#!/bin/bash

while true; do
    updates_output=$(checkupdates)

    if [[ $? -eq 0 ]]; then
        updates=$(echo "$updates_output" | wc -l)
        break
    fi

    sleep 1
done

if [ "$updates" -eq 0 ]; then
    text="󰸞"
else
    text="$updates"
fi

echo "{\"text\": \"󰏗  $text\", \"tooltip\": \"click for 'pacman -Syu'\"}"
