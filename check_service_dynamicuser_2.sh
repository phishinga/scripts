#!/bin/bash


user=$(whoami)

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
# Clear the color after that
clear='\033[0m'

# Examples

# echo -e "The color is: ${red}red${clear}!"
# echo -e "The color is: ${green}green${clear}!"
# echo -e "The color is: ${yellow}yellow${clear}!"
# echo -e "The color is: ${blue}blue${clear}!"
# echo -e "The color is: ${magenta}magenta${clear}!"
# echo -e "The color is: ${cyan}cyan${clear}!"


# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Check if systemctl is installed
if [ ! -x "$(command -v systemctl)" ]; then
  echo -e ${yellow}"systemctl not found, checking init.d scripts ${clear}!"
  for service in /etc/init.d/*; do
    if [[ -x "$service" ]]; then
      output=$(sudo sh -c "$service status | grep 'DynamicUser=yes'")
      if [ ! -z "$output" ]; then
        echo -e ${green}"$service IS CONFIFGURED to use DynamicUser. ${clear}!"
      else
        echo "$service is NOT configured to use DynamicUser"
      fi
    fi
  done
else
  echo -e ${yellow}"systemctl found, checking services ${clear}!"
  for service in $(systemctl list-unit-files --type=service --no-pager | awk '{print $1}' | grep '\.service$'); do
    output=$(systemctl show "$service" --property=DynamicUser | grep 'DynamicUser=yes')
    if [ ! -z "$output" ]; then
      echo -e ${green}"$service IS CONFIFGURED to use DynamicUser. ${clear}!"
    else
      echo "$service is NOT configured to use DynamicUser"
    fi
  done
fi
