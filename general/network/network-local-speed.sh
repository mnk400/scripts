#!/bin/bash
# Description Test local network bandwidth speed using iPerf

SERVER="root@box.local"
HOST="box.local"

source output.sh

fancy "Network Speed Test - Local ($HOST)"
start_loading "Testing"

# Start iperf3 server on remote host
ssh "$SERVER" "pkill iperf3; iperf3 -s -D" 2>/dev/null

if [ $? -ne 0 ]; then
    stop_loading "✗"
    error "Failed to start server on $HOST"
    exit 1
fi

sleep 1

# Run iperf3 client test
result=$(iperf3 -c "$HOST" -t 5 -f M 2>/dev/null)

if [ $? -eq 0 ]; then
    sender_mbytes=$(echo "$result" | grep "sender" | awk '{print $7}')
    receiver_mbytes=$(echo "$result" | grep "receiver" | awk '{print $7}')

    sender_mbps=$(echo "$sender_mbytes * 8" | bc -l | awk '{printf "%.1f", $1}')
    receiver_mbps=$(echo "$receiver_mbytes * 8" | bc -l | awk '{printf "%.1f", $1}')

    stop_loading
    echo "Results:"
    echo "  Transfer: ${sender_mbps} Mbps"
    echo "  Received: ${receiver_mbps} Mbps"
else
    stop_loading
    error "Failed to test local network speed"
    ssh "$SERVER" "pkill iperf3" 2>/dev/null
    exit 1
fi

# Cleanup
ssh "$SERVER" "pkill iperf3" 2>/dev/null
