#!/bin/bash

get_workspaces() {
    current=$(hyprctl activeworkspace -j | jq '.id')
    workspaces=$(hyprctl workspaces -j | jq '.[].id' | sort -n)
    
    # Create workspace display with icons
    workspace_str=""
    for ws in $workspaces; do
        # Map workspace numbers to icons
        case $ws in
            1) icon="﬏" ;;
            2) icon="" ;;
            3) icon="" ;;
            4) icon="" ;;
            5) icon="" ;;
            6) icon="" ;;
            *) icon="" ;;
        esac
        
        if [ "$ws" = "$current" ]; then
            workspace_str+="<span color='#7f2a2aff'>$icon</span> "
        else
            workspace_str+="<span color='#cfcfc9'>$icon</span> "
        fi
    done
    
    echo "{\"text\":\"$workspace_str\", \"alt\":\"$current\", \"tooltip\":\"Workspace $current\"}"
}

# Output initial state
get_workspaces

# Listen to Hyprland events
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    case $line in
        workspace\>\>*|createworkspace\>\>*|destroyworkspace\>\>*|focusedmon\>\>*)
            get_workspaces
            ;;
    esac
done