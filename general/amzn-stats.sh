#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Status
# @raycast.mode inline
# @raycast.refreshTime 20m

# Optional parameter
# @raycast.icon ../icons/sidewaysup.png

# @Documentation:
# @raycast.description Get status around AMZN
# @raycast.author Manik

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

function get_stock_stat() {
    stock=$(curl -s "https://finnhub.io/api/v1/quote?symbol=$1&token=crvg291r01qkji45k0igcrvg291r01qkji45k0j0")

    last_close=$(echo ${stock} | jq -r ".o")
    current=$(echo ${stock} | jq -r ".c")

    change=0
    change_symbol="↓"
    color=${RED}

    change=$(echo "(${current} - ${last_close})*100/${last_close}" | bc -l)
    change=$(printf %.2f ${change})

    if [  $(echo "${change} < 0" | bc -l) -eq 0 ]; then
        change_symbol="↑"
        color=${GREEN}
    fi

    echo -e "$1: ${current} ${change_symbol} ${change}%"
}

amzn=$(get_stock_stat "AMZN")

echo -e "${amzn}"
