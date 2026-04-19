import json
import os
import sys
import urllib.request

GRAPHQL_URL = os.environ.get("UNRAID_API_URL")
_api_key = os.environ.get("UNRAID_API_KEY")

if not GRAPHQL_URL or not _api_key:
    missing = [v for v, val in [("UNRAID_API_URL", GRAPHQL_URL), ("UNRAID_API_KEY", _api_key)] if not val]
    print(f"Error: Set {', '.join(missing)} environment variable(s)")
    sys.exit(1)


def graphql(query):
    req = urllib.request.Request(
        GRAPHQL_URL,
        data=json.dumps({"query": query}).encode(),
        headers={
            "x-api-key": _api_key,
            "Content-Type": "application/json",
        },
    )
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read())
    if "errors" in data:
        for e in data["errors"]:
            print(f"Error: {e['message']}")
        sys.exit(1)
    return data["data"]


def get_containers(fields="id names state"):
    data = graphql(f"{{ docker {{ containers {{ {fields} }} }} }}")
    return data["docker"]["containers"]


def find_container(name):
    containers = get_containers()
    name_lower = name.lower()

    # Exact match
    for c in containers:
        for n in c["names"]:
            if n.lstrip("/").lower() == name_lower:
                return c

    # Partial match
    matches = [c for c in containers if any(name_lower in n.lstrip("/").lower() for n in c["names"])]
    if len(matches) == 1:
        return matches[0]
    if len(matches) > 1:
        print(f"Ambiguous name '{name}', matches:")
        for c in matches:
            print(f"  {c['names'][0].lstrip('/')}")
        sys.exit(1)
    return None


def container_name(container):
    return container["names"][0].lstrip("/")
