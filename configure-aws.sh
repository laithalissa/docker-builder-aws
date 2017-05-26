#!/bin/bash

set -e

mkdir -p ~/.aws

rm -rf ~/.aws/*

echo "[profile builder]" >> ~/.aws/config
echo "region=$REGION" >> ~/.aws/config
echo "role_arn=$ROLE_ARN" >> ~/.aws/config
echo "source_profile=builder" >> ~/.aws/config

if [ "x$EXTERNAL_ID" != "x" ]; then
  echo "external_id=$EXTERNAL_ID" >> ~/.aws/config
fi

# needs AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to be set.

echo "[builder]" >> ~/.aws/credentials
echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials

