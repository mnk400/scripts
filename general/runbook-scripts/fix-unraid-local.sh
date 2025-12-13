#!/bin/bash
echo "Checking if box.local is reachable..."
if ping -c 1 box.local >/dev/null 2>&1; then
    echo "✓ box.local is already reachable - no fix needed"
    exit 0
fi

echo "✗ box.local not reachable - restarting Avahi daemon on UnRaid server..."
ssh root@192.168.0.23 "/etc/rc.d/rc.avahidaemon restart"

echo "Testing box.local resolution..."
if ping -c 1 box.local >/dev/null 2>&1; then
    echo "✓ Success: box.local is now resolving"
else
    echo "✗ Failed: box.local still not resolving - may need server reboot"
fi
