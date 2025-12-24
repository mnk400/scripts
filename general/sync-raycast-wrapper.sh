#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Sync NAS
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ../icons/sync.png

# Documentation:
# @raycast.description Opens Ghostty and runs NAS sync script
# @raycast.author Manik
# Runbook.ignore

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Open Ghostty and run the sync script
open -a Ghostty --args -e bash -c "cd '$SCRIPT_DIR' && syncnas.sh; echo 'Press any key to close...'; read -n 1"

echo "Opening sync in Ghostty terminal..."
