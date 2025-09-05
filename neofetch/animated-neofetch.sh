#!/bin/bash

ascii_col=2
text_col=40
delay=0.4

USER_NAME=$(whoami)
HOSTNAME=$(hostname)

saturn_art=(
"   ________________"
"  /     \\__    ___/"
" /  \\ /  \\|    |   "
"/    Y    \\    |   "
"\\____|__  /____|   "
"        \\/         "
)

ring_frames=(
"   .     :     ."
"     :     .     "
"   .     :     ."
"     :     .     "
)

# Updated colors:
COLOR_USER="\033[38;5;117m"      # soft blue (user)
COLOR_HOST="\033[38;5;117m"      # soft blue (host)
COLOR_LABEL="\033[38;5;180m"     # darker muted yellow (labels)
COLOR_VALUE="\033[38;5;110m"     # muted greenish blue (values)
COLOR_RING="\033[38;5;61m"       # subtle dark blue (rings)
COLOR_BALL="\033[38;5;75m"       # brighter blue-gray for ascii
COLOR_RESET="\033[0m"

glitch_char() {
  [[ "$1" == " " ]] && echo -n " " && return
  (( RANDOM % 30 == 0 )) && echo -n "·" || echo -n "$1"
}

get_info() {
  DISTRO=$(lsb_release -d 2>/dev/null | cut -f2- || echo "Unknown")
  HOST=$HOSTNAME
  USER=$USER_NAME
  UPTIME=$(uptime -p)
  SHELL=$(basename "$SHELL")
  PACKAGES=$(($(pacman -Qq 2>/dev/null | wc -l) + $(flatpak list 2>/dev/null | wc -l)))
  RESOLUTION=$(xdpyinfo 2>/dev/null | awk '/dimensions:/ {print $2}' || echo "Unknown")
  THEME=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d \' || echo "Unknown")
  ICONS=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d \' || echo "Unknown")
  TERMINAL=$(basename "$TERM")
  CPU=$(grep -m1 'model name' /proc/cpuinfo | cut -d ':' -f2 | xargs)
  GPU=$(lspci | grep -E "VGA|3D" | cut -d ':' -f3 | xargs)
  RAM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
  DISK=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
  if BAT=$(upower -e | grep BAT | head -n1); then
    BAT_PERC=$(upower -i "$BAT" | awk '/percentage/ {print $2}')
    BAT_STATE=$(upower -i "$BAT" | awk '/state/ {print $2}')
    BATTERY="${BAT_PERC} [${BAT_STATE}]"
  else
    BATTERY="N/A"
  fi
  DATE=$(date '+%a %d %b %Y %H:%M:%S')

  info=(
    "$USER@obsidian"
    "OS:$DISTRO"
    "Host:$HOST"
    "User:$USER"
    "Uptime:$UPTIME"
    "Shell:$SHELL"
    "Kernel:$KERNEL"
    "Packages:$PACKAGES"
    "Resolution:$RESOLUTION"
    "Theme:$THEME"
    "Icons:$ICONS"
    "Terminal:$TERMINAL"
    "CPU:$CPU"
    "GPU:$GPU"
    "RAM:$RAM"
    "Disk:$DISK"
    "Battery:$BATTERY"
    "Date:$DATE"
  )
}

rows=$(tput lines)
cols=$(tput cols)

min_rows=$(( ${#info[@]} > ${#saturn_art[@]} ? ${#info[@]} : ${#saturn_art[@]} ))
min_rows=$((24))

if (( rows < min_rows)); then
  clear
  exit 0
fi


print_rings() {
  local frame=$1
  tput cup $((ascii_start - 2)) $ascii_col
  printf "${COLOR_RING}%s${COLOR_RESET}\n" "${ring_frames[$frame]}"
}

print_ascii() {
  local y=$ascii_start
  for line in "${saturn_art[@]}"; do
    tput cup $y $ascii_col
    local flickered=""
    for ((i=0; i<${#line}; i++)); do
      flickered+=$(glitch_char "${line:$i:1}")
    done
    printf "${COLOR_BALL}%s${COLOR_RESET}\n" "$flickered"
    ((y++))
  done
}

print_info() {
  local y=$text_row_start
  local first=1
  for line in "${info[@]}"; do
    tput cup $y $text_col
    if (( first == 1 )); then
      IFS='@' read -r user host <<< "$line"
      printf "${COLOR_USER}%s${COLOR_RESET}@${COLOR_HOST}%s${COLOR_RESET}\n" "$user" "$host"
      # Underline below heading
      tput cup $((y+1)) $text_col
      printf "${COLOR_LABEL}%*s${COLOR_RESET}\n" "${#line}" '' | tr ' ' '-'
      ((y++))
      first=0
    else
      local label=${line%%:*}
      local value=${line#*:}
      printf "${COLOR_LABEL}%s:${COLOR_RESET}${COLOR_VALUE}%s${COLOR_RESET}\n" "$label" "$value"
    fi
    ((y++))
  done
}

cleanup() {
  tput cnorm
  tput sgr0
  tput cup $((ascii_start + 20)) 0
  exit
}

# MAIN
clear
tput civis
trap cleanup INT TERM

text_row_start=1
get_info

ascii_height=${#saturn_art[@]}
info_height=${#info[@]}
ascii_start=$text_row_start
if (( ascii_height < info_height )); then
  ascii_start=$(( text_row_start + (info_height - ascii_height) / 2 ))
fi

frame=0
frames_count=${#ring_frames[@]}

while true; do
  print_rings $frame
  print_ascii
  print_info
  frame=$(( (frame + 1) % frames_count ))
  read -t $delay -n 1 && cleanup
done
