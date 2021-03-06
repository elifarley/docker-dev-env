FROM node:10-alpine
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:alpine-wasm
# See https://medium.com/@dandisagrees/node-development-in-docker-7939d3bc2db7

ARG APK_PACKAGES="su-exec openssh rsync sudo shadow bash"
ARG TINI_VERSION='v0.18.0'

ARG _USER=app
ARG HOME=/$_USER

ENV \
  NODE_PATH=/usr/local/lib/node_modules \
  NPM_CONFIG_LOGLEVEL=warn \
  _USER="$_USER" \
  HOME="$HOME"

ENTRYPOINT ["tini", "--", "entrypoint"]
# 'entrypoint' will run $HOME/app.sh by default

WORKDIR $HOME

# SSHD
EXPOSE 2200

COPY . "$HOME"/

RUN apk --update add ca-certificates curl && \
  curl -fsSL https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh | sh && \
  xinstall save-image-info && \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add entrypoint && \
  xinstall add-user "$_USER" && \
  xinstall add-pkg && \
  xinstall configure sshd && \
  xinstall add tar && \
  npm install --save-dev --global webpack webpack-cli walt-compiler walt-loader && \
  xinstall cleanup && \
  mkdir -p "$HOME"/.docker && chmod +x "$HOME"/*app*.sh && chown -R "$_USER":"$_USER" \
    "$HOME"/*app.sh "$HOME"/.config "$HOME"/.docker "$HOME"/.npm
