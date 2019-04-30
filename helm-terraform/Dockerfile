FROM heartysoft/docker-builder-aws:latest-helm

ENV TERRAFORM_VERSION=0.11.13 \
    TERRAFORM_SHA256SUM=5925cd4d81e7d8f42a0054df2aafd66e2ab7408dbed2bd748f0022cfe592f8d2

COPY setup.sh .
RUN ./setup.sh
