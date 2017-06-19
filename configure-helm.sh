#!/bin/bash

set -eo pipefail

echo "generating ~/.kube/config..."

CERTIFICATES_LOCATION=/usr/local/certificates
KUBE_CA_PEM_FILE=$CERTIFICATES_LOCATION/kube.ca.pem

mkdir -p $CERTIFICATES_LOCATION
echo $KUBE_CA_PEM | base64 -d > $KUBE_CA_PEM_FILE

KUBE_CLUSTER_OPTIONS=--certificate-authority="$KUBE_CA_PEM_FILE"

kubectl config set-cluster kube-cluster --server="$KUBE_URL" $KUBE_CLUSTER_OPTIONS
kubectl config set-credentials kube-user --token="$KUBE_TOKEN" $KUBE_CLUSTER_OPTIONS
kubectl config set-context kube-cluster --cluster=kube-cluster --user kube-user --namespace="$KUBE_NAMESPACE"
kubectl config use-context kube-cluster

echo "setting up helm..."

SSL_CA_BUNDLE_FILE=/etc/ssl/certs/ca-certificates.crt
export HELM_REPO=helmet
export HELM_REPO_CRT_FILE=$CERTIFICATES_LOCATION/client.crt
export HELM_REPO_KEY_FILE=$CERTIFICATES_LOCATION/client.key

echo $HELM_REPO_CRT | base64 -d > $HELM_REPO_CRT_FILE
echo $HELM_REPO_KEY | base64 -d > $HELM_REPO_KEY_FILE

helm init --client-only
helm repo add $HELM_REPO $HELM_REPO_URL/charts/ --ca-file $SSL_CA_BUNDLE_FILE --cert-file $HELM_REPO_CRT_FILE --key-file $HELM_REPO_KEY_FILE

echo ""
