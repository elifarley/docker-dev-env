FROM alpine:3.3
MAINTAINER Elifarley <elifarley@gmail.com>

RUN apk --update add --no-cache bash openssh rsync && \
  rm -rf /var/cache/apk/*

RUN echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
  cp -a /etc/ssh /etc/ssh.cache

ENV _USER app

ENV HOME /$_USER
RUN adduser -D -h "$HOME" -g "" $_USER && \
mkdir -p $HOME/.ssh && chmod go-w $HOME $HOME/.ssh && chown $_USER:$_USER -R $HOME

WORKDIR $HOME

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]
