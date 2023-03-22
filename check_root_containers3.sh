#!/bin/bash

# Get JSON output for all the pods
json_output=$(kubectl get pods --all-namespaces -o json)

# Iterate through each pod and container, check if the container is running as root using the security context
echo "$json_output" | jq -r '.items[] | {ns: .metadata.namespace, pod: .metadata.name, containers: .spec.containers[]} | "Namespace: \(.ns) - Pod: \(.pod) - Container: \(.containers.name) - Running as root: \(.containers.securityContext.runAsUser == 0 or .containers.securityContext.runAsUser == null)"'
