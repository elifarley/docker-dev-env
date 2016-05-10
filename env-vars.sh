#!/bin/bash
set -e

ENV_VARS_DIR="${ENV_VARS_DIR:-/mnt-env-vars}"
PHUSION_ENV_DIR=/etc/container_environment

test -d "$ENV_VARS_DIR" && test "$(ls -A "$ENV_VARS_DIR")" || return 0

test -d "$PHUSION_ENV_DIR" && {
  cp -av "$ENV_VARS_DIR"/* "$PHUSION_ENV_DIR" && \
  return 0
}

for v in "$ENV_VARS_DIR"/* do;
  export "$(basename "$v")"="$(cat "$v")"
done
