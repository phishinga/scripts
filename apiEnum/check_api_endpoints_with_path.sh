#!/bin/bash


echo "
###############   PHISHINGA.COM  ###################
#                                                  #
#  Script for api enumeration testing v2           #
#                                                  #
####################################################
"

echo "
This Bash script reads a list of API endpoints from a file and, 
for each endpoint, reads a list of API paths to append from another file, 
makes HTTP requests using various methods and outputs the responses. 
The responses are printed to the console with the corresponding HTTP method 
and URL.
"

# Define the name of the file that contains the API endpoints
ENDPOINTS_FILE="api_endpoints.txt"

# Define the name of the file that contains the API paths to append
PATHS_FILE="api_paths.txt"

# Define the HTTP methods to use
HTTP_METHODS=("GET" "POST" "PATCH" "OPTIONS" "LINK" "VIEW")

# Loop through each line in the endpoints file
while IFS= read -r endpoint; do

    echo -e "\n"
    echo "================================================================="

    # Loop through each line in the paths file and make requests for each HTTP method
    while IFS= read -r path; do
        url="$endpoint/$path"
        for method in "${HTTP_METHODS[@]}"; do
            echo "$method request to $url"
            curl -s -X "$method" "$url"
            echo -e "\n"
        done
    done < "$PATHS_FILE"
   
done < "$ENDPOINTS_FILE"
