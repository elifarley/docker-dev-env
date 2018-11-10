FROM node:10
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:wasm-rust
# See https://medium.com/@dandisagrees/node-development-in-docker-7939d3bc2db7

ARG APT_PACKAGES="openssh-server sudo ca-certificates curl rsync"
ARG TINI_VERSION='v0.18.0'
ARG GOSU_VERSION='1.5'

ARG _USER=app
ARG HOME=/$_USER

ENV \
  NODE_PATH=/usr/local/lib/node_modules \
  NPM_CONFIG_LOGLEVEL=warn \
  _USER="$_USER" \
  LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
  HOME="$HOME"

ENTRYPOINT ["tini", "--", "entrypoint"]
# 'entrypoint' will run $HOME/app.sh by default

WORKDIR $HOME

# SSHD
EXPOSE 2200

COPY . "$HOME"/

RUN apt-get update -y && apt-get install -y ca-certificates curl && \
  curl -fsSL https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh | sh && \
  xinstall save-image-info && \
  xinstall add gosu "$GOSU_VERSION" && \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add-user "$_USER" && \
  xinstall add entrypoint && \
  xinstall add timezone && \
  xinstall add-pkg && \
  xinstall configure sshd

RUN \
  curl https://sh.rustup.rs -sSf | sh -s -- -y && { rustc --version || which rustc || echo no rust; } && \
  curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh && \
  cargo install cargo-generate && \
  xinstall cleanup && \
  mkdir -p "$HOME"/.docker && chmod +x "$HOME"/*app*.sh && chown -R "$_USER":"$_USER" \
    "$HOME"/*app.sh "$HOME"/.config "$HOME"/.docker "$HOME"/.npm
