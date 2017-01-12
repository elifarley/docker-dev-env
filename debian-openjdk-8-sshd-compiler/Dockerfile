FROM elifarley/docker-dev-env:debian-openjdk-8-sshd
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:debian-openjdk-8-sshd

ENV APT_PACKAGES "\
gcc g++ make patch binutils libc6-dev \
  libjemalloc-dev libffi-dev libssl-dev libyaml-dev zlib1g-dev libgmp-dev libxml2-dev \
  libxslt1-dev libreadline-dev libsqlite3-dev \
  libpq-dev unixodbc unixodbc-dev unixodbc-bin ruby-odbc freetds-bin freetds-common freetds-dev postgresql-client \
  git lxc python3-six python3-colorama \
"

RUN \
  xinstall save-image-info && \
  xinstall add-pkg && \
  xinstall add-pkg python3-pip && pip3 install awscli-cwlogs && xinstall remove-pkg python3-pip && \
  xinstall add maven3 3.3.9 && \
  xinstall add golang 1.7.4 && \
  xinstall add ruby 2.3.0 && gem install bundler && \
  xinstall cleanup
