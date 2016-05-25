FROM elifarley/docker-dev-env:alpine-sshd
MAINTAINER elifarley@gmail.com

RUN apk --update add mercurial git unzip \
  python py-pip py-setuptools && \
  rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
