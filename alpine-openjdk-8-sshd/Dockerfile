FROM java:openjdk-8-jdk-alpine
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=java:openjdk-8-jdk-alpine \
\
APK_PACKAGES="openssh rsync sudo shadow bash ttf-dejavu" \
TINI_VERSION='v0.5.0' \
GOSU_VERSION='1.5' \
_USER=app \
LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

# SSHD
EXPOSE 2200

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

WORKDIR $HOME

RUN apk --no-cache add ca-certificates curl && \
curl -fsSL https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh | sh && \
  xinstall add timezone && \
  xinstall save-image-info && \
  xinstall add-pkg && \
  xinstall configure sshd && \
  xinstall cleanup

RUN \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add gosu "$GOSU_VERSION"

RUN xinstall add-user "$_USER"

RUN xinstall add-base
