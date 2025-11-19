#!/usr/bin/env bash

wait_for() {
    while ! hyprctl clients -j | jq -e ".[] | select(.class==\"$1\")" >/dev/null; do
        sleep 0.2
    done
}

hyprctl dispatch workspace 10 >/dev/null

spotify >/dev/null 2>&1 &

wait_for "Spotify"

foot --font "JetBrainsMono Nerd Font:size=6" -e cava >/dev/null 2>&1 &

sleep 0.2

easyeffects >/dev/null 2>&1 &
