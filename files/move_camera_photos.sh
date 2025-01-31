#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Move photos from SD Card
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ../icons/cam.png

# Documentation:
# @raycast.description Copies photos from my camera's SD Cards to the correct directory
# @raycast.author Manik

echo """
    .-------------------.
    /--\"--.------.------/|
    |Kodak|__Ll__| [==] ||
    |     | .--. | \"\"\"\" ||
    |     |( () )|      ||
    |     | \`--' |      |/
    \`-----'------'------'
--------------------------------
   SD Card Photo Sync Utility
--------------------------------    
    """

SOURCE_DIRS=("RICOH GR" "X-T5")
DEST_DIR="/Users/manik/Pictures/Photo Archive/Digital/2025"

for dir in "${SOURCE_DIRS[@]}"; do
   if [ -d "/Volumes/$dir" ]; then
        echo -e "$dir attached.\n"
        if [ "$dir" == "RICOH GR" ]; then
            PHOTO_DIR="/Volumes/$dir/DCIM/100RICOH/"
        elif [ "$dir" == "X-T5" ]; then
            PHOTO_DIR="/Volumes/$dir/DCIM/104_FUJI/"
        fi
        echo "Copying photos from $PHOTO_DIR to $DEST_DIR"
        cp -v -r "$PHOTO_DIR" "$DEST_DIR"
        echo -e "---------------------------------------------------\n"
        echo "Opening Photos App to Import Pictures"
        sleep 0.2
        osascript -e 'tell application "Photos" to activate'
        sleep 0.2
        osascript -e 'tell application "System Events"' -e 'keystroke "I" using {shift down, command down}' -e 'end tell'
   else
        echo -e "$dir not found. Skipping.\n"
        exit 1
   fi
done

echo "To clean the SD Card, run the \"Clean SD Card\" command"