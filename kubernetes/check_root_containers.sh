#!/bin/bash

# Print script header
cat << EOF

###############   PHISHINGA.COM  ###################
#                                                  #
#  Script that checks if K8S containers            #
#  are running under root                          #
#  Uses kubectl                                    #
#                                                  #
####################################################
  
Motivation:
Running Kubernetes containers as root can lead to security vulnerabilities and malicious attacks, 
as well as unintended changes to the host system. It's best to avoid running containers 
as root and use a non-root user with minimal privileges instead.

What does it do:
This script retrieves a JSON output of all pods in a Kubernetes cluster and checks 
if any of the containers are running as root by examining their security context. 
It then outputs the namespace, pod name, container name, and whether it's running as root or not.
  
EOF

# Exit immediately if any command fails
set -e

# Get JSON output for all the pods
json_output=$(kubectl get pods --all-namespaces -o json)

# Iterate through each pod and container, check if the container is running as root using the security context
echo "$json_output" | jq -r '.items[] | {ns: .metadata.namespace, pod: .metadata.name, containers: .spec.containers[]} | "Namespace: \(.ns) - Pod: \(.pod) - Container: \(.containers.name) - Running as root: \(.containers.securityContext.runAsUser == 0 or .containers.securityContext.runAsUser == null)"'
