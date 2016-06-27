FROM elifarley/docker-dev-env:alpine-sshd
MAINTAINER elifarley@gmail.com
ENV BASE_IMAGE=elifarley/docker-dev-env:alpine-sshd

ENV \
APK_PACKAGES="mercurial git unzip python py-pip py-setuptools"

RUN \
  xinstall save-image-info && \
  xinstall update-pkg-list && \
  xinstall add-pkg && \
  xinstall cleanup
