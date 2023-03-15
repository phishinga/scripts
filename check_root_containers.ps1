# Set the AKS cluster context
kubectl config use-context <AKS_CLUSTER_NAME>

# Get a list of all namespaces in the cluster
$namespaces = kubectl get namespaces -o json | ConvertFrom-Json
$namespaceNames = $namespaces.items.metadata.name

# Loop through all namespaces and check whether all containers are running as non-root users
foreach ($ns in $namespaceNames) {
    $pods = kubectl get pods -n $ns -o json | ConvertFrom-Json
    foreach ($pod in $pods.items) {
        foreach ($container in $pod.spec.containers) {
            $securityContext = $container.securityContext
            if ($securityContext) {
                if ($securityContext.runAsNonRoot -ne $true) {
                    Write-Host "Container '$($container.name)' in pod '$($pod.metadata.name)' in namespace '$ns' is running as root."
                }
            } else {
                Write-Host "No security context set for container '$($container.name)' in pod '$($pod.metadata.name)' in namespace '$ns'."
            }
        }
    }
}



=========

# Set the AKS cluster context
kubectl config use-context <AKS_CLUSTER_NAME> | Write-Host

# Get a list of all namespaces in the cluster
$namespaces = kubectl get namespaces -o json | ConvertFrom-Json
$namespaceNames = $namespaces.items.metadata.name

# Loop through all namespaces and check whether all containers are running as non-root users
foreach ($ns in $namespaceNames) {
    Write-Host "Checking namespace: $ns"
    $pods = kubectl get pods -n $ns -o json | ConvertFrom-Json
    foreach ($pod in $pods.items) {
        foreach ($container in $pod.spec.containers) {
            $securityContext = $container.securityContext
            if ($securityContext) {
                if ($securityContext.runAsNonRoot -ne $true) {
                    Write-Host "Container '$($container.name)' in pod '$($pod.metadata.name)' in namespace '$ns' is running as root."
                    kubectl describe pod $($pod.metadata.name) -n $ns | Write-Host
                }
            } else {
                Write-Host "No security context set for container '$($container.name)' in pod '$($pod.metadata.name)' in namespace '$ns'."
            }
        }
    }
}
