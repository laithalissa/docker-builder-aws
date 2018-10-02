#!/bin/bash

set -xe

export REPO=${REPO:-heartysoft/docker-builder-aws}
export TAG_TO_USE=${TRAVIS_TAG:-snapshot}
images=(
  base
  node
  helm
  helm-terraform
)

for image in ${images[@]}; do
  TAG_SUFFIX=''
  if [ $image != 'base' ]; then
    TAG_SUFFIX="-$image";
  fi
  docker build -t "$REPO:latest$TAG_SUFFIX" -t "$REPO:$TAG_TO_USE$TAG_SUFFIX" $image
done;
