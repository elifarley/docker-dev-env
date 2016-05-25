FROM elifarley/docker-dev-env:debian-openjdk-8-sshd-python-2.7
MAINTAINER elifarley@gmail.com

ENV TERRAFORM_VERSION=0.6.16

RUN apt-get install -y --no-install-recommends openssl groff less && \
  curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  -o /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/local/bin \
    terraform '*aws' terraform-provisioner-file 'terraform-provisioner-*exec' && \
  pip install awscli && \
apt-get autoremove --purge -y && apt-get clean && rm -rf $RM_ITEMS
