#!/bin/bash

# Check if brightnessctl is installed
if ! command -v brightnessctl &> /dev/null; then
    echo "brightnessctl not found! Please install it."
    exit 1
fi

# Function to increase brightness
inc_brightness() {
    brightnessctl set +5%
}

# Function to decrease brightness
dec_brightness() {
    brightnessctl set 5%-
}

# Check for command-line arguments
case "$1" in
    --inc)
        inc_brightness
        ;;
    --dec)
        dec_brightness
        ;;
    *)
        # Get brightness percentage
        brightness=$(brightnessctl get)
        max_brightness=$(brightnessctl max)
        percent=$((brightness * 100 / max_brightness))

        case "$percent" in
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
            *) bar="|░░░░░░░░░░|" ;;
        esac

        if [ "$percent" -lt 20 ]; then
            fg="#bf616a"  # red
        elif [ "$percent" -lt 55 ]; then
            fg="#fab387"  # orange
        else
            fg="#6bb2ff"  # cyan
        fi
        
        # Add a space for padding if the percentage is less than 100
        # padding=""
        # if [ "$percent" -lt 100 ]; then
        #     padding=" "
        # fi
        
        icon=""

        echo "%{F$fg}$icon $bar$padding%{F-}"
        ;;
esac
