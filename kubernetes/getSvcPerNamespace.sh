# Get services from all namespaces

for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
    echo "Namespace: $ns"
    for svc in $(kubectl get svc -n $ns -o jsonpath='{.items[*].metadata.name}'); do
        kubectl get svc $svc -n $ns -o yaml > ${ns}_${svc}.yaml
        echo "Service: $svc"
    done
done
