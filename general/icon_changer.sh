#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Icon Changer
# @raycast.mode inline
# @raycast.refreshTime disabled

# Optional parameters:
# @raycast.icon ../icons/brush.png

# Documentation:
# @raycast.description Changes icons to custom icons for a certain number of stubborn apps
# @raycast.author Manik

pspsps=$(security find-generic-password -w -s 'pspsps' -a $USER)

# Google Chrome
echo "$pspsps" | sudo -S chmod 777 /Applications/Google\ Chrome.app &>/dev/null
fileicon set /Applications/Google\ Chrome.app /Users/manik/Documents/Misc/Icons/Chrome.icns &>/dev/null

# Fleet
echo "$pspsps" | sudo -S cp /Users/manik/Documents/Misc/Icons/code.icns /Applications/Fleet.app/Contents/Resources/Fleet.icns
echo "$pspsps" | sudo -S cp /Users/manik/Documents/Misc/Icons/code.png /Applications/Fleet.app/Contents/app/icons/fleet-appicon.png

# MS Word
echo "$pspsps" | sudo -S chmod 777 /Applications/Microsoft\ Word.app
fileicon set /Applications/Microsoft\ Word.app /Users/manik/Documents/Misc/Icons/Word.icns &>/dev/null

# MS PowerPoint
echo "$pspsps" | sudo -S chmod 777 /Applications/Microsoft\ PowerPoint.app
fileicon set /Applications/Microsoft\ PowerPoint.app /Users/manik/Documents/Misc/Icons/PowerPoint.icns &>/dev/null

# Noto
echo "$pspsps" | sudo -S chmod 777 /Applications/Noto.app
fileicon set /Applications/Noto.app /Users/manik/Documents/Misc/Icons/Noto.png &>/dev/null

# NepTunes
echo "$pspsps" | sudo -S chmod 777 /Applications/NepTunes.app
fileicon set /Applications/NepTunes.app /Users/manik/Documents/Misc/Icons/Silicio.icns &>/dev/null

# Logi Options+
echo "$pspsps" | sudo -S chmod 777 /Applications/logioptionsplus.app
fileicon set /Applications/logioptionsplus.app /Users/manik/Documents/Misc/Icons/options.icns &>/dev/null

date +"Last refreshed at %I:%M %p on %d %b"