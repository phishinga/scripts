# Get JSON output for all the pods
$json_output = kubectl get pods --all-namespaces -o json | ConvertFrom-Json

# Iterate through each pod and container, execute the 'id', 'getent passwd', or 'whoami' command inside the container and check if the container is running as root or Administrator
foreach ($item in $json_output.items) {
    $ns = $item.metadata.namespace
    $pod_name = $item.metadata.name

    foreach ($container in $item.spec.containers) {
        $container_name = $container.name
        $uid = $null

        # Try executing the 'id' command for Linux containers
        $id_output = kubectl exec -n $ns $pod_name -c $container_name -- sh -c "id" 2>&1

        if ($LASTEXITCODE -eq 0) {
            # Parse the 'uid' value from the output
            $uid = [regex]::match($id_output, 'uid=(\d+)').Groups[1].Value
        }

        if (!$uid) {
            # Try executing the 'busybox id' command for containers with BusyBox
            $busybox_id_output = kubectl exec -n $ns $pod_name -c $container_name -- sh -c "busybox id" 2>&1

            if ($LASTEXITCODE -eq 0) {
                # Parse the 'uid' value from the output
                $uid = [regex]::match($busybox_id_output, 'uid=(\d+)').Groups[1].Value
            }
        }

        if (!$uid) {
            # Try executing the 'getent passwd' command for Alpine-based Linux containers
            $getent_output = kubectl exec -n $ns $pod_name -c $container_name -- sh -c "getent passwd $(whoami)" 2>&1

            if ($LASTEXITCODE -eq 0) {
                # Parse the 'uid' value from the output
                $uid = [regex]::match($getent_output, 'x:(\d+):').Groups[1].Value
            }
        }

        if ($uid) {
            # Determine if the container is running as root
            $runningAsRoot = $uid -eq "0"

            Write-Host "Namespace: $ns - Pod: $pod_name - Container: $container_name - Running as root: $runningAsRoot"
        } else {
            Write-Host "Namespace: $ns - Pod: $pod_name - Container: $container_name - Error executing 'id', 'busybox id', and 'getent passwd' commands: id output: $id_output, busybox id output: $busybox_id_output, getent passwd output: $getent_output"
        }
    }
}
