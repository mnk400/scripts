#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Icon Changer
# @raycast.mode inline
# @raycast.refreshTime disabled

# Optional parameters:
# @raycast.icon ../../icons/brush.png

# Documentation:
# @raycast.description Changes icons to custom icons for a certain number of stubborn apps
# @raycast.author Manik

pspsps=$(security find-generic-password -w -s 'pspsps' -a $USER)
ICON_DIR="/Users/manik/Documents/Misc/Icons"

# Function to set icon with fileicon
set_icon() {
    echo "$pspsps" | sudo -S chmod 777 "$1" &>/dev/null
    fileicon set "$1" "$2" &>/dev/null
}

# Function to copy icon files directly
copy_icon() {
    echo "$pspsps" | sudo -S cp "$2" "$1"
}

# Apps using fileicon: app_path icon_file
declare -a fileicon_apps=(
    "/Applications/Google Chrome.app" "$ICON_DIR/Chrome.icns"
    "/Applications/Microsoft Word.app" "$ICON_DIR/Word.icns"
    "/Applications/Microsoft PowerPoint.app" "$ICON_DIR/PowerPoint.icns"
    "/Applications/Noto.app" "$ICON_DIR/Noto.png"
    "/Applications/NepTunes.app" "$ICON_DIR/Silicio.icns"
    "/Applications/logioptionsplus.app" "$ICON_DIR/options.icns"
)

# Process fileicon apps
for ((i=0; i<${#fileicon_apps[@]}; i+=2)); do
    set_icon "${fileicon_apps[i]}" "${fileicon_apps[i+1]}"
done

date +"Last refreshed at %I:%M %p on %d %b"
