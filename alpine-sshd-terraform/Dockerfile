FROM elifarley/docker-dev-env:alpine-sshd
MAINTAINER elifarley@gmail.com

ENV TERRAFORM_VERSION=0.6.16

RUN apk add git openssl unzip && \
  curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  -o /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/bin && \
  rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
