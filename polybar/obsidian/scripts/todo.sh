#!/usr/bin/env bash

TODO_FILE=~/.config/polybar/obsidian/todo.txt

case "$1" in
    "check")
        if [ -s "$TODO_FILE" ]; then
            # Delete the first line of the file, marking the item as done
            sed -i '1d' "$TODO_FILE"
        fi
        ;;
    "add")
        new_todo=$(rofi -dmenu -p "New To-Do:" -theme ~/.config/rofi/themes/todo.rasi)
        
        if [ -n "$new_todo" ]; then
            echo "$new_todo" >> "$TODO_FILE"
        fi
        ;;
    "list")
        selection=$(cat "$TODO_FILE" | rofi -dmenu -p "To-Do List:" -theme ~/.config/rofi/themes/todo.rasi)

        if [ -n "$selection" ] && ! grep -qxF -- "$selection" "$TODO_FILE"; then
            echo "$selection" >> "$TODO_FILE"
        elif [ -n "$selection" ]; then
            grep -vxF -- "$selection" "$TODO_FILE" > "$TODO_FILE.tmp" && mv "$TODO_FILE.tmp" "$TODO_FILE"
        fi
        ;;
    *)
        if [ -s "$TODO_FILE" ]; then
            first_todo=$(head -n 1 "$TODO_FILE" | sed 's/^[[:space:]]*//')
            
            echo "  $first_todo"
        else
            echo " no to-dos"
        fi
        ;;
esac
