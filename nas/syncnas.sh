#!/bin/bash

# ------------------------------------------------
# NAS Sync Script - Syncs local directories to NAS
# ------------------------------------------------

# Default configuration
CONFIG_HOST="192.168.0.23"
CONFIG_NAS_VOLUME="/Volumes/Lily"
CONFIG_DOCUMENTS=true
CONFIG_PROJECTS=true
CONFIG_PHOTOS=true
CONFIG_PHOTOS_EXCLUDE="*Library*"
CONFIG_PROJECTS_EXCLUDE="stable-diffusion-webui"

# Color codes for output
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_RED="\033[0;31m"
COLOR_BLUE="\033[0;34m"
COLOR_RESET="\033[0m"

# -----------------------------------------------
# Output functions
# -----------------------------------------------

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${COLOR_RESET}"
}

success() {
    print_message "${COLOR_GREEN}" "$1"
}

info() {
    print_message "${COLOR_BLUE}" "$1"
}

warning() {
    print_message "${COLOR_YELLOW}" "$1"
}

error() {
    print_message "${COLOR_RED}" "$1"
}

sync_to_nas() {
    local source_dir=$1
    local target_dir=$2
    local sync_name=$3
    local excludes=$4
    
    if [[ ! -d "$source_dir" ]]; then
        warning "Source directory '$source_dir' not found. Skipping $sync_name sync."
        return 1
    fi
    
    if [[ ! -d "$target_dir" ]]; then
        warning "Target directory '$target_dir' not found. Skipping $sync_name sync."
        return 1
    fi
    
    info "Syncing $sync_name..."
    
    rsync -rtvu --delete --exclude="$excludes" --exclude=".DS_Store" --exclude=".*.*" "$source_dir" "$target_dir"
    
    if [[ $? -eq 0 ]]; then
        success "$sync_name sync completed successfully"
        return 0
    else
        error "$sync_name sync failed"
        return 1
    fi
}

check_nas_availability() {
    info "Checking if NAS is online..."
    
    if ! ping -q -c 1 -W 1 "${CONFIG_HOST}" >/dev/null; then
        error "NAS (${CONFIG_HOST}) is not online. Cannot sync."
        return 1
    fi
    
    success "NAS is online"
    info "Checking if NAS is mounted..."
    
    if [[ ! -d "${CONFIG_NAS_VOLUME}/Downloads" ]]; then
        error "NAS is not mounted. Please mount it first."
        warning "Automatic mounting is work in progress."
        return 1
    fi
    
    success "NAS is mounted"
    return 0
}

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Sync local directories to NAS.

Options:
  -h, --help              Show this help message and exit
  -d, --documents         Sync only documents
  -j, --projects          Sync only projects
  -p, --photos            Sync only photos
  --host HOST             Set NAS hostname/IP (default: ${CONFIG_HOST})
  --volume VOLUME         Set NAS volume path (default: ${CONFIG_NAS_VOLUME})
  --verbose               Show detailed output

Note: Running without options will sync all directories (documents, projects, photos)

Examples:
  $(basename "$0")                           # Sync everything (default)
  $(basename "$0") --photos                  # Sync only photos
  $(basename "$0") --documents --projects    # Sync documents and projects
  $(basename "$0") --host 192.168.1.100      # Use different NAS IP
EOF
}

# -----------------------------------------------
# Parse command line arguments
# -----------------------------------------------

parse_arguments() {
    CONFIG_DOCUMENTS=true
    CONFIG_PROJECTS=true
    CONFIG_PHOTOS=true
    
    if [[ $# -gt 0 ]]; then
        CONFIG_DOCUMENTS=false
        CONFIG_PROJECTS=false
        CONFIG_PHOTOS=false
    fi
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_usage
                exit 0
                ;;
            -d|--documents)
                CONFIG_DOCUMENTS=true
                ;;
            -j|--projects)
                CONFIG_PROJECTS=true
                ;;
            -p|--photos)
                CONFIG_PHOTOS=true
                ;;
            --host)
                shift
                CONFIG_HOST="$1"
                ;;
            --volume)
                shift
                CONFIG_NAS_VOLUME="$1"
                ;;
            --verbose)
                VERBOSE=true
                ;;
            *)
                warning "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
        shift
    done
}

main() {
    local start_time=$(date +%s)
    
    parse_arguments "$@"
    
    echo ""
    echo " ▄▀▀▀▀▄  ▄▀▀▄ ▀▀▄  ▄▀▀▄ ▀▄  ▄▀▄▄▄▄  "
    echo "█ █   ▐ █   ▀▄ ▄▀ █  █ █ █ █ █    ▌ "
    echo "   ▀▄   ▐     █   ▐  █  ▀█ ▐ █      "
    echo "▀▄   █        █     █   █    █      "
    echo " █▀▀▀       ▄▀    ▄▀   █    ▄▀▄▄▄▄▀ "
    echo " ▐          █     █    ▐   █     ▐  "
    echo "            ▐     ▐        ▐        "
    echo ""
    
    if ! check_nas_availability; then
        exit 1
    fi
    
    local doc_local="${HOME}/Documents/"
    local proj_local="${HOME}/Projects/"
    local pics_local="${HOME}/Pictures/"
    
    local doc_remote="${CONFIG_NAS_VOLUME}/Documents"
    local proj_remote="${CONFIG_NAS_VOLUME}/Projects"
    local pics_remote="${CONFIG_NAS_VOLUME}/Photos/Pictures"

    info "Starting sync process"
    
    local sync_count=0
    local success_count=0

    if [[ ${CONFIG_DOCUMENTS} == true ]]; then
        ((sync_count++))
        sync_to_nas "$doc_local" "$doc_remote" "Documents" && ((success_count++))
    fi
    
    if [[ ${CONFIG_PROJECTS} == true ]]; then
        ((sync_count++))
        sync_to_nas "$proj_local" "$proj_remote" "Projects" "${CONFIG_PROJECTS_EXCLUDE}" && ((success_count++))
    fi
    
    if [[ ${CONFIG_PHOTOS} == true ]]; then
        ((sync_count++))
        sync_to_nas "$pics_local" "$pics_remote" "Photos" "${CONFIG_PHOTOS_EXCLUDE}" && ((success_count++))
    fi
    
    # Summary
    echo ""
    if [[ $success_count -eq $sync_count ]]; then
        success "All sync operations completed successfully ($success_count/$sync_count)"
    elif [[ $success_count -eq 0 ]]; then
        error "Some errors while syncing (0/$sync_count)"
    else
        warning "Some errors while syncing ($success_count/$sync_count)"
    fi
    
    local end_time=$(date +%s)
    local elapsed_time=$((end_time - start_time))
    local minutes=$(( (elapsed_time + 59) / 60 ))
    local time_str="${minutes}m"
    
    info "Sync command completed at $(date +"%I:%M %p on %d %b") (took ${time_str})"
}

main "$@"