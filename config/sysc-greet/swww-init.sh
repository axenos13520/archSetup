#!/bin/bash

while [ -z "$(pgrep -x swww-daemon)" ]; do
    swww-daemon &
    sleep 0.5s
done
