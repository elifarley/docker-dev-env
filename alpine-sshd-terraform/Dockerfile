FROM elifarley/docker-dev-env:alpine-sshd
MAINTAINER elifarley@gmail.com

ENV TERRAFORM_VERSION=0.6.16

RUN apk --update add git openssl unzip \
  python py-pip py-setuptools groff less && \
  curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  -o /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/bin && \
  pip install awscli && \
  rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
