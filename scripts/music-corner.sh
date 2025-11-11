#!/usr/bin/env bash

hyprctl dispatch workspace 10

spotify &

hyprctl dispatch movecursor 1500 800

sleep 1s

easyeffects &

sleep 1s

foot --font "JetBrainsMono Nerd Font:size=6" -e cava &
