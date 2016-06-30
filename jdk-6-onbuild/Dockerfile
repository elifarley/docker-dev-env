FROM elifarley/docker-oracle-jdk6
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV \
BASE_IMAGE=elifarley/docker-oracle-jdk6 \
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
  xinstall add tar && \
  xinstall add-pkg sudo && \
  xinstall add tini "$TINI_VERSION" "$TINI_SHA" && \
  xinstall add gosu "$GOSU_VERSION" "$GOSU_SHA" && \
  xinstall cleanup

RUN xinstall add-user "$_USER"

RUN xinstall add-base

USER "$_USER"
COPY $_USER.sh $HOME/
USER root

ONBUILD ENV BASE_IMAGE=elifarley/docker-dev-env:jdk-6-onbuild
ONBUILD RUN \
  xinstall save-image-info && \
  chmod +x "$HOME"/app.sh
