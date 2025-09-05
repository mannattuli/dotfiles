#!/bin/bash

# Define the options for the Rofi power menu
# Use icons from Nerd Fonts for a sleek look
shutdown_option="  Shutdown"
reboot_option="  Reboot"
suspend_option="鈴  Suspend"
lock_option="  Lock"

options="$shutdown_option\n$reboot_option\n$suspend_option\n$lock_option"

# Use Rofi 
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power:")

# Execute the chosen action
if [ -n "$chosen" ]; then
    case "$chosen" in
        "$shutdown_option")
            systemctl poweroff
            ;;
        "$reboot_option")
            systemctl reboot
            ;;
        "$suspend_option")
            systemctl suspend
            ;;
        "$lock_option")
            # Assumes you have i3lock
            i3lock
            ;;
    esac
fi
