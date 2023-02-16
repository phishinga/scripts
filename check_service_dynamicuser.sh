#!/bin/bash

echo ""
echo "###############   PHISHINGA.COM  ###################"
echo "#                                                  #"
echo "#  Script that check if all running services       #"
echo "#  in a systemd system are configured              #"
echo "#  to use DynamicUser                              #" 
echo "#                                                  #"
echo "####################################################"
echo ""

echo "Motivation:
DynamicUser accounts are useful for a number of reasons. 
For example, they can help improve system security by 
reducing the number of long-lived user accounts 
that could potentially be targeted by attackers. 

Additionally, DynamicUser accounts can help reduce 
the amount of disk space used by the system, 
since they are deleted when they are no longer needed.

To use DynamicUser in a systemd service or unit, 
the administrator needs to add the "DynamicUser=yes" 
option to the service file. This tells systemd to 
create a new user account for the service at runtime.
"

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

echo ""
echo -e ${blue}"LETS START ...${clear}"
echo ""
sleep 3

# Loop through all running services
for service in $(systemctl list-units --type=service --state=running --no-legend | awk '{print $1}')
do
  # Check if the service is configured to use DynamicUser
  if systemctl show ${service} | grep -q '^DynamicUser=yes$'; then
    echo -e ${green}"${service} is configured to use DynamicUser"${clear}
  else
    echo "${service} is NOT configured to use DynamicUser"
  fi
done
