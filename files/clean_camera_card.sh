#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clean SD Card
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ../icons/cam.png

# Documentation:
# @raycast.description Cleans and deletes photos off the SD card after a confirmation and ejects it
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

mkdir /tmp/workdir3417958
cd /tmp/workdir3417958

for dir in "${SOURCE_DIRS[@]}"; do
   if [ -d "/Volumes/$dir" ]; then
        echo -e "$dir attached.\n"
        if [ "$dir" == "RICOH GR" ]; then
            PHOTO_DIR="/Volumes/$dir/DCIM/100RICOH/"
        elif [ "$dir" == "X-T5" ]; then
            PHOTO_DIR="/Volumes/$dir/DCIM/104_FUJI/"
        fi
        echo "Will attempt to clean $PHOTO_DIR"
        OSA_VAR=`osascript -e "set T to text returned of (display dialog \"This operation will permanantly delete pictures from the $dir SD card. Are you sure?\n\nType Yes to confirm.\" buttons {\"Cancel\", \"OK\"} default button \"OK\" default answer \"\")"`
        open raycast://
        if [ "$OSA_VAR" == "Yes" ] && [ "$PHOTO_DIR" != "" ]; then
            echo "Cleaning directory $PHOTO_DIR"
            cd "$PHOTO_DIR" && rm -v *
            if [ $? -eq 0 ]; then
                echo "Ejecting SD Card."
                osascript -e "tell application \"Finder\" to eject \"$dir\""
            else
                echo "Issue with the delete, not ejecting SD Card."
            fi
        else
            echo "Expected response not recieved. Skipping for $dir"
        fi
        echo -e "---------------------------------------------------\n"
   else
        echo -e "$dir not found. Skipping.\n"
   fi
done

rm -r /tmp/workdir3417958