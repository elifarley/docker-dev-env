FROM java:openjdk-8-jdk
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=java:openjdk-8-jdk

ENV \
APTGET_PACKAGES="ttf-dejavu" \
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

ADD https://github.com/elifarley/cross-installer/archive/master.tar.gz /tmp/cross-installer.tgz
ADD https://raw.githubusercontent.com/elifarley/shell-lib/master/lib/base.sh /usr/local/shell-lib/lib/base.sh
ADD https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh /tmp/cross-installer.sh
RUN sh /tmp/cross-installer.sh /usr/local && \
  xinstall save-image-info && \
  xinstall install tar && \
  xinstall install-pkg && \
  xinstall cleanup

RUN \
  xinstall install tini "$TINI_VERSION" "$TINI_SHA" && \
  xinstall install gosu "$GOSU_VERSION" "$GOSU_SHA"

RUN xinstall add-user "$_USER"

RUN xinstall install-base

COPY $_USER.sh $HOME/

ONBUILD USER app
ONBUILD COPY . "$HOME"/
ONBUILD USER root
ONBUILD RUN \
  xinstall save-image-info && \
  chmod +x "$HOME"/app.sh
