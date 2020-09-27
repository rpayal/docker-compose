#!/bin/sh

# Create namespaces
kubectl create ns app-ns
kubectl create ns logging-ns

# Install Elasticsearch using helm
#helm repo add elastic https://helm.elastic.co
#helm install elasticsearch elastic/elasticsearch -f elastic-values.yml --namespace logging-ns
kubectl create -f elastic-headless-service.yml -n logging-ns
kubectl create -f elastic-statefulset.yml -n logging-ns

# Deploy Kibana using Helm with the overridden configuration
#helm install kibana elastic/kibana -f kibana-values.yml --namespace logging-ns
kubectl create -f kibana.yml -n logging-ns

# Deploy Fluentd
kubectl create -f fluentd.yml -n logging-ns

# Deploy Redis-DB pod and service
kubectl create -f db-pod.yml -n app-ns
kubectl create -f db-svc.yml -n app-ns

# Deploy python and website (PHP) app
kubectl create -f web-pods.yml -n app-ns
kubectl create -f web-svcs.yml -n app-ns

# Deploy ReplicationController
kubectl create -f web-rc.yml -n app-ns

# Call post installation script
sh post-install.sh
