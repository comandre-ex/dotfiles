#!/bin/bash
# Audio bar script for Polybar

# Get volume percentage
volume=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oP '\d+(?=%)' | head -1)

# Check if muted
muted=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -q "yes" && echo "yes" || echo "no")

# Icons
icon_muted="󰝟"
icon_low="󰝟"
icon_med="󰡿"
icon_high="󰡾"

if [ "$muted" = "yes" ]; then
    echo " 󰝟 MUT "
else
    # Calculate bar length (8 blocks)
    blocks=8
    filled=$((volume * blocks / 100))
    empty=$((blocks - filled))
    
    # Create bar
    bar=""
    for i in $(seq 1 $filled); do
        bar="${bar}█"
    done
    for i in $(seq 1 $empty); do
        bar="${bar}░"
    done
    
    # Select icon based on volume
    if [ "$volume" -lt 33 ]; then
        icon=$icon_low
    elif [ "$volume" -lt 66 ]; then
        icon=$icon_med
    else
        icon=$icon_high
    fi
    
    echo " $icon $bar $volume% "
fi