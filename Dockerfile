FROM alpine:latest

ENV HSFT_CLOUD_TOOLKIT_VERSION=0.7.0 \
    AWS_PROFILE_NAME=builder

RUN apk add --update --no-cache curl bash python3 docker libintl zip jq \
  && apk add --virtual gt gettext \ 
  && cp /usr/bin/envsubst /usr/local/bin/envsubst \
  && apk del gt \
  && python3 -m ensurepip \
  && ln -s /usr/bin/pip3 /usr/bin/pip \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && rm -r /usr/lib/python*/ensurepip \
  && pip3 install --upgrade pip setuptools awscli  \
  && rm -rf /var/cache/apk/* \
  && rm -r /root/.cache \
  && curl https://raw.githubusercontent.com/heartysoft/cloud-toolkit/$HSFT_CLOUD_TOOLKIT_VERSION/aws/aws-functions.sh -o /usr/bin/aws-functions.sh \
  && curl https://raw.githubusercontent.com/heartysoft/cloud-toolkit/$HSFT_CLOUD_TOOLKIT_VERSION/vault/vault-functions.sh -o /usr/bin/vault-functions.sh
