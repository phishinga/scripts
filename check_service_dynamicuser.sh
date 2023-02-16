#!/bin/bash

echo ""
echo "###############   PHISHINGA.COM  ###################"
echo "#                                                  #"
echo "#  Script that check if all running services       #"
echo "#  in a systemd system or SysVinit system          #"
echo "#  are configured to use DynamicUser               #" 
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

echo ""
echo -e ${blue}"Loop through all running services (if you have systemctl installed)${clear}"
echo ""
sleep 3

# Loop through all running services (if you have systemctl installed)
for service in $(systemctl list-units --type=service --state=running --no-legend | awk '{print $1}')
do
  # Check if the service is configured to use DynamicUser
  if systemctl show ${service} | grep -q '^DynamicUser=yes$'; then
    echo -e ${green}"${service} is configured to use DynamicUser"${clear}
  else
    echo "${service} is NOT configured to use DynamicUser"
  fi
done

echo ""
echo -e ${blue}"Loop through all running services in /etc/init.d/*(when systemctl is not installed)${clear}"
echo ""

# Loop through all running services (when systemctl is not installed)

for service in /etc/init.d/*
do
  if [[ -x $service && -f $service ]]; then
    if grep -q '^DynamicUser=.*' "$service"; then
      echo -e ${green}"${service} IS CONFIGURED to use DynamicUser"${clear}
    else
      echo "$service is NOT configured to use DynamicUser"
    fi
  fi
done

#
# What is happening here?
#
# The main difference between the results from systemctl and /etc/init.d is the way in which they manage services.
#
# systemctl is a tool used to control the systemd system and service manager. It is used to manage services in a 
# modern system that uses systemd. Systemd is a system and service manager for Linux, which replaces the traditional 
# System V init (SysVinit) system.
#
# On the other hand, /etc/init.d is a directory where the SysVinit system stores scripts to control the services. 
# The scripts are typically shell scripts that are executed during boot or shutdown, and can be used to start, stop, 
# restart, or check the status of a service.
#
# The way services are managed with systemctl is different from the way they are managed with /etc/init.d. systemctl 
# is more modern and provides better control and management of services. It is also more efficient and can start services 
# in parallel, which can help reduce system boot time. In contrast, /etc/init.d is older and has limitations in terms of 
# service management and control.
#