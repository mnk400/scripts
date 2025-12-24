# ----------------------------------------------------
# Output Library - Common output functions for scripts
# ----------------------------------------------------

# Color codes for output
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_RED="\033[0;31m"
COLOR_BLUE="\033[0;34m"
COLOR_RESET="\033[0m"

# -----------------------------------------------
# Loading animation
# -----------------------------------------------

show_loading() {
    local message="${1:-Loading}"
    local pid=$2
    local delay=0.1
    local spinstr='|/-\'

    echo -n "$message "
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "[%c]" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b"
    done
    printf "   \b\b\b"
}

start_loading() {
    local message="${1:-Loading}"
    echo -n "$message "

    # Start background spinner
    (
        local delay=0.1
        local spinstr='|/-\'
        while true; do
            local temp=${spinstr#?}
            printf "[%c]" "$spinstr"
            local spinstr=$temp${spinstr%"$temp"}
            sleep $delay
            printf "\b\b\b"
        done
    ) &

    echo $! > /tmp/loading_pid
}

stop_loading() {
    local success_msg="${1}"

    if [ -f /tmp/loading_pid ]; then
        local pid=$(cat /tmp/loading_pid)
        kill $pid 2>/dev/null
        wait $pid 2>/dev/null
        rm -f /tmp/loading_pid
    fi

    printf "   \b\b\b$success_msg\n"
}

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

fancy() {
    if [ $# -eq 0 ]; then
        lines=()
        while IFS= read -r line; do
            lines+=("$line")
        done
    else
        IFS=$'\n' lines=($*)
    fi

    max_len=0
    for line in "${lines[@]}"; do
        [ ${#line} -gt $max_len ] && max_len=${#line}
    done

    printf "╭%*s╮\n" $((max_len+2)) "" | tr ' ' '─'
    for line in "${lines[@]}"; do
        printf "│ %-*s │\n" $max_len "$line"
    done
    printf "╰%*s╯\n" $((max_len+2)) "" | tr ' ' '─'
}
