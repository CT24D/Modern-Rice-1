#!/bin/bash

# Configuration Variables (Adapted from AHK script)

# Zoom Settings
# Default: 3600 tall. For Linux/Hyprland, we will define a ratio or a fixed pixel value for simplicity.
ZOOM_HEIGHT=130600

# Get screen resolution using hyprctl and jq
SCREEN_WIDTH=$(hyprctl monitors -j | jq -r '.[0].width')
SCREEN_HEIGHT=$(hyprctl monitors -j | jq -r '.[0].height')

# Calculate zoom dimensions based on screen width
ZOOM_WIDTH=$SCREEN_WIDTH/1000
ZOOM_X_POS=0
# Center the zoom vertically
ZOOM_Y_POS=$(( (SCREEN_HEIGHT - ZOOM_HEIGHT) / 2 ))


toggle_zoom() {
    # Get active window address (unique identifier in Hyprland)
    ACTIVE_ADDR=$(hyprctl activewindow -j | jq -r '.address')

    # Use Hyprland marks to check if the window is currently zoomed.
    # The mark helps us remember the state without storing variables across script executions.
    IS_ZOOMED=$(hyprctl activewindow  -j | jq -r '.tags' | grep "zoom")

    if [ "$IS_ZOOMED" = "zoom" ]; then
        # --- Restore Window ---

        # Restore previous state (Hyprland automatically handles restoration of tiling/floating)
        # We need to manually store and retrieve position/size if you want exact AHK replication, 
        # but the simplest way is to rely on Hyprland's layout management. 
        # The following command restores the window to its managed state.
	hyprctl dispatch tagwindow -- -zoom
        hyprctl dispatch togglefloating
        hyprctl dispatch centerwindow # Optional: helps manage floating windows better after moving
        # If the window was not floating initially, togglefloating twice restores its tiling state.
        hyprctl dispatch togglefloating 2>/dev/null


    else
        # --- Zoom Window In ---


        # Force the window into floating mode so we can manually position and size it
	
	hyprctl dispatch tagwindow +zoom
        hyprctl dispatch togglefloating

        # Move and resize the window using hyprctl dispatch commands
        # Coordinates are absolute pixel values
        hyprctl dispatch movewinowpixel $ZOOM_X_POS $ZOOM_Y_POS, activewindow
        hyprctl dispatch resizeactive $ZOOM_WIDTH $ZOOM_HEIGHT 
    fi
}

toggle_zoom

