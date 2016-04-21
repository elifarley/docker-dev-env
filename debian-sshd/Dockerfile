FROM debian:jessie
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

ENV LANG en_US.UTF-8
#RUN locale-gen $LANG && dpkg-reconfigure locales && /usr/sbin/update-locale LANG=$LANG

ENV TZ ${TZ:-Brazil/East}
RUN echo "TZ set to '$TZ'" && echo $TZ > /etc/TZ && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/"$TZ" /etc/localtime

ENV TERM=xterm-256color

# Use tini as subreaper in Docker container to adopt zombie processes 
ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888
ADD https://github.com/krallin/tini/releases/download/v0.5.0/tini-static /bin/tini
RUN chmod +x /bin/tini && echo "$TINI_SHA  /bin/tini" | sha1sum -wc -

# Grab gosu for easy step-down from root.
ENV GOSU_SHA 18cced029ed8f0bf80adaa6272bf1650ab68f7aa
ADD https://github.com/tianon/gosu/releases/download/1.5/gosu-amd64 /bin/gosu
RUN chmod 755 /bin/gosu && echo "$GOSU_SHA  /bin/gosu" | sha1sum -wc -

#ENV RM_APT '/var/lib/apt/lists/* /var/lib/apt /var/lib/dpkg'
ENV RM_ITEMS '/tmp/* /var/tmp/* /var/backups/* /usr/share/man /usr/share/doc'

ENV APT_PACKAGES "openssh sudo ca-certificates curl rsync"
RUN printf 'APT::Get::Install-Recommends "false";\nDpkg::Options {\n"--force-confdef";\n"--force-confold";\n}' \
> /etc/apt/apt.conf.d/local && apt-get update && apt-get -y dist-upgrade && \
apt-get install -y --no-install-recommends $APT_PACKAGES && \
apt-get autoremove --purge -y && apt-get clean && \
rm -rf /etc/cron.daily/{apt,passwd} $RM_ITEMS

# --- Configure SSHD ---
RUN sed -e '/Port/d;/UsePrivilegeSeparation/d;/PermitRootLogin/d;/PermitUserEnvironment/d;/UsePAM/d;/PasswordAuthentication/d;/ChallengeResponseAuthentication/d;/Banner/d' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && \
printf "\nPort 2200\nUsePrivilegeSeparation no\nPermitRootLogin no\nPermitUserEnvironment yes\nUsePAM no\nPasswordAuthentication no\nChallengeResponseAuthentication no\n\n#---\n" > /etc/ssh/sshd_config && \
cat /etc/ssh/sshd_config.tmp >> /etc/ssh/sshd_config && rm /etc/ssh/sshd_config.tmp && \
  cp -a /etc/ssh /etc/ssh.cache

EXPOSE 2200
# --- Configure SSHD ---

ENV _USER app
ENV HOME /$_USER
RUN adduser --disabled-password --home "$HOME" --shell /bin/bash --gecos "" $_USER && \
  gpasswd -a $_USER sudo && printf "$_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir -p $HOME/.ssh && chmod go-w $HOME && chmod 700 $HOME/.ssh

WORKDIR $HOME
RUN chown -R $_USER:$_USER "$HOME"

RUN curl -fsSL https://raw.githubusercontent.com/elifarley/docker-dev-env/master/entry.sh -o /entry.sh && \
chmod +x /entry.sh
ENTRYPOINT ["/entry.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
