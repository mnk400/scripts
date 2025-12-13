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

# Config
SOURCE_DIRS=("RICOH GR" "X-T5")
CURRENT_YEAR=$(date +"%Y")
BASE_DEST_DIR="/Users/manik/Pictures/Photo Archive/Digital"
DEST_DIR="$BASE_DEST_DIR/$CURRENT_YEAR"
LOG_DIR="$BASE_DEST_DIR/.log"
LOG_FILE="$LOG_DIR/photo_sync_$(date +"%Y%m%d_%H%M%S").log"

if [ ! -d "$DEST_DIR" ]; then
    echo "Creating destination directory: $DEST_DIR"
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create destination directory. Exiting."
        exit 1
    fi
fi

if [ ! -d "$LOG_DIR" ]; then
    echo "Creating log directory: $LOG_DIR"
    mkdir -p "$LOG_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create log directory. Using base directory for logs."
        LOG_FILE="$BASE_DEST_DIR/photo_sync_$(date +"%Y%m%d_%H%M%S").log"
    fi
fi

CARD_FOUND=false

for dir in "${SOURCE_DIRS[@]}"; do
    if [ -d "/Volumes/$dir" ]; then
        CARD_FOUND=true
        echo -e "$dir attached.\n"

        if [ "$dir" == "RICOH GR" ]; then
            PHOTO_DIR="/Volumes/$dir/DCIM/100RICOH/"
        elif [ "$dir" == "X-T5" ]; then
            PHOTO_DIR="/Volumes/$dir/DCIM/104_FUJI/"
        fi

        if [ ! -d "$PHOTO_DIR" ]; then
            echo "Source directory $PHOTO_DIR not found. Skipping."
            continue
        fi

        FILE_COUNT=$(find "$PHOTO_DIR" -type f | wc -l)
        if [ "$FILE_COUNT" -eq 0 ]; then
            echo "No files found in $PHOTO_DIR. Skipping."
            continue
        fi

        echo "Found $FILE_COUNT files in $PHOTO_DIR"
        echo "Will copy to $DEST_DIR"

        echo "Copying photos from $PHOTO_DIR to $DEST_DIR"
        echo "This may take a while depending on the number and size of files..."

        rsync -a --info=name,progress2 "$PHOTO_DIR" "$DEST_DIR" | tee -a "$LOG_FILE"

        if [ $? -eq 0 ]; then
            echo "Copy completed successfully!" | tee -a "$LOG_FILE"
        else
            echo "Error occurred during copy. Check the log file: $LOG_FILE" | tee -a "$LOG_FILE"
        fi

        echo -e "---------------------------------------------------\n"
        echo "Opening Photos App to Import Pictures from $DEST_DIR"

        osascript -e 'tell application "Photos" to activate'
        sleep 0.5
        osascript -e 'tell application "System Events"' -e 'keystroke "I" using {shift down, command down}' -e 'end tell'
        sleep 1

        osascript <<EOF
        tell application "System Events"
            tell process "Photos"
                repeat until (exists sheet 1 of window 1)
                    delay 0.5
                end repeat

                key code 5 using {command down, shift down}
                delay 0.5

                keystroke "$DEST_DIR"
                delay 0.5

                keystroke return
                delay 0.5

                keystroke return
            end tell
        end tell
EOF
    else
        echo -e "$dir not found. Skipping.\n"
    fi
done

if [ "$CARD_FOUND" = false ]; then
    echo "No supported SD cards found. Please insert a card and try again."
    exit 1
fi

echo "To clean the SD Card, run the \"Clean SD Card\" command"
