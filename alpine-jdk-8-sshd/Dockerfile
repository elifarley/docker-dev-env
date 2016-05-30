FROM frolvlad/alpine-oraclejdk8:cleaned
MAINTAINER Elifarley <elifarley@gmail.com>
ENV BASE_IMAGE=frolvlad/alpine-oraclejdk8:cleaned

ENV \
TZ=${TZ:-Brazil/East} \
LANG=en_US.UTF-8 \
JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ" \
TINI_VERSION='v0.5.0' TINI_SHA=066ad710107dc7ee05d3aa6e4974f01dc98f3888 \
GOSU_VERSION='1.5' GOSU_SHA=18cced029ed8f0bf80adaa6272bf1650ab68f7aa \
_USER=app \
TERM=xterm-256color
ENV HOME=/$_USER

# SSHD
EXPOSE 2200

ENTRYPOINT /bin/tini -- /entry.sh
CMD /usr/sbin/sshd -D -f /etc/ssh/sshd_config

WORKDIR $HOME

ADD https://raw.githubusercontent.com/elifarley/docker-dev-env/master/install-helper.sh /usr/local/bin
RUN chmod +x /usr/local/bin/install-helper.sh && \
  install-helper.sh update-pkg-list && \
  install-helper.sh install timezone && \
  install-helper.sh save-image-info && \
  install-helper.sh install-pkg ca-certificates curl openssh rsync sudo shadow bash && \
  install-helper.sh configure sshd && \
  install-helper.sh cleanup

RUN \
  install-helper.sh install tini "$TINI_VERSION" "$TINI_SHA" && \
  install-helper.sh install gosu "$GOSU_VERSION" "$GOSU_SHA"

RUN install-helper.sh add-user "$_USER"

RUN install-helper.sh install-base
