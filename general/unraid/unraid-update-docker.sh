#!/bin/bash

echo "Triggering Docker updates on UnRaid server..."
ssh root@192.168.0.23 "
tail -f /var/log/syslog | grep --line-buffered 'Docker Auto Update' &
TAIL_PID=\$!
php /usr/local/emhttp/plugins/ca.update.applications/scripts/updateDocker.php >/dev/null 2>&1
sleep 2
kill \$TAIL_PID 2>/dev/null
"
