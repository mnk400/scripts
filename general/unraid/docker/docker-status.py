#!/usr/bin/env python3
# Description: List Docker containers and their current status on the configured Unraid server

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR.parent))

from lib.api import get_containers, container_name, GRAPHQL_URL

containers = get_containers("names state isUpdateAvailable")

print(f"Docker containers on {GRAPHQL_URL}:")

if not containers:
    print("No containers found.")
    sys.exit(0)

for c in sorted(containers, key=container_name):
    update_flag = " update-available" if c["isUpdateAvailable"] else ""
    print(f"  {container_name(c)} ({c['state'].lower()}){update_flag}")
