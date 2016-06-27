FROM elifarley/docker-dev-env:debian-openjdk-8-sshd
MAINTAINER Elifarley Cruz <elifarley@gmail.com>
ENV BASE_IMAGE=elifarley/docker-dev-env:debian-openjdk-8-sshd

ENV APT_PACKAGES "\
gcc g++ make patch binutils libc6-dev \
  libjemalloc-dev libffi-dev libssl-dev libyaml-dev zlib1g-dev libgmp-dev libxml2-dev \
  libxslt1-dev libreadline-dev libsqlite3-dev \
  libpq-dev unixodbc unixodbc-dev unixodbc-bin ruby-odbc freetds-bin freetds-common freetds-dev postgresql-client \
  git lxc\
"

RUN \
  xinstall save-image-info && \
  xinstall add-pkg && \
  xinstall add maven3 3.3.9 '5b4c117854921b527ab6190615f9435da730ba05' && \
  xinstall add gradle 2.13 '01078159f79fbe09fc006b040886423d8736dae8' && \
  xinstall cleanup
