
#Use the kubectl get pods command to get a list of all Pods running in your cluster and the --output=json flag to output the Pod specifications in JSON format. 
#You can then use a tool like jq to filter the output and find the containers with runAsNonRoot set to true and a non-root runAsUser. 
#
#For example in bash:


kubectl get pods --output=json | jq '.items[].spec.containers[] | select(.securityContext.runAsNonRoot == true and .securityContext.runAsUser != 0)'

#For example in PowerShell:

kubectl get pods --output=json | ConvertFrom-Json | Select-Object -ExpandProperty items | Foreach-Object {
    $_.spec.containers | Where-Object { $_.securityContext.runAsNonRoot -eq $true -and $_.securityContext.runAsUser -ne 0 }
}


#If you want to specifically check if DynamicUsers is being used in your AKS environment, 
# you can look for containers with a non-root UID (i.e., UID other than 0) running inside the pods. 
# You can do this using the following command:


kubectl get pods --output=json | ConvertFrom-Json | Select-Object -ExpandProperty items | Foreach-Object {
    $_.spec.containers | Where-Object { $_.securityContext.runAsNonRoot -eq $true -and $_.securityContext.runAsUser -ne 0 }
}

