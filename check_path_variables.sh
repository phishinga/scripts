#!/bin/bash

echo ""
echo "###############   PHISHINGA.COM  ###################"
echo "#                                                  #"
echo "#  Script that checks the writable root PATH       #" 
echo "#                                                  #"
echo "#  for the current user                            #"
echo "#                                                  #"
echo "####################################################"
echo ""

echo "Motivation:
Linux Privilege Escalation using PATH Variable manipulation.
PATH is an environmental variable that defines all bin and sbin directories 
where executable applications are stored. When a user executes any command, 
Unix will look in these folders for executables with the same name as the command."

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

echo "Checking PATH variables:"
echo $PATH
echo ""

# Split the PATH variable into an array
IFS=':' read -ra dirs <<< "$PATH"

# Iterate over each directory in the array
for dir in "${dirs[@]}"; do
  # Check if the current user has write access to the directory
  if [ -w "$dir" ]; then
    # Print the directory if the user has write access
    echo -e ${red}"BOOM BABY - Write permission to $dir is writable for user $user!!!${clear}!"
  else
    # Print an error message if the user does not have write access
    echo "No Write permission to $dir" for user $user
  fi
done

echo ""
echo ""
