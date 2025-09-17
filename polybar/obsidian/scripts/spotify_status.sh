#!/bin/bash


ARTIST=$(playerctl -p spotify metadata artist 2>/dev/null)
TITLE=$(playerctl -p spotify metadata title 2>/dev/null)

if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
    echo "$ARTIST - $TITLE"
else
    echo " "
fi