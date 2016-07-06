FROM elifarley/docker-dev-env:debian-sshd-rails
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:debian-sshd-rails

RUN \
  xinstall save-image-info && \
  xinstall add shellbasedeps && \
  xinstall add shellbase 1.0.9 && \
  xinstall add shellbasevimextra && \
  xinstall cleanup
