FROM java:openjdk-8-jdk-alpine
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=java:openjdk-8-jdk-alpine

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

ADD https://raw.githubusercontent.com/elifarley/docker-dev-env/master/install-helper.sh /usr/local/bin
RUN chmod +x /usr/local/bin/install-helper.sh && \
  install-helper.sh update-pkg-list && \
  install-helper.sh install timezone && \
  install-helper.sh save-image-info && \
  install-helper.sh install-pkg ca-certificates curl openssh rsync ttf-dejavu sudo shadow bash && \
  install-helper.sh cleanup

RUN \
  install-helper.sh install tini "$TINI_VERSION" "$TINI_SHA" && \
  install-helper.sh install gosu "$GOSU_VERSION" "$GOSU_SHA" && \
  install-helper.sh configure sshd

RUN adduser -D -h "$HOME" -s /bin/bash $_USER && \
  { getent group "sudo" || addgroup -S sudo ;} && echo '%sudo   ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
  gpasswd -a $_USER sudo && printf "$_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir -p $HOME/.ssh && chmod go-w $HOME && chmod 700 $HOME/.ssh
# OR echo 'auth requisite  pam_deny.so' > /etc/pam.d/su

RUN chown -R $_USER:$_USER "$HOME"

RUN curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/entry.sh -o /entry.sh && \
  chmod +x /entry.sh && \
  curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/env-vars.sh -o /env-vars.sh && \
  chmod +x /env-vars.sh
