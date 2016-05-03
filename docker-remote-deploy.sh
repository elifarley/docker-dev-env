#!/usr/bin/env bash
CMD_BASE="$(readlink -m $0)" || CMD_BASE="$0"; CMD_BASE="$(dirname $CMD_BASE)"

# ssh thundera bash -s < remote.sh tygra m4ucorp/thundercats:tygra-latest
remote_deploy_image() {
  local privatekey="$1"; shift
  local host="$1"; shift

  ssh-keyscan ${host#*@} > ~/.ssh/known_hosts

  ssh < $CMD_BASE/docker-deploy.sh -i "$privatekey" "$host" bash -s "$@"
}

remote_deploy_image "$@"
