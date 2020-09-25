#!/bin/sh

# Create namespaces
kubectl create ns app-ns
kubectl create ns logging-ns

# Install Elasticsearch using helm
helm repo add elastic https://helm.elastic.co
helm install --name elasticsearch elastic/elasticsearch -f elastic-values.yml --namespace logging-ns
#helm install --name elasticsearch stable/elasticsearch --namespace logging-ns

# Deploy Kibana using Helm with the overridden configuration
helm install --name kibana stable/kibana -f kibana-values.yml --namespace logging-ns

# Deploy Fluentd
kubectl apply -f fluentd.yml -n logging-ns

# Deploy Redis-DB pod and service
kubectl create -f db-pod.yml -n app-ns
kubectl create -f db-svc.yml -n app-ns

# Deploy python and website (PHP) app
kubectl create -f web-pods.yml -n app-ns
kubectl create -f web-svcs.yml -n app-ns

# Deploy ReplicationController
kubectl create -f web-rc.yml -n app-ns

