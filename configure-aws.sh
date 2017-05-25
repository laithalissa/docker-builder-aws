#!/bin/bash

mkdir -p ~/.aws

echo "[default]" >> ~/.aws/config
echo "region=$REGION" >> ~/.aws/config
echo "role_arn=$ROLE_ARN" >> ~/.aws/config

if [ "x$EXTERNAL_ID" != "x" ]; then
  echo "external_id=$EXTERNAL_ID" >> ~/.aws/config
fi

# needs AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to be set.
