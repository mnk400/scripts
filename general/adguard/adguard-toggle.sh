#!/bin/bash
# Description: Toggle AdGuard Home protection on/off

# AdGuard Home Configuration
ADGUARD_IP="${ADGUARD_IP:-192.168.0.25}"
ADGUARD_PORT="${ADGUARD_PORT:-3001}"
ADGUARD_USER="${ADGUARD_USER:-admin}"
ADGUARD_PASS="${ADGUARD_PASS:-password}"

AUTH=$(echo -n "$ADGUARD_USER:$ADGUARD_PASS" | base64)

toggle_protection() {
    local enabled=$1
    local status_text=$2
    
    response=$(curl -s -w "\n%{http_code}" -X POST \
        "http://$ADGUARD_IP:$ADGUARD_PORT/control/protection" \
        -H "Content-Type: application/json" \
        -H "Authorization: Basic $AUTH" \
        -d "{\"enabled\": $enabled}")
    
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ]; then
        echo "✓ AdGuard protection $status_text"
    else
        echo "✗ Failed to $status_text AdGuard protection (HTTP $http_code)"
        exit 1
    fi
}

case "$1" in
    "on")
        toggle_protection true "enabled"
        ;;
    "off")
        toggle_protection false "disabled"
        ;;
    *)
        echo "Usage: $0 {on|off}"
        exit 1
        ;;
esac
