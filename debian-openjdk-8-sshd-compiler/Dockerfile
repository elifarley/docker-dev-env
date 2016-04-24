FROM elifarley/docker-dev-env:debian-openjdk-8-sshd
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

ENV APT_PACKAGES "\
gcc g++ make patch binutils libc6-dev \
  libjemalloc-dev libffi-dev libssl-dev libyaml-dev zlib1g-dev libgmp-dev libxml2-dev \
  libxslt1-dev libreadline-dev libsqlite3-dev \
  libpq-dev unixodbc unixodbc-dev unixodbc-bin ruby-odbc freetds-bin freetds-common freetds-dev postgresql-client \
  git\
"

RUN apt-get install -y --no-install-recommends $APT_PACKAGES && \
apt-get autoremove --purge -y && apt-get clean && \
rm -rf $RM_ITEMS

# Install Maven
ENV MAVEN_VERSION 3.3.9
ENV MAVEN_SHA 5b4c117854921b527ab6190615f9435da730ba05
RUN curl -fsSL http://www-us.apache.org/dist/maven/maven-3/"$MAVEN_VERSION"/binaries/apache-maven-"$MAVEN_VERSION"-bin.tar.gz -o /tmp/maven.tgz && \
  echo "$MAVEN_SHA  /tmp/maven.tgz" | sha1sum -wc - && \
  tar -xzf /tmp/maven.tgz -C /usr/local && rm /tmp/maven.tgz && \
  ln -s apache-maven-"$MAVEN_VERSION" /usr/local/maven-3 && ln -s ../maven-3/bin/mvn ../maven-3/bin/mvnDebug ../maven-3/bin/mvnyjp /usr/local/bin
