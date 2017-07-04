#!/bin/sh

function configure_helm {
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
}


function export_chart_version {
 export CHART_NAME=$(grep -Po '(?<=name: ).*' "$CHART/Chart.yaml" | head -n 1)
 export CHART_VERS=$(grep -Po '(?<=version: ).*(?=-\$VERSION)' "$CHART/Chart.yaml")
}


function export_environment {
  my_env=$1
  export KUBE_CA_PEM=$((KUBE_CA_PEM_$my_env))
  export KUBE_NAMESPACE=$((KUBE_NAMESPACE_$my_env))
  export KUBE_TOKEN=$((KUBE_TOKEN_$my_env))
  export RELEASE_NAME=$((RELEASE_NAME_$my_env))
}

function __replace_values {
  envsubst $1 < $2 > /tmp/replaced && \
    mv /tmp/replaced $2
}


function validate_release {
  
  RELEASE_NAME=$1
  TIMEOUT=$2

  set -x

  if [ -z "$RELEASE_NAME" ]; then
    echo "A release name must be passed as an argument."
    exit 1
  fi

  HELM_COMMAND="helm test $RELEASE_NAME --cleanup"

  if [ -n "$TIME_OUT" ]; then
    HELM_COMMAND="$HELM_COMMAND --timeout $TIME_OUT"
  fi

  eval $HELM_COMMAND
}

function publish_chart {
  set -x

  echo "preparing chart..."

  vars_to_replace="\$VERSION"

  __replace_values $vars_to_replace $CHART/Chart.yaml
  __replace_values $vars_to_replace $CHART/values.yaml

  echo "releasing chart for tests from local folder..."

  helm upgrade --install --namespace $KUBE_NAMESPACE --debug $RELEASE_NAME $CHART

  echo "testing chart..."

  validate_release $RELEASE_NAME

  EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
    echo "packaging and uploading chart..."
    helm package $CHART && curl -k --cert-type pem --cert $HELM_REPO_CRT_FILE --key $HELM_REPO_KEY_FILE -v -T ./$CHART_NAME-$CHART_VERS-$VERSION.tgz -X PUT $HELM_REPO_URL/upload/
    EXIT_CODE=$?
  fi

  helm delete --purge $RELEASE_NAME

  return $EXIT_CODE
}

function deploy_chart {

  CHART_VERSION=$CHART_VERS
  CHART_TO_DEPLOY=$HELM_CHART
  set -xe

  if [ "x$CHART_VERSION" == "x" ]; then
    echo "CHART_VERSION must be set."; exit 1
  elif [ "x$CHART_TO_DEPLOY" == "x" ]; then
    echo "HELM_CHART must be set."; exit 1
  elif [ "x$KUBE_NAMESPACE" == "x" ]; then
    echo "KUBE_NAMESPACE must be set."; exit 1
  elif [ "x$RELEASE_NAME" == "x" ]; then
    echo "RELEASE_NAME must be set."; exit 1
  elif [ "x$VERSION" == "x" ]; then
    echo "VERSION must be set."; exit 1
  fi
  
  echo "deploying chart to $KUBE_NAMESPACE..."

  helm upgrade --install --namespace $KUBE_NAMESPACE --version $CHART_VERSION-$VERSION --debug $RELEASE_NAME $CHART_TO_DEPLOY

}

