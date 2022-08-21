#!/bin/bash

# Host information
HOST='192.168.0.3'
DIR_ON_HOST="/Volumes/wolf/Wolf"

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

# Enable
ENABLE_DOCS=true
ENABLE_PROJ=true
ENABLE_PICS=true

function rsync_local_to_host() {
	SOURCE_DIR=$1
	TARGET_DIR=$2
	SYNC_NAME=$3
	EXCLUDES=$4
	if [[ -d $TARGET_DIR ]]
	then
		if [[ -z $SYNC_NAME ]]
		then
			echo "Syncing $SYNC_NAME"
		else
			echo "Syncing ${SOURCE_DIR} to ${TARGET_DIR}"
		fi
		rsync -rtvu --delete --exclude="$EXCLUDES" "${SOURCE_DIR}" "${TARGET_DIR}"
	else
		echo "${TARGET_DIR} not found"
	fi
}

# Checking if connected to the NAS
if ping -q -c 1 -W 1 $HOST >/dev/null; 
then	
	echo "$HOST online, checking if mounted"
	
	# Checking if the path to NAS exists, i.e. if it's mounted
	if [ -d "${DIR_ON_HOST}/Downloads" ] 
	then
		    echo "NAS mounted" 
	else
		    echo "NAS not mounted. Exiting. Automatic mounting WIP"
			exit 1
	fi
	
	# Running rsync
	echo "Running rsync"
	
	if [[ $ENABLE_DOCS = true ]]
	then
		rsync_local_to_host "${DOC_LOCAL}" "${DOC_ON_HOST}" "Documents"
	fi
	
	if [[ $ENABLE_PROJ = true ]]
	then
		rsync_local_to_host "${PROJ_LOCAL}" "${PROJ_ON_HOST}" "Projects"
	fi

	if [[ $ENABLE_PICS = true ]]
	then
		rsync_local_to_host "${PICS_LOCAL}" "${PICS_ON_HOST}" "Pictures" "${PICS_EXCLUDE}"
	fi
	
else
	# Quitting if not host not found online
	echo "$HOST not Found, can't sync. Quitting."
	exit 1
fi