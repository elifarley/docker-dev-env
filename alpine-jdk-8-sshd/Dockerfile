FROM frolvlad/alpine-oraclejdk8:cleaned
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

ENV TZ=${TZ:-Brazil/East}
ENV LANG=en_US.UTF-8
ENV TERM=xterm-256color

# Use tini as subreaper in Docker container to adopt zombie processes 
ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888
ADD https://github.com/krallin/tini/releases/download/v0.5.0/tini-static /bin/tini
RUN chmod +x /bin/tini && echo "$TINI_SHA  /bin/tini" | sha1sum -wc -

# Grab gosu for easy step-down from root.
ENV GOSU_SHA 18cced029ed8f0bf80adaa6272bf1650ab68f7aa
ADD https://github.com/tianon/gosu/releases/download/1.5/gosu-amd64 /bin/gosu
RUN chmod 755 /bin/gosu && echo "$GOSU_SHA  /bin/gosu" | sha1sum -wc -

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk --update add --no-cache tzdata ttf-dejavu openssh sudo ca-certificates curl rsync shadow bash && \
  echo "TZ set to '$TZ'" && echo $TZ > /etc/TZ && cp -a /usr/share/zoneinfo/"$TZ" /etc/localtime && apk del tzdata && \
  rm -rf /var/cache/apk/*

# --- Configure SSHD ---
RUN sed -e '/Port/d;/UsePrivilegeSeparation/d;/PermitRootLogin/d;/PermitUserEnvironment/d;/UsePAM/d;/UseDNS/d;/PasswordAuthentication/d;/ChallengeResponseAuthentication/d;/Banner/d;/PrintMotd/d;/PrintLastLog/d' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && \
printf "\nPort 2200\nUsePrivilegeSeparation no\nPermitRootLogin no\nPasswordAuthentication no\nChallengeResponseAuthentication no\nPermitUserEnvironment yes\nUseDNS no\nPrintMotd no\n\n#---\n" > /etc/ssh/sshd_config && \
cat /etc/ssh/sshd_config.tmp >> /etc/ssh/sshd_config && rm /etc/ssh/sshd_config.tmp && \
  cp -a /etc/ssh /etc/ssh.cache

EXPOSE 2200
# --- Configure SSHD ---

ENV _USER app
ENV HOME /$_USER
RUN adduser -D -h "$HOME" -s /bin/bash $_USER && \
  { getent group "sudo" || addgroup -S sudo ;} && echo '%sudo   ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
  gpasswd -a $_USER sudo && printf "$_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir -p $HOME/bin $HOME/.ssh && chmod go-w $HOME && chmod 700 $HOME/.ssh

# OR echo 'auth requisite  pam_deny.so' > /etc/pam.d/su

WORKDIR $HOME
RUN chown -R $_USER:$_USER "$HOME"

RUN curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/entry.sh -o /entry.sh && \
  chmod +x /entry.sh && \
  curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/env-vars.sh -o /env-vars.sh && \
  chmod +x /env-vars.sh && \
  curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/keytool-import-cert.sh -o "$HOME"/bin/keytool-import-cert.sh && \
  chmod +x "$HOME"/bin/*

ENTRYPOINT ["/bin/tini", "--", "/entry.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

ENV JAVA_TOOL_OPTIONS="-Duser.timezone=$TZ"
