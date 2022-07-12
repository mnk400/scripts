#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update Dotfiles
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🔖

# Documentation:
# @raycast.description Add any chagnes made to dotfiles and push to github
# @raycast.author Manik

# Script to auto update all the tracked files in my dot file repository
source utilmethods.sh

# Original Config file locations
ITERM_CONF="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
VSCODE_CONF="${HOME}/Library/Application Support/Code/User/settings.json"

# Dot file repository locations
ITERM_CONF_REPO="${HOME}/.iterm.conf"
VSCODE_CONF_REPO="${HOME}/.vscode.settings.json"

# Checking for a commit message
if [ "$#" -gt 1 ]
then
    echo "Illegal number of parameters"
    exit 1
fi

# Moving iterm config if any changes
cmp_and_cp "${ITERM_CONF}" "${ITERM_CONF_REPO}"

# Moving VSCode config if any changes
cmp_and_cp "${VSCODE_CONF}" "${VSCODE_CONF_REPO}"

if [[ "$#" == 0 ]]
then
    msg="Scripted Auto Update"
elif [[ "$#" == 1 ]]
then
    msg="$1"
fi

# Creating a commit message
commitMsg="$msg: $(date)"

# Adding all the tracked files
yadm add -u

# Committing
yadm commit -m "$commitMsg"
if [[ $? -eq 0 ]]
then
    # Pushing to github
    yadm push
    echo "Pushed to Github"
else
    echo "No changes to push"
fi

