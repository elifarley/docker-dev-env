#!/usr/bin/env bash
CMD_BASE="$(readlink -m $0)" || CMD_BASE="$0"; CMD_BASE="$(dirname $CMD_BASE)"
echo CMD_BASE: $CMD_BASE

deploy_image() {
  (( $# >= 2 )) || {
    echo "Usage:"
    echo "$0 <container-name> <image> [docker options...]"
    return 1
  }

  local name="$1"; shift
  local image="$1"; shift
  local mount_env_vars env_vars_dir=~/"env-vars-$name"
  test -d "$env_vars_dir" && mount_env_vars=(-v "$env_vars_dir":/mnt-env-vars:ro)
  docker pull "$image" || return $?
  docker rm -f "$name" ||:
  docker run -d --name "$name" "$@" "${mount_env_vars[@]}" "$image"
}

deploy_image "$@"
