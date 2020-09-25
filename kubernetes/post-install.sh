#!/bin/sh

# Display overall system state for app and logging namespaces
kubectl get services -n app-ns
kubectl get services -n logging-ns

# Get NodePort for website service
NODE_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services webaite-v1-website-service --namespace website)
# Get external IP address for node (assumes single node).
NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="ExternalIP")].address }')
# If there is no ExternalIP, assume localhost
echo "Access website app at http://${NODE_IP:-"localhost"}:${NODE_PORT}/"