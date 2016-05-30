ENV BASE_IMAGE=java:openjdk-8-jdk-alpine
FROM "$BASE_IMAGE"
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

ENV \
TZ=${TZ:-Brazil/East} \
LANG=en_US.UTF-8 \
JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ" \
TINI_VERSION='v0.5.0' TINI_SHA=066ad710107dc7ee05d3aa6e4974f01dc98f3888 \
GOSU_VERSION='1.5' GOSU_SHA=18cced029ed8f0bf80adaa6272bf1650ab68f7aa \
_USER=app HOME=/$_USER \
TERM=xterm-256color

# SSHD
EXPOSE 2200

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

WORKDIR $HOME

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk --update add --no-cache ca-certificates curl openssh rsync tzdata ttf-dejavu sudo shadow bash && \
  echo "TZ set to '$TZ'" && echo $TZ > /etc/TZ && cp -a /usr/share/zoneinfo/"$TZ" /etc/localtime && apk del tzdata && \
  rm -rf /var/cache/apk/*

# Use tini as subreaper in Docker container to adopt zombie processes 
ADD https://github.com/krallin/tini/releases/download/"$TINI_VERSION"/tini-static /bin/tini
RUN chmod +x /bin/tini && echo "$TINI_SHA  /bin/tini" | sha1sum -wc -

# Grab gosu for easy step-down from root.
ADD https://github.com/tianon/gosu/releases/download/"$GOSU_VERSION"/gosu-amd64 /bin/gosu
RUN chmod 755 /bin/gosu && echo "$GOSU_SHA  /bin/gosu" | sha1sum -wc -

# --- Configure SSHD ---
RUN sed -e '/Port/d;/UsePrivilegeSeparation/d;/PermitRootLogin/d;/PermitUserEnvironment/d;/UsePAM/d;/UseDNS/d;/PasswordAuthentication/d;/ChallengeResponseAuthentication/d;/Banner/d;/PrintMotd/d;/PrintLastLog/d' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && \
printf "\nPort 2200\nUsePrivilegeSeparation no\nPermitRootLogin no\nPasswordAuthentication no\nChallengeResponseAuthentication no\nPermitUserEnvironment yes\nUseDNS no\nPrintMotd no\n\n#---\n" > /etc/ssh/sshd_config && \
cat /etc/ssh/sshd_config.tmp >> /etc/ssh/sshd_config && rm /etc/ssh/sshd_config.tmp && \
  cp -a /etc/ssh /etc/ssh.cache
# --- Configure SSHD ---

RUN adduser -D -h "$HOME" -s /bin/bash $_USER && \
  { getent group "sudo" || addgroup -S sudo ;} && echo '%sudo   ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
  gpasswd -a $_USER sudo && printf "$_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir -p $HOME/.ssh && chmod go-w $HOME && chmod 700 $HOME/.ssh && \
  echo -ne "BASE_IMAGE: $BASE_IMAGE\n$(cat /etc/issue | head -n1)\n($(uname -rsv))\n" >> /$HOME/docker-image.info
# OR echo 'auth requisite  pam_deny.so' > /etc/pam.d/su

RUN chown -R $_USER:$_USER "$HOME"

RUN curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/entry.sh -o /entry.sh && \
  chmod +x /entry.sh && \
  curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/env-vars.sh -o /env-vars.sh && \
  chmod +x /env-vars.sh
