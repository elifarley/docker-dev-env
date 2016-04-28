#!/bin/bash

PS3="Choose image suffix: "
QUIT=".QUIT."; touch "$QUIT"

select image_suffix in alpine-sshd alpine-openjdk-8-sshd alpine-jdk-8-sshd alpine-dde debian-sshd debian-openjdk-8-sshd debian-openjdk-8-sshd-compiler debian-dde debian-dde-rails; do
  case "$image_suffix" in
        "$QUIT")
          echo "Exiting."
          break
          ;;
        *)
          echo "You picked: $REPLY. $FILENAME"
          ;;
  esac
  break
done; rm "$QUIT"; image_suffix="${image_suffix:alpine-sshd}"

set -x

IMAGE="elifarley/docker-dev-env:$image_suffix"

project_root="$1"; shift
test "$project_root" || exec ssh -o StrictHostKeyChecking=no -p2200 app@localhost

project_root="$(readlink -f "$project_root")"
project_name="$(basename "$project_root")"

docker pull "$IMAGE"

docker rm -f "$image_suffix"

DDE_BASH_HISTORY=~/.dde/bash-history-"$project_name"
DDE_VIMINFO=~/.dde/viminfo/"$project_name"
mkdir -p "$(dirname "$DDE_VIMINFO")" && \
touch "$DDE_BASH_HISTORY" && \
touch "$DDE_VIMINFO"

exec docker run --name "$image_suffix" --hostname "$project_name" \
-d \
-p 2200:2200 -p 3000:3000 \
-v ~/.ssh/id_rsa.pub:/mnt-ssh-config/authorized_keys:ro \
-v ~/.ssh/id_rsa:/mnt-ssh-config/id_rsa:ro \
-v ~/.ssh/known_hosts:/mnt-ssh-config/known_hosts:ro \
-v "$DDE_BASH_HISTORY":/app/.bash_history \
-v "$(dirname "$DDE_VIMINFO")":/app/.vim/viminfo \
-v "$project_root":/data \
"$IMAGE" "$@"
