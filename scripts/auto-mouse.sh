#!/usr/bin/env bash
set -euo pipefail

TARGET_NAME="BT5.2 Mouse"
BTCTL="bluetoothctl"

$BTCTL power on >/dev/null

while true; do
    $BTCTL --timeout 3 scan on 2>/dev/null | while read -r line; do
        if [[ "$line" =~ Device\ ([A-F0-9:]{17})\ (.+)$ ]]; then
            addr="${BASH_REMATCH[1]}"
            name="${BASH_REMATCH[2]}"

            if [[ "$name" == "$TARGET_NAME" ]]; then
                {
                    echo "agent on"
                    echo "default-agent"
                    echo "trust $addr"
                    sleep 1s
                    echo "pair $addr"
                    sleep 1s
                    echo "connect $addr"
                    sleep 1s
                    echo "quit"
                } | $BTCTL
            fi
        fi
    done
done
