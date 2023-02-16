kubectl get pods --output=json | jq '.items[].spec.containers[] | select(.securityContext.runAsNonRoot == true and .securityContext.runAsUser != 0)'
