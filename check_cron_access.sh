#!/bin/bash

echo ""
echo ""
echo "###############   PHISHINGA.COM  ###################"
echo "#                                                  #"
echo "#  Script that checks write permissions for        #" 
echo "#  all cron-related files and directories          #"
echo "#  for the current user                            #"
echo "#                                                  #"
echo "####################################################"
echo ""

echo "Motivation:
When a script executed by Cron is editable by unprivileged users, 
those unprivileged users can escalate their privilege by editing this script, 
and waiting for it to be executed by Cron under root privileges."


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
echo -e ${blue}"LETS START ...${clear}!"
echo ""
sleep 3

# Cronjobs check for current user
echo "Checking Cronjobs for current user $user"
crontab -l

echo ""

# Check write permission for /etc/ directory and its files for cron*
echo "Checking /etc/ directory for cron* files."
echo ""

ls -alt /etc/ | grep cron

echo ""

for file2 in $(find /etc/*cron* -type f)
  do
    if [ -w $file2 ]
        then
            echo -e ${red}"BOOM BABY - Write permission for $file2 is enabled for $user."${clear}
        else
            echo "No Write permission for $file2 for the current user $user."
    fi
done

echo ""
echo ""

