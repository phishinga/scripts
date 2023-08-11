#
# ###############   PHISHINGA.COM  ###################
#                                                    #
#    Script that checks if K8S containers            #
#    are running under root                          #
#    Uses kubectl                                    #
#                                                    #
#  ###################################################
#  
#  Motivation:
#  Running Kubernetes containers as root can lead to security vulnerabilities and malicious attacks, 
#  as well as unintended changes to the host system. It's best to avoid running containers 
#  as root and use a non-root user with minimal privileges instead.
#
#  What does it do:
#  This script retrieves a JSON output of all pods in a Kubernetes cluster and checks 
#  if any of the containers are running as root by examining their security context. 
#  It then outputs the namespace, pod name, container name, and whether it's running as root or not.
#



$json_output = kubectl get pods --all-namespaces -o json | ConvertFrom-Json

Write-Host "Found $($json_output.items.Count) pods."

$json_output.items | ForEach-Object {
    $ns = $_.metadata.namespace
    $pod_name = $_.metadata.name

    foreach ($container in $_.spec.containers) {
        $container_name = $container.name
        $uid = $null

        # Check if the container is running before executing commands
        $container_status = $_.status.containerStatuses | Where-Object { $_.name -eq $container_name } | Select-Object -ExpandProperty state | Where-Object { $_.running } | Select-Object -First 1

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
