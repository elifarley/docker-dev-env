FROM elifarley/docker-dev-env:debian-dde
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

#ENV RM_APT '/var/lib/apt/lists/* /var/lib/apt /var/lib/dpkg'
ENV RM_ITEMS '/tmp/* /var/tmp/* /var/backups/* /usr/share/man /usr/share/doc'

# --- Ruby ---
ENV APT_PACKAGES "\
gcc g++ make patch binutils libc6-dev \
  libjemalloc-dev libffi-dev libssl-dev libyaml-dev zlib1g-dev libgmp-dev libxml2-dev \
  libxslt1-dev libreadline-dev libsqlite3-dev \
  libpq-dev unixodbc unixodbc-dev unixodbc-bin ruby-odbc freetds-bin freetds-common freetds-dev postgresql-client \
 "

RUN apt-get install -y --no-install-recommends $APT_PACKAGES && \
apt-get autoremove --purge -y && apt-get clean && rm -rf $RM_ITEMS

ENV RUBY_MAJOR "2.3"
ENV RUBY_VERSION "2.3.0"
ENV RUBYGEMS_VERSION "2.5.2"

WORKDIR /tmp
RUN curl "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR}/ruby-${RUBY_VERSION}.tar.gz" |\
  tar -xz && \
  cd ruby-${RUBY_VERSION} && \
  ./configure --enable-shared --with-jemalloc --disable-install-doc && \
  make -j4 && make install && \
  rm /usr/local/lib/libruby-static.a && \
  rm -rf $RM_ITEMS
# --- Ruby ---

WORKDIR $HOME
ENV PATH ".gem/bin:$PATH"

ENV BUNDLER_VERSION "1.11.2"
ENV RAILS_VERSION 4.2.5.1
RUN printf 'gem: --no-document' > .gemrc && \
  gem --config-file .gemrc update --system ${RUBYGEMS_VERSION} && \
  gem --config-file .gemrc install -v ${BUNDLER_VERSION} bundler && \
  gem --config-file .gemrc install rails --version "$RAILS_VERSION" && \
  gem --config-file .gemrc install rspec-rails simplecov simplecov-cobertura simplecov-rcov factory_girl && \
  gem --config-file .gemrc install puma --version 3.1.0 && \
  rm -rf $RM_ITEMS

RUN chown -R $_USER:$_USER /usr/lib/ruby /usr/local/lib/ruby

EXPOSE 3000

RUN printf "PATH=$PATH\n" >> "$HOME"/.ssh/environment && \
  printf "\ncd /data\ntest ! -d vendor/bundle && bundle install --path vendor/bundle && du -hs vendor/*\npwd" \
    >> "$HOME"/.bashrc

RUN chown -R $_USER:$_USER "$HOME"

#VOLUME $HOME/.rbenv
