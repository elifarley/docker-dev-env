FROM elifarley/docker-dev-env:debian-openjdk-8-sshd
MAINTAINER elifarley@gmail.com
ENV BASE_IMAGE=elifarley/docker-dev-env:debian-openjdk-8-sshd

ENV APT_PACKAGES "mercurial git unzip \
python-pip python-setuptools"

RUN \
  xinstall save-image-info && \
  xinstall install-pkg && \
  xinstall cleanup

