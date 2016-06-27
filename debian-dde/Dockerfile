FROM elifarley/docker-dev-env:debian-sshd
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:debian-sshd \
\
APT_PACKAGES='mlocate'

RUN \
  xinstall save-image-info && \
  xinstall install-pkg && \
  xinstall install shellbasedeps && \
  xinstall install shellbase 1.0.9 && \
  xinstall install shellbasevimextra && \
  xinstall cleanup
