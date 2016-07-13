FROM elifarley/docker-alpine-oraclejdk8
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV \
BASE_IMAGE=elifarley/docker-alpine-oraclejdk8 \
\
GOSU_VERSION='1.5' TINI_VERSION='v0.5.0' \
_USER=app \
LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/entrypoint"]
CMD ["/app/app.sh"]

EXPOSE 8080

WORKDIR $HOME

RUN \
  xinstall save-image-info && \
  xinstall add gosu "$GOSU_VERSION" && \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add-user "$_USER" && \
  xinstall add entrypoint && \
  xinstall add timezone && \
  xinstall add tar && \
  xinstall cleanup

COPY $_USER.sh $HOME/

ONBUILD ENV BASE_IMAGE=elifarley/docker-dev-env:alpine-jdk-8-onbuild
ONBUILD USER app
ONBUILD COPY . "$HOME"/
ONBUILD USER root
ONBUILD RUN \
  xinstall save-image-info && \
  chmod +x "$HOME"/$_USER.sh && chown "$_USER":"$_USER" "$HOME"/$_USER.sh
