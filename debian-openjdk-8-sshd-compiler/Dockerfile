FROM elifarley:docker-dev-env/debian-openjdk-8-sshd
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

ENV APT_PACKAGES "\
gcc g++ make patch binutils libc6-dev \
  libjemalloc-dev libffi-dev libssl-dev libyaml-dev zlib1g-dev libgmp-dev libxml2-dev \
  libxslt1-dev libreadline-dev libsqlite3-dev \
  libpq-dev unixodbc unixodbc-dev unixodbc-bin ruby-odbc freetds-bin freetds-common freetds-dev postgresql-client \
  git lxc\
"

RUN apt-get install -y --no-install-recommends $APT_PACKAGES && \
apt-get autoremove --purge -y && apt-get clean && \
rm -rf $RM_ITEMS

# Install Rocker: https://github.com/grammarly/rocker		
ENV ROCKER_VERSION 1.1.2		
RUN curl -SL https://github.com/grammarly/rocker/releases/download/"$ROCKER_VERSION"/rocker-"$ROCKER_VERSION"-linux_amd64.tar.gz | tar -xzC /bin && chmod +x /bin/rocker

RUN echo 'auth requisite  pam_deny.so' > /etc/pam.d/su

WORKDIR $HOME
COPY gemrc .gemrc
ENV GEM_SPEC_CACHE "$HOME/gemspec"
ENV GEM_HOME "$HOME/gem-home"
ENV PATH "$GEM_HOME/bin:$PATH"

#VOLUME $HOME/.rbenv
