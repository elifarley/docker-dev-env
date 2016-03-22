#!/usr/bin/env bash
set -e

test "$DEBUG" == 'true' && set -x

DAEMON=sshd
SSH_CONFIG_VOLUME=/root/ssh-config

# Copy default config from cache
test ! "$(ls -A /etc/ssh)" && \
   cp -a /etc/ssh.cache/* /etc/ssh/

# Generate Host keys, if required
test ! -f /etc/ssh/ssh_host_* && \
    ssh-keygen -A

# Fix permissions, if writable
test -w ~/.ssh && {
  test -d "$SSH_CONFIG_VOLUME" -a "$(ls -A "$SSH_CONFIG_VOLUME")" && cp -a "$SSH_CONFIG_VOLUME"/* ~/.ssh
  chown -R root:root ~/.ssh && chmod 700 ~/.ssh/ && chmod 600 ~/.ssh/* || echo "WARNING: No SSH authorized_keys or config found for root"
}

stop() {
    echo "Received SIGINT or SIGTERM. Shutting down $DAEMON"
    # Get PID
    pid=$(cat /var/run/$DAEMON/$DAEMON.pid)
    # Set TERM
    kill -SIGTERM "${pid}"
    # Wait for exit
    wait "${pid}"
    # All done.
    echo "Done."
}

echo "Running $@"
if [ "$(basename $1)" == "$DAEMON" ]; then
    trap stop SIGINT SIGTERM
    $@ &
    pid="$!"
    mkdir -p /var/run/$DAEMON && echo "${pid}" > /var/run/$DAEMON/$DAEMON.pid
    wait "${pid}" && exit $?
else
    exec "$@"
fi
