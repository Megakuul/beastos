#!/bin/bash
result=$(playerctl metadata --format '{{ title }} | {{ artist }}' | sed 's/&/&amp;/g')
status=$(playerctl status 2>/dev/null || echo "Stopped")
if [ "$status" = "Playing" ]; then
    jq -nc --arg text "   $result" --arg tip "$result" '{"text": $text, "tooltip": $tip, "class": "playing"}'
elif [ "$status" = "Paused" ]; then
    jq -nc --arg text "   $result" --arg tip "$result" '{"text": $text, "tooltip": $tip, "class": "paused"}'
else
    jq -nc --arg text "   $result" --arg tip "$result" '{"text": $text, "tooltip": $tip, "class": "stopped"}'
fi
