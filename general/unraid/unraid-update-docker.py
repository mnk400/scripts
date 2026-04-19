#!/usr/bin/env python3
# Description: Update all Docker containers on UnRaid server via the Unraid API

import sys
sys.path.insert(0, sys.path[0] or ".")

from lib.api import graphql, get_containers, container_name, GRAPHQL_URL

print(f"Checking for Docker container updates on {GRAPHQL_URL}...")

containers = get_containers("names isUpdateAvailable state")
needs_update = [c for c in containers if c["isUpdateAvailable"]]

if not needs_update:
    print("All containers are up to date.")
    sys.exit(0)

print("Containers with updates available:")
for c in needs_update:
    print(f"  {container_name(c)} ({c['state'].lower()})")

print(f"\nUpdating {len(needs_update)} container(s)...")

result = graphql("mutation { docker { updateAllContainers { names state } } }")
updated = result["docker"]["updateAllContainers"]

print(f"Updated {len(updated)} container(s):")
for c in updated:
    print(f"  {container_name(c)} -> {c['state'].lower()}")
