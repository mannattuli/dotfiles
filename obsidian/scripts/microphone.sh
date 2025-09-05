#!/bin/bash

if ! command -v pactl &> /dev/null; then
    echo "Pactl not found"
    exit 1
fi

case "$1" in
    --status)
        if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "Mute: yes"; then
            echo ""
        else
            echo ""
        fi
        ;;
    --toggle)
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        ;;
    *)
        exit 1
        ;;
esac
