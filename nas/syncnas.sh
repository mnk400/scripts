#!/bin/bash

# Host information
HOST='192.168.0.3'
DIR_ON_HOST="/Volumes/woof/Wolf"

# Host paths
DOC_ON_HOST="${DIR_ON_HOST}/Documents"
PROJ_ON_HOST="${DIR_ON_HOST}/Projects"
PICS_ON_HOST="${DIR_ON_HOST}/Photos/Pictures"

# Local paths
DOC_LOCAL="${HOME}/Documents/"
PROJ_LOCAL="${HOME}/Projects/"
PICS_LOCAL="${HOME}/Pictures/"

# Excludes
PICS_EXCLUDE="*Library*"

source echocolors.sh

# Checking if connected to the NAS
if ping -q -c 1 -W 1 $HOST >/dev/null; 
then	
	echoInfo "$HOST online, checking if mounted"
	
	# Checking if the path to NAS exists, i.e. if it's mounted
	if [ -d "${DIR_ON_HOST}/Downloads" ] 
	then
		    echoInfo "NAS mounted" 
	else
		    echoWarn "NAS not mounted"
			echoError "Exiting"
			echoInfo "Automatic mounting WIP"
			exit 1
	fi
	
	# Running rsync
	echoInfo "Running rsync"
	
	if [ -d $DOC_ON_HOST ]
	then
		echoInfo "Syncing Documents"
		rsync -rtvu --delete "${DOC_LOCAL}" "${DOC_ON_HOST}"
	else
		echoWarn "Documents folder not found on the NAS. Skipping syncing Documents"
	fi
	
	if [ -d $PROJ_ON_HOST ]
	then
		echoInfo "Syncing Projects"
		rsync -rtvu --delete "${PROJ_LOCAL}" "${PROJ_ON_HOST}"
	else
		echoWarn "Projects folder not found on the NAS. Skipping syncing Projects"
	fi

	if [ -d $PICS_ON_HOST ]
	then
		echoInfo "Syncing Photos"
		rsync -rtvu --delete --exclude="$PICS_EXCLUDE" "${PICS_LOCAL}" "${PICS_ON_HOST}" 
	else
		echoWarn "Picture folder not found on the NAS. Skipping syncing Photos"
	fi
	
else
	# Quitting if not host not found online
	echoError "$HOST not Found, can't sync. Quitting."
fi
