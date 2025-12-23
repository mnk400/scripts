#!/bin/bash
# Description: Mount NAS to local filesystem

source output.sh

CONFIG_HOST="box.local"
CONFIG_NAS_VOLUME="/Volumes/Lily"
CONFIG_ALIAS_PATH="/Users/manik/.config/Lily"

mount_nas() {
    info "Checking if NAS is online..."

    if ! ping -q -c 1 -W 1 "${CONFIG_HOST}" >/dev/null; then
        error "NAS (${CONFIG_HOST}) is not reachable"
        return 1
    fi

    success "$CONFIG_HOST is online"

    if [[ -d "${CONFIG_NAS_VOLUME}" ]]; then
        info "$CONFIG_HOST already mounted at ${CONFIG_NAS_VOLUME}"
        return 0
    fi

    if [[ ! -f "${CONFIG_ALIAS_PATH}" ]]; then
        error "Alias not found at ${CONFIG_ALIAS_PATH}"
        error "Please create an alias to $CONFIG_HOST drive and place it there"
        return 1
    fi

    info "Opening alias to trigger automatic mounting..."
    osascript -e "tell application \"Finder\"
        open file (POSIX file \"${CONFIG_ALIAS_PATH}\" as alias)
        close front window
    end tell"

    if [[ -d "${CONFIG_NAS_VOLUME}" ]]; then
        success "NAS mounted successfully at ${CONFIG_NAS_VOLUME}"
        return 0
    else
        error "Failed to mount NAS after 10 seconds"
        return 1
    fi
}

main() {
    mount_nas
}

main "$@"
