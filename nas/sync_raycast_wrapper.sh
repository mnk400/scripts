#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title NAS Sync
# @raycast.mode inline
# @raycast.refresh disabled

# Optional parameters:
# @raycast.icon ../icons/sync.png

# Documentation:
# @raycast.description Wrapper around my syncnas script to support raycast nicely
# @raycast.author Manik

LOG_FILE=".sync.log"

is_it_already_running=$(ps aux | grep "./syncnas.sh" | grep -v "grep")

if [ "$is_it_already_running" != "" ]
then
    pkill -f ./syncnas.sh
    echo "💀"
    echo """
            __   .__.__  .__             .___
______ |  | _|__|  | |  |   ____   __| _/
\____ \|  |/ /  |  | |  | _/ __ \ / __ | 
|  |_> >    <|  |  |_|  |_\  ___// /_/ | 
|   __/|__|_ \__|____/____/\___  >____ | 
|__|        \/                 \/     \/ 

    """ >> .sync.log
    exit 0
fi

if [ -f $LOG_FILE ]
then
    rm $LOG_FILE
fi

./syncnas.sh &> $LOG_FILE &

date +"Last Synced at %I:%M %p on %d %b "
