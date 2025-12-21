#!/bin/bash
# ------------------------------------------------
# NAS Sync Script - Syncs local directories to NAS
# ------------------------------------------------

CONFIG_HOST="192.168.0.23"
CONFIG_NAS_VOLUME="/Volumes/Lily"

source output.sh

check_nas() {
    info "Checking NAS availability..."
    if ! ping -q -c 1 -W 1 "${CONFIG_HOST}" >/dev/null; then
        error "NAS (${CONFIG_HOST}) is not reachable"
        return 1
    fi
    
    success "NAS is online"
    
    if [[ ! -d "${CONFIG_NAS_VOLUME}" ]]; then
        warning "NAS not mounted. Attempting to mount..."
        if ! ./mount_nas.sh; then
            error "Failed to mount NAS automatically"
            return 1
        fi
    fi
    
    success "NAS is available"
    return 0
}

sync_directory() {
    local name=$1
    local source=$2
    local target=$3
    
    if [[ ! -d "$source" ]]; then
        warning "Source '$source' not found, skipping $name"
        return 1
    fi
    
    info "Syncing $name: $source -> $target"
    
    # cache directory helps with subsequent runs
    local cache_dir="${HOME}/.cache/rclone"
    mkdir -p "$cache_dir"
    
    rclone sync "$source" "$target" \
        --progress \
        --transfers 4 \
        --checkers 8 \
        --fast-list \
        --size-only \
        --cache-dir "$cache_dir" \
        --exclude ".DS_Store" \
        --exclude ".*" \
        --exclude "*.icloud" \
        --exclude "*/.Trash/**" \
        --exclude "*/Library/Mobile Documents/**" \
        --exclude "*/node_modules/**" \
        --exclude "*/.git/**" \
        --exclude "stable-diffusion-webui/**" \
        --exclude "Photos Library.photoslibrary/**" \
        --delete-excluded
    
    if [[ $? -eq 0 ]]; then
        success "$name sync completed"
        return 0
    else
        error "$name sync failed"
        return 1
    fi
}

show_usage() {
    # Use wrapper command name if set, otherwise default to script name
    local script_name="${NAS_WRAPPER_CMD:-syncnas.sh}"
    
    cat << EOF
Usage: ${script_name} [OPTION]

Sync directories to NAS using rclone.

Options:
  documents    Sync only cocuments folder
  projects     Sync only projects folder  
  photos       Sync only photos folder
  *            Sync documents & photos (default)
  help         Show this help

Examples:
  ${script_name}           # Sync documents & photos directories
  ${script_name} photos    # Sync only photos
EOF
}

main() {
    local start_time=$(date +%s)
    local mode="${1:-all}"
    
    case "$mode" in
        -h|--help|help)
            show_usage
            exit 0
            ;;
        documents|projects|photos)
            ;;
        *)
            error "Invalid option: $mode"
            show_usage
            exit 1
            ;;
    esac
    
    echo ""
    echo " ▄▀▀▀▀▄  ▄▀▀▄ ▀▀▄  ▄▀▀▄ ▀▄  ▄▀▄▄▄▄  "
    echo "█ █   ▐ █   ▀▄ ▄▀ █  █ █ █ █ █    ▌ "
    echo "   ▀▄   ▐     █   ▐  █  ▀█ ▐ █      "
    echo "▀▄   █        █     █   █    █      "
    echo " █▀▀▀       ▄▀    ▄▀   █    ▄▀▄▄▄▄▀ "
    echo " ▐          █     █    ▐   █     ▐  "
    echo "            ▐     ▐        ▐        "
    echo ""
    
    if ! check_nas; then
        exit 1
    fi
    
    local success_count=0
    local total_count=0
    
    if [[ "$mode" == "all" || "$mode" == "documents" ]]; then
        ((total_count++))
        sync_directory "Documents" "${HOME}/Documents/" "${CONFIG_NAS_VOLUME}/Documents/" && ((success_count++))
    fi
    
    if [[ "$mode" == "projects" ]]; then
        ((total_count++))
        sync_directory "Projects" "${HOME}/Projects/" "${CONFIG_NAS_VOLUME}/Projects/" && ((success_count++))
    fi
    
    if [[ "$mode" == "all" || "$mode" == "photos" ]]; then
        ((total_count++))
        sync_directory "Photos" "${HOME}/Pictures/" "${CONFIG_NAS_VOLUME}/Photos/Pictures/" && ((success_count++))
    fi
    
    echo ""
    if [[ $success_count -eq $total_count ]]; then
        success "All sync tasks completed ($success_count/$total_count)"
    else
        warning "Some sync tasks failed ($success_count/$total_count)"
    fi
}

main "$@"
