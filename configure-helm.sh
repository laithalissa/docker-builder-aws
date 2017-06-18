#!/bin/bash

set -eo pipefail

echo "generating ~/.kube/config..."

export KUBE_CLUSTER_OPTIONS=--certificate-authority="$KUBE_CA_PEM_FILE"

kubectl config set-cluster kube-cluster --server="$KUBE_URL" $KUBE_CLUSTER_OPTIONS
kubectl config set-credentials kube-user --token="$KUBE_TOKEN" $KUBE_CLUSTER_OPTIONS
kubectl config set-context kube-cluster --cluster=kube-cluster --user kube-user --namespace="$KUBE_NAMESPACE"
kubectl config use-context kube-cluster

echo "setting up helm..."

SSL_CA_BUNDLE_FILE=/etc/ssl/certs/ca-certificates.crt
HELM_CERT_LOCATION=/usr/local/certificates
export HELM_REPO_CRT_FILE=$HELM_CERT_LOCATION/client.crt
export HELM_REPO_KEY_FILE=$HELM_CERT_LOCATION/client.key

mkdir -p $HELM_CERT_LOCATION
echo $HELM_REPO_CRT | base64 -d > $HELM_REPO_CRT_FILE
echo $HELM_REPO_KEY | base64 -d > $HELM_REPO_KEY_FILE

helm init --client-only
helm repo add helmet $HELM_REPO_URL/charts/ --ca-file $SSL_CA_BUNDLE_FILE --cert-file $HELM_REPO_CRT_FILE --key-file $HELM_REPO_KEY_FILE

echo ""
