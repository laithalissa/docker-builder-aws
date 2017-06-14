#!/bin/bash

set -eo pipefail

echo "Generating ~/.kube/config..."

export KUBE_CLUSTER_OPTIONS=--certificate-authority="$KUBE_CA_PEM_FILE"

kubectl config set-cluster kube-cluster --server="$KUBE_URL" $KUBE_CLUSTER_OPTIONS
kubectl config set-credentials kube-user --token="$KUBE_TOKEN" $KUBE_CLUSTER_OPTIONS
kubectl config set-context kube-cluster --cluster=kube-cluster --user kube-user --namespace="$KUBE_NAMESPACE"
kubectl config use-context kube-cluster

echo ""
