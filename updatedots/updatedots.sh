#!/bin/bash

# Script to auto update all the tracked files in my dot file repository
source echocolors.sh

# Checking for a commit message
if [ "$#" -gt 1 ]; then
    echoWarn "Illegal number of parameters"
    exit
fi

if [ "$#" == 0 ]; then
    msg="Scripted Auto Update"
elif [ "$#" == 1 ]; then
    msg="$1"
fi

# Creating a commit message
commitMsg="$msg: $(date)"

# Adding all the tracked files
yadm add -u

# Committing
yadm commit -m "$commitMsg"
if [ $? -eq 0 ]; then
    # Pushing to github
    yadm push
    echoSuccess "Pushed to Github"
else
    echoError "No changes to push"
fi

