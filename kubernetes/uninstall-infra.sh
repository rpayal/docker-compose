#!/bin/sh

# Uninstall Elasticsearch and Kibana
#helm delete elasticsearch
#helm delete kibana

# Delete Fluentd
kubectl delete -f fluentd.yml -n logging-ns

# Delete namespaces for applications
kubectl delete ns app-ns
#kubectl delete ns logging-ns
kubectl delete ns logging-ns