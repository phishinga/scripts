# Gets all YAML files from k8s 

# Array of resource types
$types = "deployment", "svc", "configmap", "secret", "role", "rolebinding", "networkpolicy", "PeerAuthentication", "AuthorizationPolicy"

# Get all namespaces
$namespaces = kubectl get ns -o jsonpath="{.items[*].metadata.name}" 2>$null

Write-Output GET_NAMESPACES: $namespaces

# Loop through each namespace
foreach ($namespace in $namespaces.Split(' ')) {

    # Loop through each resource type
    foreach ($type in $types) {

        # Get resources of ns & types
        $resources = kubectl get $type -n $namespace -o jsonpath="{.items[*].metadata.name}" 2>$null

        Write-Output GET_RESOURCES_PER_NAMESPACE: $resources 
        
        # Chech if resources are null before trying to access them
        if ($null -ne $resources) {  # If resources are not null then do the following:

            foreach ($resource in $resources.Split(' ')) {
                
                try {
                    kubectl get $type $resource -n $namespace -o yaml > "${namespace}_${type}_${resource}.yaml"
                } catch {
                    Write-Output "Error getting $type $resource in namespace $namespace"
                }
                 
            }

        }
        
    }

}

# PodSecurityPolicy is a non-namespaced resource, thus new step / was not working for some reason.. maybe managed by MS?
#$psps = kubectl get psp -o jsonpath="{.items[*].metadata.name}"
#foreach ($psp in $psps) {
#    kubectl get psp $psp -o yaml > "psp_${psp}.yaml"
#}

    

