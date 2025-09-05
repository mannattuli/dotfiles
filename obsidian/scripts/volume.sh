#!/bin/bash

# Function to get volume and status
get_volume() {
    INFO=$(pactl get-sink-volume @DEFAULT_SINK@ | grep 'Volume:' | awk '{print $5}' | sed 's/%//g')
    VOLUME=$(echo "$INFO" | cut -d'.' -f1)

    MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    
    if [ "$MUTE" = "yes" ]; then
        echo "󰝟 Muted"
    else
        # Determine bar based on percentage to avoid rounding errors
        case "$VOLUME" in
            0|1|2|3|4|5|6|7|8|9) bar="|░░░░░░░░░░|" ;;
            1[0-9]) bar="|█░░░░░░░░░|" ;;
            2[0-9]) bar="|██░░░░░░░░|" ;;
            3[0-9]) bar="|███░░░░░░░|" ;;
            4[0-9]) bar="|████░░░░░░|" ;;
            5[0-9]) bar="|█████░░░░░|" ;;
            6[0-9]) bar="|██████░░░░|" ;;
            7[0-9]) bar="|███████░░░|" ;;
            8[0-9]) bar="|████████░░|" ;;
            9[0-9]) bar="|█████████░|" ;;
            100) bar="|██████████|" ;;
            *) bar="|░░░░░░░░░░|" ;; # Default case for safety
        esac

        # Color thresholds
        if [ "$VOLUME" -lt 20 ]; then
            fg="#bf616a"  # red
        elif [ "$VOLUME" -lt 55 ]; then
            fg="#fab387"  # orange
        else
            fg="#6bb2ff"  # cyan
        fi
        
        if [ "$VOLUME" -eq 0 ]; then
            icon=" "  
        else
            icon=""
        fi

        # Apply the color to the entire output string
        echo "%{F$fg}$icon $bar"
    fi
}

# Check for command-line arguments to change volume
case "$1" in
    --inc)
        CURRENT_VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep 'Volume:' | awk '{print $5}' | sed 's/%//g' | cut -d'.' -f1)
        if [ "$((CURRENT_VOLUME + 5))" -gt 100 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ 100%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +5%
        fi
        ;;
    --dec)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    *)
        get_volume
        ;;
esac
