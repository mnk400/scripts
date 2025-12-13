#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Local Network Speed
# @raycast.mode fullOutput
# @raycast.refreshTime disabled

# Optional parameters:
# @raycast.icon 🌐

# @Documentation:
# @raycast.packageName System
# @raycast.description Test local network bandwidth speed
# @raycast.author Manik

SERVER="root@box.local"

echo "Testing Local Network Speed to $SERVER..."
echo "=========================================="
echo ""

# Start iperf3 server on remote host
echo "Starting iperf3 server on $SERVER..."
ssh "$SERVER" "pkill iperf3; iperf3 -s -D" 2>/dev/null

sleep 1

# Run iperf3 client test
echo "Running bandwidth test..."
echo ""
iperf3 -c "box.local" -t 5 -f M

# Cleanup
ssh "$SERVER" "pkill iperf3" 2>/dev/null
