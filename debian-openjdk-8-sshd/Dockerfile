FROM java:openjdk-8-jdk
# "java:openjdk-8-jdk" already contains: ca-certificates curl bash
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=java:openjdk-8-jdk

ENV \
APT_PACKAGES="openssh-server rsync sudo time ttf-dejavu" \
TINI_VERSION='v0.5.0' \
GOSU_VERSION='1.5' \
_USER=app \
LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

# SSHD
EXPOSE 2200

ENTRYPOINT ["tini", "--", "entrypoint"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

WORKDIR $HOME

RUN curl -fsSL https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh | sh && \
  xinstall save-image-info && \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add gosu "$GOSU_VERSION" && \
  xinstall add entrypoint && \
  xinstall add-user "$_USER" && \
  xinstall add timezone && \
  xinstall add-pkg && \
  xinstall add tar && \
  xinstall configure sshd && \
  xinstall cleanup
