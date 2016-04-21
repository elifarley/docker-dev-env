#!/usr/bin/env bash
set -e

test "$DEBUG" == 'true' && set -x

DAEMON="${DAEMON:-sshd}"
SSH_CONFIG_VOLUME="${SSH_CONFIG_VOLUME:-/mnt-ssh-config}"
MNT_DIR="${MNT_DIR:-/data}"

# Copy default config from cache
test "$(ls -A /etc/ssh)" || \
   cp -a /etc/ssh.cache/* /etc/ssh/

# Generate Host keys, if required
test "$(ls -A /etc/ssh/ssh_host_*)" || \
    ssh-keygen -A

test -d "$HOME"/.ssh || mkdir "$HOME"/.ssh
# Fix permissions, if writable
test ! -w "$HOME"/.ssh && echo "WARNING: '$HOME/.ssh' is not writeable" || {
  test -d "$SSH_CONFIG_VOLUME" -a "$(ls -A "$SSH_CONFIG_VOLUME")" && cp -a "$SSH_CONFIG_VOLUME"/* "$HOME"/.ssh
  chown -R $_USER:$_USER "$HOME"/.ssh && chmod 700 "$HOME"/.ssh && chmod 600 "$HOME"/.ssh/*
}

test -r "$HOME"/.ssh/docker-config.json && \
  mkdir -p "$HOME"/.docker && ln -s ../.ssh/docker-config.json $HOME/.docker/config.json

ak="$HOME"/.ssh/authorized_keys
test ! -f "$ak" && echo "WARNING: No SSH authorized_keys found at '$ak'" || {
  echo "$ak:"; cat "$ak"
}

echo "[$_USER] Running $@"

# If UID of docker.sock is not the same...
test -S /var/run/docker.sock && test $(id -u $_USER) != $(stat -c "%u" /var/run/docker.sock) && {
  docker_group=$(stat -c "%g" /var/run/docker.sock)
  getent group "$docker_group" || groupadd -g "$docker_group" docker
  usermod -g "$docker_group" $_USER
}

if test -e "$MNT_DIR"; then
  usermod -u $(stat -c "%u" "$MNT_DIR") $_USER
else
  mkdir "$MNT_DIR" && chown $_USER:$_USER "$MNT_DIR"
fi

id $_USER

# Allow running SSHD as non-root user
if test root != "$_USER"; then
  chown -R $_USER:$_USER /etc/ssh
  test ! -d /var/run/sshd && \
    mkdir -p /var/run/sshd && chmod 0755 /var/run/sshd
fi

if [ "$(basename $1)" == "$DAEMON" ]; then
    if test $(id -un) != "$_USER"; then
      echo "gosu $_USER tini -- $@"
      gosu $_USER tini -- $@
    else
      tini -- $@
    fi
    exit $?
fi

if test $(id -un) != "$_USER"; then
  exec gosu $_USER "$@"
else
  "$@"
fi
