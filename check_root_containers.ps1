# Set the name of your AKS cluster
$clusterName = "<your-cluster-name>"

# Get a list of all nodes in the cluster
$nodes = kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'

# Loop through each node and check for running containers
foreach ($node in $nodes) {
    Write-Host "Checking containers on node $node..."

    # Get a list of running containers on the node
    $containers = ssh $node docker ps -q

    # Loop through each container and check if it's running as root
    foreach ($container in $containers) {
        Write-Host "Checking container $container on node $node..."
        ssh $node docker exec -it $container sh -c "if [ \$(id -u) -eq 0 ]; then echo 'Container is running as root'; else echo 'Container is not running as root'; fi"
    }
}
