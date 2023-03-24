$json_output = kubectl get pods --all-namespaces -o json | ConvertFrom-Json | Where-Object { $_.status.phase -eq "Running" }

Write-Host "Found $($json_output.items.Count) running pods."

foreach ($item in $json_output.items) {
    $ns = $item.metadata.namespace
    $pod_name = $item.metadata.name

    foreach ($container in $item.spec.containers) {
        $container_name = $container.name
        $uid = $null

        # Check if the container is running before executing commands
        $container_status = (kubectl get pod $pod_name -n $ns -o jsonpath="{.status.containerStatuses[?(@.name=='$container_name')].state.running}")

        if ($container_status) {
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

            if ($uid) {
                # Determine if the container is running as root
                $runningAsRoot = $uid -eq "0"

                Write-Host "Namespace: $ns - Pod: $pod_name - Container: $container_name - Running as root: $runningAsRoot - id output: $id_output - busybox id output: $busybox_id_output"
            } else {
                Write-Host "Namespace: $ns - Pod: $pod_name - Container: $container_name - Error executing 'id' and 'busybox id' commands: id output: $id_output, busybox id output: $busybox_id_output"
            }
        }
    }
}
