#!/usr/bin/env bash
# Prints {"text":"N","class":"w-N"} where N = 10 - activeWorkspaceNumber
# Polls every 100ms; emits only on change.

set -eu

get_val() {
  # active WS number (id)
  local id
  id="$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.id' || echo)"
  # sanity: if empty or non-numeric, default to 0
  [[ "$id" =~ ^-?[0-9]+$ ]] || { printf '10'; return; }
  # compute 10 - id
  printf '%s' "$(( 10 - id ))"
}

print_json() {
  printf '{"text":"%s","class":"w-%s"}\n' "$1" "$1"
}

prev="$(get_val)"
print_json "$prev"

while :; do
  curr="$(get_val)"
  if [[ "$curr" != "$prev" ]]; then
    print_json "$curr"
    prev="$curr"
  fi
  sleep 0.1s
done

