# Get JSON output for all the pods
$json_output = kubectl get pods --all-namespaces -o json | ConvertFrom-Json

# Iterate through each pod and container, execute the 'id' command inside the container and check if the container is running as root
foreach ($item in $json_output.items) {
    $ns = $item.metadata.namespace
    $pod_name = $item.metadata.name
    
    foreach ($container in $item.spec.containers) {
        $container_name = $container.name

        # Execute the 'id' command inside the container
        $id_output = kubectl exec -n $ns $pod_name -c $container_name -- sh -c "id" 2>&1

        # Check if the 'id' command succeeded
        if ($LASTEXITCODE -eq 0) {
            # Parse the 'uid' value from the output
            $uid = [regex]::match($id_output, 'uid=(\d+)').Groups[1].Value

            # Determine if the container is running as root
            $runningAsRoot = $uid -eq "0"

            Write-Host "Namespace: $ns - Pod: $pod_name - Container: $container_name - Running as root: $runningAsRoot"
        } else {
            Write-Host "Namespace: $ns - Pod: $pod_name - Container: $container_name
