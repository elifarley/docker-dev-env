FROM elifarley/docker-debian-jdk-8
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV \
BASE_IMAGE=elifarley/docker-debian-jdk-8 \
\
TINI_VERSION='v0.5.0' TINI_SHA=066ad710107dc7ee05d3aa6e4974f01dc98f3888 \
GOSU_VERSION='1.5' GOSU_SHA=18cced029ed8f0bf80adaa6272bf1650ab68f7aa \
_USER=app \
LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

EXPOSE 8080

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/app/app.sh"]

WORKDIR $HOME

RUN \
  xinstall save-image-info && \
  xinstall install tar && \
  xinstall install tini "$TINI_VERSION" "$TINI_SHA" && \
  xinstall install gosu "$GOSU_VERSION" "$GOSU_SHA" && \
  xinstall cleanup

RUN xinstall add-user "$_USER"

RUN xinstall install-base

COPY $_USER.sh $HOME/

ONBUILD ENV BASE_IMAGE=elifarley/docker-dev-env:debian-jdk-8-onbuild
ONBUILD USER app
ONBUILD COPY . "$HOME"/
ONBUILD USER root
ONBUILD RUN \
  xinstall save-image-info && \
  chmod +x "$HOME"/app.sh
