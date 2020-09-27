#!/bin/sh

# Uninstall Elasticsearch and Kibana
#helm delete elasticsearch -n logging-ns
#helm delete kibana -n logging-ns
kubectl delete -f elastic-headless-service.yml -n logging-ns
kubectl delete -f elastic-statefulset.yml -n logging-ns
kubectl delete -f kibana.yml -n logging-ns

# Delete Fluentd
kubectl delete -f fluentd.yml -n logging-ns

# Delete namespaces for applications
kubectl delete ns app-ns
kubectl delete ns logging-ns
