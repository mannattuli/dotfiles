#!/bin/bash

STATUS=$(bluetoothctl show | grep "Powered" | cut -d ' ' -f 2)

if [ "$STATUS" = "yes" ]; then
    echo "On"
else
    echo "Off"
fi