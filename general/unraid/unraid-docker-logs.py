#!/usr/bin/env python3
# Description: Tail Docker container logs on UnRaid server via the Unraid API
# Usage: unraid-docker-logs.py <container-name> [--lines N]

import sys
import time
sys.path.insert(0, sys.path[0] or ".")

from lib.api import graphql, find_container, get_containers, container_name

POLL_INTERVAL = 2


def fetch_logs(container_id, tail=None, since=None):
    args = [f'id: "{container_id}"']
    if tail is not None:
        args.append(f"tail: {tail}")
    if since is not None:
        args.append(f'since: "{since}"')
    query = f'{{ docker {{ logs({", ".join(args)}) {{ lines {{ timestamp message }} cursor }} }} }}'
    return graphql(query)["docker"]["logs"]


def print_lines(lines):
    for line in lines:
        ts = line["timestamp"][:19].replace("T", " ")
        print(f"{ts}  {line['message']}", flush=True)


def usage():
    print("Usage: unraid-docker-logs.py <container-name> [--lines N]")
    print("")
    print("Tails Docker container logs. Press Ctrl+C to stop.")
    print("")
    print("Options:")
    print("  --lines N    Number of initial lines to show (default: 50)")
    sys.exit(1)


def main():
    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        usage()

    name = None
    tail = 50

    i = 0
    while i < len(args):
        if args[i] == "--lines" and i + 1 < len(args):
            tail = int(args[i + 1])
            i += 2
        elif not name:
            name = args[i]
            i += 1
        else:
            usage()

    container = find_container(name)
    if not container:
        print(f"Error: No container matching '{name}'")
        print("\nAvailable containers:")
        for c in get_containers("names state"):
            print(f"  {container_name(c)} ({c['state'].lower()})")
        sys.exit(1)

    cname = container_name(container)
    print(f"Tailing {cname} ({container['state'].lower()})... Ctrl+C to stop\n", flush=True)

    logs = fetch_logs(container["id"], tail=tail)
    print_lines(logs["lines"])
    cursor = logs["cursor"]
    last_seen = {(l["timestamp"], l["message"]) for l in logs["lines"][-10:]} if logs["lines"] else set()

    try:
        while True:
            time.sleep(POLL_INTERVAL)
            logs = fetch_logs(container["id"], since=cursor)
            new_lines = [l for l in logs["lines"] if (l["timestamp"], l["message"]) not in last_seen]
            if new_lines:
                print_lines(new_lines)
            if logs["cursor"]:
                cursor = logs["cursor"]
            last_seen = {(l["timestamp"], l["message"]) for l in logs["lines"][-10:]} if logs["lines"] else set()
    except KeyboardInterrupt:
        print()


if __name__ == "__main__":
    main()
