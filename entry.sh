#!/usr/bin/env bash
CMD_BASE="$(readlink -f $0)" || CMD_BASE="$0"; CMD_BASE="$(dirname $CMD_BASE)"
set -e

dir_not_empty() { test "$(ls -A "$@" 2>/dev/null)" ;}

test "$DEBUG" && set -x

test -f "$HOME"/image-build.log && echo "$HOME/image-build.log:" && cat "$HOME"/image-build.log && echo

SSH_CONFIG_VOLUME="${SSH_CONFIG_VOLUME:-/mnt-ssh-config}"

test -d "$HOME"/.ssh || mkdir "$HOME"/.ssh
# Fix permissions, if writable
test ! -w "$HOME"/.ssh && echo "WARNING: '$HOME/.ssh' is not writeable" || {
  touch "$HOME"/.ssh/environment || return
  dir_not_empty "$SSH_CONFIG_VOLUME" && cp -av "$SSH_CONFIG_VOLUME"/* "$HOME"/.ssh
  chown -R $_USER:$_USER "$HOME"/.ssh && chmod -R 600 "$HOME"/.ssh && chmod 700 "$HOME"/.ssh
}

test -f "$HOME"/build-info.txt && echo "$HOME/build-info.txt:" && cat "$HOME"/build-info.txt && echo

test -r "$CMD_BASE"/env-vars.sh && \
  . "$CMD_BASE"/env-vars.sh

test -r "$HOME"/.ssh/docker-config.json && {
  mkdir -p "$HOME"/.docker
  test -f "$HOME"/.docker/config.json || \
    ln -sv ../.ssh/docker-config.json "$HOME"/.docker/config.json
}

test "$BUILD_MONIKER" && {
  echo "Hostname: changing from '$(cat /etc/hostname)' to '$BUILD_MONIKER'..."
  echo "$BUILD_MONIKER" > /etc/hostname
  hostname -F /etc/hostname || echo "Unable to change hostname"
}

# Copy default config from cache
dir_not_empty /etc/ssh || {
  echo "/etc/ssh is empty."
  dir_not_empty /etc/ssh.cache && cp -av /etc/ssh.cache/* /etc/ssh/
}

# Generate Host keys, if required
dir_not_empty /etc/ssh/ssh_host_* || {
  which ssh-keygen >/dev/null 2>&1 && ssh-keygen -A
}

ak="$HOME"/.ssh/authorized_keys
test ! -f "$ak" && echo "WARNING: No SSH authorized_keys found at '$ak'" || {
  printf "\n$ak:\n"; cat "$ak"; echo
}

test -x /keytool-import-certs.sh && dir_not_empty "$SSH_CONFIG_VOLUME"/certs && \
  /keytool-import-certs.sh --

# If UID of docker.sock is not the same...
test -S /var/run/docker.sock && test $(id -u $_USER) != $(stat -c "%u" /var/run/docker.sock) && {
  docker_group=$(stat -c "%g" /var/run/docker.sock)
  getent group "$docker_group" || groupadd -g "$docker_group" docker
  echo "Changing GID to '$docker_group' to match '/var/run/docker.sock'..."
  usermod -g "$docker_group" $_USER
}

MNT_DIR="${MNT_DIR:-/data}"
if test -e "$MNT_DIR"; then
  echo "Changing UID to match '$MNT_DIR'..."
  usermod -u $(stat -c "%u" "$MNT_DIR") $_USER
else
  echo "Creating '$MNT_DIR'..."
  mkdir "$MNT_DIR" && chown $_USER:$_USER "$MNT_DIR"
fi

id $_USER
echo "[$_USER] About to run: $*"

# Allow running SSHD as non-root user
if test root != "$_USER"; then
  chown -R $_USER:$_USER /etc/ssh
  test ! -d /var/run/sshd && \
    mkdir -p /var/run/sshd && chmod 0755 /var/run/sshd
fi

test "$(id -un)" = "$_USER" && \
printf "exec $*
---------------------------------\n
" && exec "$@"

printf "exec gosu '$_USER' $*
---------------------------------\n
" && exec gosu "$_USER" "$@"
