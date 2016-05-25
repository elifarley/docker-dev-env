FROM elifarley/docker-dev-env:debian-sshd
MAINTAINER elifarley@gmail.com

RUN   apt-get install -y --no-install-recommends mercurial git unzip \
python-pip python-setuptools && \
apt-get autoremove --purge -y && apt-get clean && rm -rf $RM_ITEMS
