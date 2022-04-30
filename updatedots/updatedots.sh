#!/bin/bash

# Script to auto update all the tracked files in my dot file repository
source echocolors.sh
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
    echoWarn "Illegal number of parameters"
    exit
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
    echoSuccess "Pushed to Github"
else
    echoError "No changes to push"
fi

