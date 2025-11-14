#!/usr/bin/env bash
# Outputs: {"text":" <cpu>% | <freq> GHz  󰍛 <mem>%","class":"<classes>"}
# deps: a Nerd Font (for icons), awk

set -eu

# Nerd Font icons (change if you prefer different glyphs)
ICON_CPU=" "
ICON_MEM=" "
SEP=" | "

# --- helpers ---------------------------------------------------------------

read_cpu_stat() {
  # Read aggregated CPU line
  # Fields: user nice system idle iowait irq softirq steal guest guest_nice
  awk '/^cpu /{print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' /proc/stat
}

cpu_percent() {
  # Calculate CPU% between two reads
  local a b c d e f g h i j
  read -r a b c d e f g h i j < <(read_cpu_stat)
  local -i idle1 d1 d2
  local -i total1=$((a+b+c+d+e+f+g+h+i+j))
  idle1=$((d+e))

  sleep 0.1

  read -r a b c d e f g h i j < <(read_cpu_stat)
  local -i total2=$((a+b+c+d+e+f+g+h+i+j))
  local -i idle2=$((d+e))

  local -i dt=$((total2-total1))
  local -i di=$((idle2-idle1))
  # percentage (0–100)
  awk -v dt="$dt" -v di="$di" 'BEGIN{ if(dt<=0){print 0; exit} printf "%.0f", (dt-di)*100/dt }'
}

avg_freq_ghz() {
  # Try sysfs first; fall back to /proc/cpuinfo
  local paths=()
  while IFS= read -r p; do paths+=("$p"); done < <(ls /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq 2>/dev/null || true)

  if ((${#paths[@]})); then
    awk '{sum+=$1} END{ if(NR==0){print "0.00"} else {printf "%.2f", (sum/NR)/1e6} }' "${paths[@]}"
  else
    # fallback: average MHz from /proc/cpuinfo
    awk -F': +' '/^cpu MHz/{sum+=$2; n++} END{ if(n==0){print "0.00"} else {printf "%.2f", (sum/n)/1000} }' /proc/cpuinfo
  fi
}

mem_percent() {
  # Use MemAvailable for accuracy
  awk '
    /^MemTotal:/     {t=$2}
    /^MemAvailable:/ {a=$2}
    END {
      if (t>0) printf "%.0f", (t-a)*100/t;
      else print 0
    }' /proc/meminfo
}

classes_from_levels() {
  local cpu="$1" mem="$2"
  local c="ok"
  (( cpu >= 80 )) && c="$c cpu-high" || (( cpu >= 50 )) && c="$c cpu-mid"
  (( mem >= 80 )) && c="$c mem-high" || (( mem >= 60 )) && c="$c mem-mid"
  printf "%s" "$c"
}

# --- loop -------------------------------------------------------------------

print_line() {
  local cpu mem freq classes
  cpu="$(cpu_percent)"
  mem="$(mem_percent)"
  freq="$(avg_freq_ghz)"
  classes="$(classes_from_levels "$cpu" "$mem")"
  printf '{"text":"%s %s%%%s%s GHz  %s %s%%","class":"%s"}\n' \
    "$ICON_CPU" "$cpu" "$SEP" "$freq" "$ICON_MEM" "$mem" "$classes"
}

print_line
