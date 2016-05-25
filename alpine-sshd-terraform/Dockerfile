FROM elifarley/docker-dev-env:alpine-sshd-python-2.7
MAINTAINER elifarley@gmail.com

ENV TERRAFORM_VERSION=0.6.16

RUN apk --update add openssl \
  groff less && \
  curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  -o /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/local/bin \
    terraform '*aws' terraform-provisioner-file 'terraform-provisioner-*exec' && \
  pip install awscli && \
  rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
