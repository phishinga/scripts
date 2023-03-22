# Get JSON output for all the pods
$json_output = kubectl get pods --all-namespaces -o json | ConvertFrom-Json

# Iterate through each pod and container, check if the container is running as root using the security context
foreach ($item in $json_output.items) {
    $ns = $item.metadata.namespace
    $pod_name = $item.metadata.name
    
    foreach ($container in $item.spec.containers) {
        $container_name = $container.name
        $runAsUser = $container.securityContext.runAsUser
        $runningAsRoot = $runAsUser -eq 0
        
        Write-Host "Namespace: $ns - Pod: $pod_name - Container: $container_name - Running as root: $runningAsRoot"
    }
}
