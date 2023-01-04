#!/bin/bash

# Split the PATH variable into an array
IFS=':' read -ra dirs <<< "$PATH"

# Iterate over each directory in the array
for dir in "${dirs[@]}"; do
  # Check if the current user has write access to the directory
  if [ -w "$dir" ]; then
    # Print the directory if the user has write access
    echo "$dir is writable"
  else
    # Print an error message if the user does not have write access
    echo "Error: No write access to $dir"
  fi
done
