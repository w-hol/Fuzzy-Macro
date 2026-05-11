#!/bin/bash

# Updated Test script for Sober AppManager logic
# Run these while Sober is open

echo "--- 1. Testing 'isAppOpen' (flatpak ps) ---"
if flatpak ps | grep -q "org.vinegarhq.Sober"; then
    echo "SUCCESS: Sober process found via flatpak ps."
else
    echo "FAILURE: Sober process not detected."
fi

echo -e "\n--- 2. Testing 'getWindowSize' (wmctrl) ---"
WINDOW_DATA=$(wmctrl -lG | grep "Sober")
if [ -z "$WINDOW_DATA" ]; then
    echo "FAILURE: Could not find window 'Sober'"
else
    echo "Raw wmctrl output: $WINDOW_DATA"
    # Robust parsing: grab fields 3, 4, 5, 6 from the line
    X=$(echo $WINDOW_DATA | cut -d' ' -f3)
    Y=$(echo $WINDOW_DATA | cut -d' ' -f4)
    W=$(echo $WINDOW_DATA | cut -d' ' -f5)
    H=$(echo $WINDOW_DATA | cut -d' ' -f6)
    echo "Parsed: X=$X, Y=$Y, Width=$W, Height=$H"
fi

echo -e "\n--- 3. Testing 'isAppFocused' (xdotool) ---"
echo "Please focus the Sober window now (3 seconds)..."
sleep 3
ACTIVE_ID=$(xdotool getactivewindow)
ACTIVE_NAME=$(xdotool getwindowname $ACTIVE_ID)
echo "Currently focused window: $ACTIVE_NAME"
if [[ "$ACTIVE_NAME" == *"Sober"* ]]; then
    echo "SUCCESS: Focus detected correctly."
else
    echo "FAILURE: Focus mismatch."
fi

echo -e "\n--- 4. Testing 'maximiseAppWindow' ---"
echo "Maximizing..."
wmctrl -r "Sober" -b add,maximized_vert,maximized_horz
sleep 1
echo "Done. Check if Sober is maximized."

echo -e "\n--- 5. Testing 'setAppFullscreen' ---"
echo "Toggling Fullscreen (ON)..."
wmctrl -r "Sober" -b add,fullscreen
sleep 2
echo "Toggling Fullscreen (OFF)..."
wmctrl -r "Sober" -b remove,fullscreen
echo "Done."

echo -e "\n--- 6. Testing 'closeApp' ---"
read -p "Press Enter to try KILLING Sober... "
flatpak kill org.vinegarhq.Sober
sleep 1
if ! flatpak ps | grep -q "org.vinegarhq.Sober"; then
    echo "SUCCESS: Sober was closed."
else
    echo "FAILURE: Sober is still running."
fi
