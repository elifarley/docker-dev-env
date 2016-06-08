#!/bin/sh
set -e

ENV_VARS_DIR="${ENV_VARS_DIR:-/mnt-env-vars}"
PHUSION_ENV_DIR=/etc/container_environment

test -d "$ENV_VARS_DIR" && test "$(ls -A "$ENV_VARS_DIR")" || {
  echo "No env var files at '$ENV_VARS_DIR'"
  return
}

process_env_file() {
  local env_file="$1"
  local to_export="$2"

  local name="$(basename "$env_file")"; local val="$(cat "$env_file")"
  echo "$name='$val'"
  test "$to_export" && export "$name"="$val"
  printf "%s='%s'\n" "$name" "$val" >> "$HOME"/.ssh/environment
}

test -d "$PHUSION_ENV_DIR" && {
  echo "Copying env var files from '$ENV_VARS_DIR' to '$PHUSION_ENV_DIR'..."
  cp -av "$ENV_VARS_DIR"/* "$PHUSION_ENV_DIR"
  for v in "$ENV_VARS_DIR"/*; do
    process_env_file "$v"
  done
  return
}

echo "Loading env var files from '$ENV_VARS_DIR'..."
for v in "$ENV_VARS_DIR"/*; do
  process_env_file "$v" true
done
