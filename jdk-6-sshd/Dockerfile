FROM elifarley/docker-oracle-jdk6
# "elifarley/docker-oracle-jdk6" already contains: ca-certificates curl bash
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-oracle-jdk6 \
\
APT_PACKAGES="openssh-server rsync sudo time" \
TINI_VERSION='v0.5.0' TINI_SHA=066ad710107dc7ee05d3aa6e4974f01dc98f3888 \
GOSU_VERSION='1.5' GOSU_SHA=18cced029ed8f0bf80adaa6272bf1650ab68f7aa \
_USER=app \
LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

# SSHD
EXPOSE 2200

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

WORKDIR $HOME

RUN \
  xinstall add timezone && \
  xinstall save-image-info && \
  xinstall add tar && \
  xinstall add-pkg && \
  xinstall configure sshd && \
  xinstall cleanup

RUN \
  xinstall add tini "$TINI_VERSION" "$TINI_SHA" && \
  xinstall add gosu "$GOSU_VERSION" "$GOSU_SHA"

RUN xinstall add-user "$_USER"

RUN xinstall add-base
