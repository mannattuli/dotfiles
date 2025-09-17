#!/bin/bash

# Add more applications and icons as needed.

while read -r wid; do
    class=$(xprop -id "$wid" WM_CLASS | cut -d\" -f4)
    case "$class" in
        "kitty")
            echo "" # Nerd Font icon for Kitty
            ;;
        "firefox")
            echo "" # Nerd Font icon for Firefox
            ;;
        "code")
            echo "" # Nerd Font icon for VS Code
            ;;
        "Chromium")
            echo "" # Nerd Font icon for Chromium
            ;;
        *)
            echo "" # Default icon for unknown windows
            ;;
    esac
done
