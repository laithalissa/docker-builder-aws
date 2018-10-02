FROM heartysoft/docker-builder-aws:latest-helm

ENV TERRAFORM_VERSION=0.11.8 \
    TERRAFORM_SHA256SUM=84ccfb8e13b5fce63051294f787885b76a1fedef6bdbecf51c5e586c9e20c9b7

COPY setup.sh .
RUN ./setup.sh
