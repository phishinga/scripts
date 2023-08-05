#!/bin/bash

echo ""
echo "###############   PHISHINGA.COM  ###################"
echo "#                                                  #"
echo "#  Script that do simple echo based on response    #" 
echo "#                                                  #"
echo "####################################################"
echo ""

for i in {1..20}; do
  response=$(curl --write-out %{http_code} --silent --output /dev/null http://emphonic.com)
  
  if [ $response -eq 200 ]; then
    echo "$(date +'%T') : Iteration $i: The website is up and running. Response code: $response"
  elif [ $response -eq 404 ]; then
    echo "$(date +'%T') : Iteration $i: The page was not found. Response code: $response"
  elif [ $response -eq 429 ]; then
    echo "$(date +'%T') : Iteration $i: Rate limit is exceeded. Response code: $response"
  else
    echo "$(date +'%T') : Iteration $i: An unexpected response was received. Response code: $response"
  fi
  
  sleep 1
done
