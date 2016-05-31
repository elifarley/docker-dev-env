FROM alpine:3.3
MAINTAINER Elifarley <elifarley@gmail.com>
ENV BASE_IMAGE=alpine:3.3

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

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

WORKDIR $HOME

ADD https://github.com/elifarley/cross-installer/archive/master.tar.gz /tmp
RUN echo "dir:" && ls -Falk /tmp /tmp/cross-installe*
RUN sh /tmp/cross-installer*/install.sh /usr/local && \
  xinstall update-pkg-list && \
  xinstall install timezone && \
  xinstall save-image-info && \
  xinstall install-pkg ca-certificates curl openssh rsync sudo shadow bash && \
  xinstall configure sshd && \
  xinstall cleanup

RUN \
  xinstall install tini "$TINI_VERSION" "$TINI_SHA" && \
  xinstall install gosu "$GOSU_VERSION" "$GOSU_SHA"

RUN xinstall add-user "$_USER"

RUN xinstall install-base
