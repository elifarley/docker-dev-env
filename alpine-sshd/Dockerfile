FROM alpine:3.4
MAINTAINER Elifarley <elifarley@gmail.com>
ENV BASE_IMAGE=alpine:3.4

ENV \
APK_PACKAGES="openssh rsync sudo shadow bash" \
GOSU_VERSION='1.5' TINI_VERSION='v0.5.0' \
_USER=app \
LANG=en_US.UTF-8 TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/entrypoint"]
CMD ["/app/app.sh"]

# SSHD
EXPOSE 2200

WORKDIR $HOME

RUN apk --update add ca-certificates curl && \
curl -fsSL https://raw.githubusercontent.com/elifarley/cross-installer/master/install.sh | sh && \
  xinstall save-image-info && \
  xinstall add gosu "$GOSU_VERSION" && \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add-user "$_USER" && \
  xinstall add entrypoint && \
  xinstall add timezone && \
  xinstall add-pkg && \
  xinstall configure sshd && \
  xinstall cleanup
