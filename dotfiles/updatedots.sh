#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update Dotfiles
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ../icons/code.png

# Documentation:
# @raycast.description Add any changes made to dotfiles and push to github
# @raycast.author Manik

source file_utils.sh

# Exit on any error
set -e

# Validate arguments
[[ $# -gt 1 ]] && { echo "Usage: $0 [commit_message]"; exit 1; }

# Config file pairs
configs=(
    "${HOME}/Library/Preferences/com.googlecode.iterm2.plist" "${HOME}/.iterm.conf"
    "${HOME}/Library/Application Support/com.mitchellh.ghostty/config" "${HOME}/.ghostty.config"
)

# Update configs
for ((i=0; i<${#configs[@]}; i+=2)); do
    cmpcp "${configs[i]}" "${configs[i+1]}"
done

# Commit and push
msg="${1:-Scripted Auto Update}: $(date)"
yadm add -u && yadm commit -m "$msg" && { yadm push; echo "Pushed to Github"; } || echo "No changes to push"
