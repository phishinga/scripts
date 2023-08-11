# Get pods from all namespaces

for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
    echo "Namespace: $ns"
    for pod in $(kubectl get pods -n $ns -o jsonpath='{.items[*].metadata.name}'); do
        kubectl get pod $pod -n $ns -o yaml > ${ns}_${pod}.yaml
        echo "Pod: $pod"
    done
done
