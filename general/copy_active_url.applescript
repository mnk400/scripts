#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy URL
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ../icons/link.png

# Documentation:
# @raycast.author mxnik
# @raycast.description Fetch URL from currently active browser window(in Safari, Arc, Chrome, Firefox)

try
    tell application "System Events"
        set frontApp to name of first application process whose frontmost is true
    end tell

    if frontApp is "Safari" then
        tell application "Safari"
            set currentURL to URL of current tab of front window
            set the clipboard to currentURL
            log "Safari URL copied to clipboard"
        end tell
    (*
    If you're wondering why is this seemingly similar code repeated instead
    of using an OR inside the if statement. It's because "tell apllication"
    if applescript does not accept varialbe input !!!!!!!
    *)
    else if frontApp is "Arc" then
        tell application "Arc"
            set currentURL to URL of active tab of front window
            set the clipboard to currentURL
            log "Arc URL copied to clipboard"
        end tell
    else if frontApp is "Google Chrome" then
        tell application "Google Chrome"
            set currentURL to URL of active tab of front window
            set the clipboard to currentURL
            log "Chrome URL copied to clipboard"
        end tell
    else
        log "Application not supported to copy current URL from"
    end if
on error errorMessage
    log "An error occurred: " & errorMessage
end try