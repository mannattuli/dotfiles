#!/usr/bin/env bash

MODULE_NAME="bluetooth"

get_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        echo ""
    else
        echo ""
    fi
}

toggle_power() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off
    else
        bluetoothctl power on
    fi
    polybar-msg hook "$MODULE_NAME" 1
}

case "$1" in
    --status)
        get_status
        ;;
    --toggle)
        toggle_power
        ;;
    *)
        get_status
        ;;
esac
