#!/usr/bin/env bash
set -e

test "$DEBUG" == 'true' && set -x

DAEMON=sshd
SSH_CONFIG_VOLUME="$HOME"/ssh-config

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
  chown -R $_USER:$_USER "$HOME"/.ssh && chmod 700 "$HOME"/.ssh && chmod 600 "$HOME"/.ssh/authorized_keys
}
ak="$HOME"/.ssh/authorized_keys
test ! -f "$ak" && echo "WARNING: No SSH authorized_keys found at '$ak'" || {
  echo "$ak:"; cat "$ak"
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
