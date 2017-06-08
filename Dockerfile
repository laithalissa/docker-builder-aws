FROM alpine:latest


COPY configure-aws.sh /usr/bin/

RUN apk add --update --no-cache curl bash python3 docker \
  && python3 -m ensurepip \
  && ln -s /usr/bin/pip3 /usr/bin/pip \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && rm -r /usr/lib/python*/ensurepip \
  && pip3 install --upgrade pip setuptools awscli  \
  && rm -rf /var/cache/apk/* \
  && rm -r /root/.cache \
  && chmod +x /usr/bin/configure-aws.sh

