#!/usr/bin/env sh
set -xe

# Terraform
curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip
echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS
sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin
rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
