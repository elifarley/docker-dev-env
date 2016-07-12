FROM elifarley/docker-alpine-oraclejdk8
MAINTAINER Elifarley <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-alpine-oraclejdk8 \
\
APK_PACKAGES="openssh rsync sudo shadow bash" \
GOSU_VERSION='1.5' TINI_VERSION='v0.5.0' \
_USER=app \
TZ=${TZ:-Brazil/East} \
TERM=xterm-256color
ENV HOME=/$_USER JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/app/app.sh"]

# SSHD
EXPOSE 2200

WORKDIR $HOME

RUN \
  xinstall save-image-info && \
  xinstall add gosu "$GOSU_VERSION" && \
  xinstall add tini "$TINI_VERSION" && \
  xinstall add-base && \
  xinstall add-user "$_USER" && \
  xinstall add timezone && \
  xinstall add-pkg && \
  xinstall add tar && \
  xinstall configure sshd && \
  xinstall cleanup

COPY $_USER.sh $HOME/
RUN chmod +x "$HOME"/$_USER.sh && chown "$_USER":"$_USER" "$HOME"/$_USER.sh
