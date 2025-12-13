#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Network
# @raycast.mode inline
# @raycast.refreshTime disabled

# Optional parameters:
# @raycast.icon ../icons/network.png

# @Documentation:
# @raycast.packageName System
# @raycast.description Get current network stats.
# @raycast.author Manik

function get_wifi_ssid () {
  ssid=$(get-ssid 2>/dev/null)
  echo "$ssid"
}

function get_internet_status () {
  if ! ping -q -c 1 -W 1 google.com &>/dev/null; then
    echo " (No Internet)"
  fi
}

current_device=$(route get default 2>/dev/null | grep "interface" | awk '{print $2}')

if [ -z "$current_device" ]; then
  echo "No connection"
  exit 0;
fi

service_info=$(networksetup -listnetworkserviceorder | grep "$current_device")
service_name=$(echo "$service_info" | awk -F  "(, )|(: )|[)]" '{print $2}')
wifi_ssid=$(get_wifi_ssid)
lan_ip=$(ifconfig -l | xargs -n1 ipconfig getifaddr)
network_status=""

if grep -q "USB" <<< "$service_name"; then
  network_status+="Ethernet"
  network_status+=$(get_internet_status)
  if [ -n "$wifi_ssid" ]; then
    network_status+=" | $wifi_ssid"
  fi
elif grep -q "Wi-Fi" <<< "$service_name"; then
  network_status+="$wifi_ssid"
  network_status+=$(get_internet_status)
elif [ ! -z $wifi_ssid ]; then
  network_status+="$wifi_ssid"
  network_status+=$(get_internet_status)
fi

network_status+=" • $lan_ip"

echo "$network_status"
