#!/bin/bash

echo ""
echo "###############   PHISHINGA.COM  ###################"
echo "#                                                  #"
echo "#  Script that checks the write permission for     #" 
echo "#  all cron-related files and directories          #"
echo "#  for the current user                            #"
echo "#                                                  #"
echo "####################################################"
echo ""

echo "Motivation:
When a script executed by Cron is editable by unprivileged users, those unprivileged users can escalate their privilege by editing this script, and waiting for it to be executed by Cron under root privileges."



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
crontab -l

echo ""

# Check write permission for crontab file
if [ -w /etc/cron.allow ]
then
    echo "Write permission for cron jobs is enabled for the current user."
elif [ -e /etc/cron.allow ]
then
    echo "The file /etc/cron.allow exists, but is not writable by the current user."
else
    echo "The file /etc/cron.allow does not exist."
fi

# Check write permission for crontab file
if [ -w /etc/cron.deny ]
then
    echo "Write permission for cron jobs is disabled for the current user."
elif [ -e /etc/cron.deny ]
then
    echo "The file /etc/cron.deny exists, but is not writable by the current user."
else
    echo "The file /etc/cron.deny does not exist."
fi

echo ""

# Check write permission for crontab file
if [ -w /etc/crontab ]
then
    echo "Write permission for crontab is disabled for the current user."
elif [ -e /etc/crontab ]
then
    echo "The file /etc/crontab exists, but is not writable by the current user."
else
    echo "The file /etc/crontab does not exist."
fi

# Check write permission for anacrontab file
# Anacron is defined as the cron with ability to performed the task that are skipped due to some reasons.
if [ -w /etc/anacrontab ]
then
    echo "Write permission for crontab is disabled for the current user."
elif [ -e /etc/anacrontab ]
then
    echo "The file /etc/anacrontab exists, but is not writable by the current user."
else
    echo "The file /etc/anacrontab does not exist."
fi

echo""

# Check write permission for /etc/cron.d directory and its files
if [ -e /etc/cron.d ]
then
    echo "Checking /etc/cron.d directory."
    for file in $(find /etc/cron.d -type f)
    do
        if [ -w $file ]
        then
            echo -e  ${red}"BOOM BABY - Write permission for $file is enabled for the current user."${clear}
        else
            echo "Write permission for $file is not enabled for the current user."
        fi
    done
else
    echo "Write permission for /etc/cron.d directory is not enabled for the current user."
fi

echo ""

# Check write permission for /etc/cron.daily directory and its files
if [ -e /etc/cron.daily ]
then
    echo "Checking /etc/cron.daily directory."
    for file in $(find /etc/cron.daily -type f)
    do
        if [ -w $file ]
        then
            echo -e  ${red}"BOOM BABY - Write permission for $file is enabled for the current user."${clear}
        else
            echo "Write permission for $file is not enabled for the current user."
        fi
    done
else
    echo "Write permission for /etc/cron.daily directory is not enabled for the current user."
fi

echo ""

# Check write permission for /etc/cron.weekly directory and its files
if [ -e /etc/cron.weekly ]
then
    echo "Checking /etc/cron.daily directory."
    for file in $(find /etc/cron.weekly -type f)
    do
        if [ -w $file ]
        then
            echo -e  ${red}"BOOM BABY - Write permission for $file is enabled for the current user."${clear}
        else
            echo "Write permission for $file is not enabled for the current user."
        fi
    done
else
    echo "Write permission for /etc/cron.weekly directory is not enabled for the current user."
fi

echo ""

# Check write permission for /etc/cron.monthly directory and its files
if [ -e /etc/cron.monthly ]
then
    echo "Checking /etc/cron.monthly directory."
    for file in $(find /etc/cron.monthly -type f)
    do
        if [ -w $file ]
        then
            echo -e  ${red}"BOOM BABY - Write permission for $file is enabled for the current user."${clear}
        else
            echo "Write permission for $file is not enabled for the current user."
        fi
    done
else
    echo "Write permission for /etc/cron.monthly directory is not enabled for the current user."
fi

echo ""

# Check write permission for /etc/cron.hourly directory and its files
if [ -e /etc/cron.hourly ]
then
    echo "Checking /etc/cron.daily directory."
    for file in $(find /etc/cron.hourly -type f)
    do
        if [ -w $file ]
        then
            echo -e  ${red}"BOOM BABY - Write permission for $file is enabled for the current user."${clear}
        else
            echo "Write permission for $file is not enabled for the current user."
        fi
    done
else
    echo "Write permission for /etc/cron.hourly directory is not enabled for the current user."
fi

echo ""
echo ""

