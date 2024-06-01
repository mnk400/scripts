#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Logs for NAS Sync
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ../icons/sync.png

# Documentation:
# @raycast.description Fetch the last logs for syncnas
# @raycast.author Manik

tail -n 500 -f .sync.log