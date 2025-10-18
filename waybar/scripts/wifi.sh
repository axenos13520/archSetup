#!/usr/bin/env bash

IFACE=$(iw dev | awk '$1=="Interface"{print $2; exit}')

if [ -z "$IFACE" ]; then
    echo '{"text": "  No Wi-Fi", "tooltip": "No wireless interface found"}'
    exit 0
fi

ESSID=$(iwgetid -r)
SIGNAL=$(iw dev "$IFACE" link | grep 'signal:' | awk '{print int($2)}')

if [ -z "$ESSID" ] || [ -z "$SIGNAL" ]; then
    echo '{"text": "  Disconnected", "tooltip": "No active Wi-Fi connection"}'
    exit 0
fi

PERCENT=$((100 - 100 * (-40 - SIGNAL) / 70))

[ $PERCENT -gt 100 ] && PERCENT=100
[ $PERCENT -lt 0 ] && PERCENT=0

if [ "$PERCENT" -ge 80 ]; then
    ICON="󰤨"
elif [ "$PERCENT" -ge 60 ]; then
    ICON="󰤥"
elif [ "$PERCENT" -ge 40 ]; then
    ICON="󰤢"
elif [ "$PERCENT" -ge 20 ]; then
    ICON="󰤟"
else
    ICON="󰤯"
fi

echo "{\"text\": \"$ICON  $ESSID\", \"tooltip\": \"$ESSID ($PERCENT%)\"}"
