#!/bin/bash

PS3="Choose image suffix: "
QUIT=".QUIT."; touch "$QUIT"

select image_suffix in alpine-sshd alpine-openjdk-8-sshd alpine-jdk-8-sshd alpine-dde alpine-wasm debian-sshd debian-sshd-rails debian-openjdk-8-sshd debian-openjdk-8-sshd-compiler debian-dde debian-sshd-rails-dde; do
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

DDE_BASH_HISTORY=~/.dde/bash-history-"$project_name"
DDE_VIMINFO=~/.dde/viminfo
DDE_UNDOFILES=~/.dde/vim-undofiles-"$project_name"
mkdir -p "$DDE_VIMINFO" "$DDE_UNDOFILES" && \
touch "$DDE_BASH_HISTORY"
test -f ~/.hgrc && hgrc="-v $HOME/.hgrc:/app/.hgrc:ro" || unset hgrc
test -f ~/.gitconfig && gitconfig="-v $HOME/.gitconfig:/app/.gitconfig:ro" || unset gitconfig
test -d ~/.m2 && m2dir="-v $HOME/.m2:/app/.m2" || unset m2dir

DOCKER_LIBS="$(ldd $(which docker) | grep libdevmapper | cut -d' ' -f3)"
test "$DOCKER_LIBS" && MOUNT_DOCKER="
-v /var/run/docker.sock:/var/run/docker.sock
-v $DOCKER_LIBS:$DOCKER_LIBS:ro
-v $(which docker):$(which docker):ro
" || unset MOUNT_DOCKER
test -f ~/.docker/config.json && MOUNT_DOCKER="$MOUNT_DOCKER
-v $HOME/.docker/config.json:/mnt-ssh-config/docker-config.json:ro
"

docker pull "$IMAGE"
docker rm -f "$image_suffix"
exec docker run --name "$image_suffix" --hostname "$project_name" \
-d \
-p 2200:2200 -p 3000:3000 \
-v ~/.ssh/id_rsa.pub:/mnt-ssh-config/authorized_keys:ro \
-v ~/.ssh/id_rsa:/mnt-ssh-config/id_rsa:ro \
-v ~/.ssh/known_hosts:/mnt-ssh-config/known_hosts:ro \
$hgrc $gitconfig $m2dir $MOUNT_DOCKER \
-v "$DDE_BASH_HISTORY":/app/.bash_history \
-v "$DDE_VIMINFO":/app/.vim/viminfo \
-v "$DDE_UNDOFILES":/app/.vim/undofiles \
-v "$project_root":/data \
"$IMAGE" "$@"
