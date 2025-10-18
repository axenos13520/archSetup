#!/bin/bash

updates=$(checkupdates 2>/dev/null | wc -l)

if [ "$updates" -eq 0 ]; then
    echo "󰸞"
else
    echo "$updates"
fi
