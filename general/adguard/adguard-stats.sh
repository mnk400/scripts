#!/bin/bash
# Description: Show AdGuard Home statistics

source output.sh

# AdGuard Home Configuration
ADGUARD_IP="${ADGUARD_IP:-192.168.0.25}"
ADGUARD_PORT="${ADGUARD_PORT:-3001}"
ADGUARD_USER="${ADGUARD_USER:-admin}"
ADGUARD_PASS="${ADGUARD_PASS:-password}"

AUTH=$(echo -n "$ADGUARD_USER:$ADGUARD_PASS" | base64)

# Get stats
stats=$(curl -s -H "Authorization: Basic $AUTH" \
    "http://$ADGUARD_IP:$ADGUARD_PORT/control/stats")

if [ $? -ne 0 ] || [ -z "$stats" ]; then
    echo "✗ Failed to fetch AdGuard stats"
    exit 1
fi

# Parse and display stats
fancy "📊 AdGuard Home Statistics"
echo "$stats" | jq -r '
"Total Queries: " + (.num_dns_queries | tostring) +
"\nBlocked Queries: " + (.num_blocked_filtering | tostring) +
"\nBlocked %: " + ((.num_blocked_filtering / .num_dns_queries * 100) | floor | tostring) + "%" +
"\nAvg Processing Time: " + (.avg_processing_time | tostring) + "ms"
'

echo ""
echo "Top Clients (Total Queries)"
echo "$stats" | jq -r '.top_clients[0:5] | .[] | to_entries | .[] | "  " + .key + ": " + (.value | tostring)'

echo ""
echo "Top Blocked Domains"
echo "$stats" | jq -r '.top_blocked_domains[0:5] | .[] | to_entries | .[] | "  " + .key + ": " + (.value | tostring)'

# Get protection status
status=$(curl -s -H "Authorization: Basic $AUTH" \
    "http://$ADGUARD_IP:$ADGUARD_PORT/control/status")

protection_enabled=$(echo "$status" | jq -r '.protection_enabled')
echo ""
if [ "$protection_enabled" = "true" ]; then
    success "Protection: ENABLED"
else
    warning "Protection: DISABLED"
fi
