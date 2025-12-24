#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy URL
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ../icons/link.png

# Documentation:
# @raycast.author mxnik
# @raycast.description Fetch URL from currently active browser window (Safari, Chrome)
# Runbook.ignore

try
    tell application "System Events"
        set frontApp to name of first application process whose frontmost is true
    end tell

    if frontApp is "Safari" then
        tell application "Safari"
            set currentURL to URL of current tab of front window
            set the clipboard to currentURL
        end tell
    else if frontApp is "Google Chrome" then
        tell application "Google Chrome"
            set currentURL to URL of active tab of front window
            set the clipboard to currentURL
        end tell
    else
        error "Unsupported browser: " & frontApp
    end if

    return currentURL
on error errorMessage
    return "Error: " & errorMessage
end try
