FROM elifarley/docker-dev-env:alpine-sshd
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:alpine-sshd

RUN \
  xinstall save-image-info && \
  xinstall update-pkg-list && \
  xinstall add shellbasedeps && \
  xinstall add shellbase 1.0.9 && \
  xinstall add shellbasevimextra && \
  xinstall cleanup
