# Set the list of namespaces
$namespaces = @("azure-vote", "big-monolith", "default", "kube-system", "secure-middleware")

# Loop through each namespace and pod to get the container name and user ID
foreach ($ns in $namespaces) {
    # Get the pods and containers in the namespace
    $pods = kubectl get pods -n $ns -o jsonpath='{range .items[*]}{"NAMESPACE:"}{.metadata.namespace}{",PODNAME:"}{.metadata.name}{",CONTAINERNAME:"}{range .spec.containers[*]}{.name}{","}{end}{end}{"\n"}'

    # Loop through each container in the pod and execute the "id" command
    $pods | ForEach-Object {
        # Split the pod info into separate variables
        $namespace, $pod, $containers = $_ -split ",", 3
        # Split the container names into an array
        $containerNames = $containers -split ","

        # Loop through each container and execute the "id" command
        foreach ($container in $containerNames) {
            Write-Host "Namespace: $namespace - Pod: $pod - Container: $container"
            kubectl exec -n $namespace $pod -c $container -- sh -c "id"
        }
    }
}



# Read the list from the file
$list = Get-Content -Path "path/to/list.txt"

# Loop through each line in the list
foreach ($line in $list) {
    # Split the line into separate variables
    $namespace = ($line -split ",")[0].Split(":")[1]
    $pod = ($line -split ",")[1].Split(":")[1]
    $container = ($line -split ",")[2].Split(":")[1]

    # Execute the command
    kubectl exec -n $namespace $pod -c $container -- sh -c "id"
}
