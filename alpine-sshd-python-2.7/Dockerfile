FROM elifarley/docker-dev-env:alpine-sshd
MAINTAINER elifarley@gmail.com
ENV BASE_IMAGE=elifarley/docker-dev-env:alpine-sshd

RUN \
  install-helper.sh save-image-info && \
  install-helper.sh update-pkg-list && \
  install-helper.sh install-pkg mercurial git unzip \
    python py-pip py-setuptools && \
  install-helper.sh cleanup
