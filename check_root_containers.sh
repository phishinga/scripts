#!/bin/bash

# Get the list of pods and containers
PODS=$(kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{"NAMESPACE:"}{.metadata.namespace}{",PODNAME:"}{.metadata.name}{",CONTAINERNAMES:"}{range .spec.containers[*]}{.name}{","}{end}{"\n"}{end}')

# Loop through each pod and container and execute the "id" command
while read -r pod; do
  ns=$(echo "$pod" | cut -d',' -f1 | cut -d':' -f2)
  pod_name=$(echo "$pod" | cut -d',' -f2 | cut -d':' -f2)
  containers=$(echo "$pod" | cut -d',' -f3 | cut -d':' -f2-)

  for container in $(echo "$containers" | tr ',' ' '); do
    echo "Namespace: $ns - Pod: $pod_name - Container: $container"
    kubectl exec -n "$ns" "$pod_name" -c "$container" -- sh -c "id"
  done
done <<< "$PODS"
