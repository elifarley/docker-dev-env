FROM node:10-alpine
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:alpine-wasm

ARG APK_PACKAGES="su-exec rsync sudo shadow bash"
ARG TINI_VERSION='v0.13.2'

ARG _USER=app
ARG HOME=/$_USER

ENV \
  NPM_CONFIG_LOGLEVEL=info \
  _USER="$_USER" \
  HOME="$HOME"

ENTRYPOINT ["tini", "--", "entrypoint"]
# 'entrypoint' will run $HOME/app.sh by default

WORKDIR $HOME

USER root

RUN apk --update add ca-certificates curl && \
  curl -fsSL https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh | sh && \
  xinstall save-image-info && \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add entrypoint && \
  xinstall add-user "$_USER" && \
  xinstall add-pkg && \
  xinstall add tar && \
  npm install --save-dev webpack walt-compiler walt-loader && \
  xinstall cleanup
