#!/bin/bash
# Documentation Internet Speed Test

source output.sh

fancy "Network Speed Test - Internet"
start_loading "Testing"

result=$(networkQuality)

if [ $? -eq 0 ]; then
    rtt=$(echo "$result" | grep "Idle Latency" | awk '{printf "%.1f",$3}')
    mbps_down=$(echo "$result" | grep "Downlink capacity" | awk '{printf "%.1f", $3}')
    mbps_up=$(echo "$result" | grep "Uplink capacity" | awk '{printf "%.1f", $3}')

    stop_loading
    echo ""
    echo "Results:"
    echo "  Download: ${mbps_down} Mbps"
    echo "  Upload:   ${mbps_up} Mbps"
    echo "  Latency:  ${rtt} ms"
else
    stop_loading
    error "Failed to test internet speed"
    exit 1
fi
