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