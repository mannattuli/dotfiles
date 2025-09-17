#!/bin/bash

chosen_ssid=$(nmcli --fields SSID dev wifi list --rescan yes | awk '{ if (NR > 1) {print}}' | rofi -dmenu -p "Wi-Fi:" | xargs)

if [ -n "$chosen_ssid" ]; then
    nmcli dev wifi connect "$chosen_ssid"
fi
