#!/usr/bin/env bash
# tmux status line: CPU / Memory / Disk 使用率
# tmux の status-right から status-interval 秒ごとに呼ばれる。
# Linux(/proc) と macOS(Darwin) の両方に対応する。
#
# 注: Nerd Font グリフ(󰻠 󰍛 󰋊)と powerline セパレータ()は、bash 3.2(macOS 既定)でも
# 壊れないよう $'\U...' エスケープを使わず UTF-8 の生グリフを直接埋め込んでいる。

CACHE="/tmp/tmux-cpu-stat-${USER}"
OS="$(uname -s)"

# --- CPU usage ---
cpu_usage() {
  if [[ "$OS" == "Linux" ]]; then
    # /proc/stat の2回読み取り差分から算出（前回値は CACHE に保存）
    local user nice system idle iowait irq softirq steal total busy pct
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    busy=$((total - idle - iowait))

    if [[ -f "$CACHE" ]]; then
      local prev_total prev_busy dtotal dbusy
      read -r prev_total prev_busy < "$CACHE"
      dtotal=$((total - prev_total))
      dbusy=$((busy - prev_busy))
      if [[ $dtotal -gt 0 ]]; then
        pct=$((dbusy * 100 / dtotal))
      else
        pct=0
      fi
    else
      pct=0
    fi

    echo "$total $busy" > "$CACHE"
    echo "$pct"
  else
    # macOS: top の瞬間値（"CPU usage: x% user, y% sys, z% idle" の idle を 100 から引く）
    local busy
    busy=$(top -l 1 -n 0 2>/dev/null \
      | awk '/CPU usage/ { gsub(/%/,""); v = 100 - $7; if (v < 0) v = 0; printf "%d", v }')
    echo "${busy:-0}"
  fi
}

# --- Memory usage ---
mem_usage() {
  if [[ "$OS" == "Linux" ]]; then
    local key val total avail
    while IFS=': ' read -r key val _; do
      case "$key" in
        MemTotal)     total=$val ;;
        MemAvailable) avail=$val ;;
      esac
    done < /proc/meminfo
    if [[ -n "$total" && "$total" -gt 0 ]]; then
      echo $(( (total - avail) * 100 / total ))
    else
      echo 0
    fi
  else
    # macOS: vm_stat のページ数 + hw.pagesize/hw.memsize から使用率を概算
    # used ≈ (active + wired + compressed) * pagesize
    local pagesize total vm active wired compressed used
    pagesize=$(sysctl -n hw.pagesize 2>/dev/null)
    total=$(sysctl -n hw.memsize 2>/dev/null)
    vm=$(vm_stat 2>/dev/null)
    active=$(echo "$vm"     | awk '/Pages active/                {gsub(/\./,""); print $3}')
    wired=$(echo "$vm"      | awk '/Pages wired down/            {gsub(/\./,""); print $4}')
    compressed=$(echo "$vm" | awk '/occupied by compressor/      {gsub(/\./,""); print $5}')
    if [[ -n "$pagesize" && -n "$total" && "$total" -gt 0 ]]; then
      used=$(( ( ${active:-0} + ${wired:-0} + ${compressed:-0} ) * pagesize ))
      echo $(( used * 100 / total ))
    else
      echo 0
    fi
  fi
}

# --- Disk usage（/ の使用率。df -P は Linux/macOS 共通で 1 行出力）---
disk_usage() {
  df -P / | awk 'NR==2 {gsub(/%/,"",$5); print $5}'
}

cpu=$(cpu_usage)
mem=$(mem_usage)
disk=$(disk_usage)

# Nerd Font アイコン（生グリフ）
CPU_ICON='󰻠'   # nf-md-cpu_64_bit
MEM_ICON='󰍛'   # nf-md-memory
DISK_ICON='󰋊'  # nf-md-harddisk

# TokyoNight: 3段階の色 (低=緑, 中=黄, 高=赤)
color() {
  local pct=$1
  if [[ $pct -ge 80 ]]; then
    echo "#f7768e"  # red
  elif [[ $pct -ge 50 ]]; then
    echo "#e0af68"  # yellow
  else
    echo "#9ece6a"  # green
  fi
}

# Powerline segments (right side: dark → bright gradient)
BG0="#16161e"   # status bar background
BG1="#292e42"   # CPU segment
BG2="#3b4261"   # MEM segment
BG3="#7aa2f7"   # DISK segment (matches left-side accent)
FG3="#15161e"   # dark text on bright bg

SEP=$(printf '\xee\x82\xb2')  # U+E0B2 powerline left-pointing separator

printf "#[fg=%s,bg=%s]%s#[fg=%s,bg=%s] %s %2d%% " \
  "$BG1" "$BG0" "$SEP" "$(color "$cpu")" "$BG1" "$CPU_ICON" "$cpu"
printf "#[fg=%s,bg=%s]%s#[fg=%s,bg=%s] %s %2d%% " \
  "$BG2" "$BG1" "$SEP" "$(color "$mem")" "$BG2" "$MEM_ICON" "$mem"
printf "#[fg=%s,bg=%s]%s#[fg=%s,bg=%s,bold] %s %2d%% " \
  "$BG3" "$BG2" "$SEP" "$FG3" "$BG3" "$DISK_ICON" "$disk"
