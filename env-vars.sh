#!/bin/sh
set -e

ENV_VARS_DIR="${ENV_VARS_DIR:-/mnt-env-vars}"
PHUSION_ENV_DIR=/etc/container_environment

test -d "$ENV_VARS_DIR" && test "$(ls -A "$ENV_VARS_DIR")" || {
  echo "No env var files at '$ENV_VARS_DIR'"
  return
}

test -d "$PHUSION_ENV_DIR" && {
  echo "Copying env var files from '$ENV_VARS_DIR' to '$PHUSION_ENV_DIR'..."
  cp -av "$ENV_VARS_DIR"/* "$PHUSION_ENV_DIR"
  return
}

echo "Loading env var files from '$ENV_VARS_DIR'..."
for v in "$ENV_VARS_DIR"/*; do
  echo "$(basename "$v")"="$(cat "$v")"
  export "$(basename "$v")"="$(cat "$v")"
done
