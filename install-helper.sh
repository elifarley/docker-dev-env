#!/usr/bin/env sh

test "$DEBUG" && set -x
export IMAGE_INFO_FILE="$HOME"/docker-image.info

main() {
  local cmd="$1"; shift
  case "$cmd" in
    update-pkg-list)
      update_pkg_list "$@"
      ;;
    install-pkg)
      install_pkg "$@"
      ;;
    install)
      install "$@"
      ;;
    save-image-info)
      save_image_info "$@"
      ;;
    configure)
      configure "$@"
      ;;
    cleanup)
      cleanup "$@"
      ;;
    *)
      invalid_cmd "$cmd" "$@"
  esac
}

invalid_cmd() {
  echo "Usage: $0 update-pkg-list|install-pkg|install|save-image-info|configure|cleanup"
}

os_version() { (
  test -f /etc/os-release && . /etc/os-release
  local VERSION="$VERSION_ID"
  test -f /etc/debian_version && VERSION="$(cat /etc/debian_version)"
  echo "$PRETTY_NAME [$VERSION]"
) }

save_image_info() {
  printf 'Build date: %s %s' "$(date +'%F %T.%N')" "$(date +%Z)" >> "$IMAGE_INFO_FILE"
  printf 'Base image: %s\n%s\n(%s)\n' "$BASE_IMAGE" "$(os_version)" "$(uname -rsv)" >> "$IMAGE_INFO_FILE"
}

update_pkg_list() {

  os_version | grep Alpine && {
    update_pkg_list_alpine "$@" || return $?
    return 0
  }

  os_version | grep Debian && {
    update_pkg_list_debian "$@" || return $?
    return 0
  }

  os_version && return 1

}

update_pkg_list_alpine() {
  apk update
}

install() {
  local arg="$1"; shift
  case "$arg" in
    timezone)
      install_timezone "$@"
      ;;
    tini)
      install_tini "$@"
      ;;
    gosu)
      install_gosu "$@"
      ;;
    *)
      invalid_cmd "$arg" "$@"
  esac
}

install_tini() {
  test $# = 2 || {
    echo "Usage: $0 install tini <version> <sha1>"
    return 1
  }
  local version="$1"; shift
  local sha="$1"; shift
  curl -fsSL https://github.com/krallin/tini/releases/download/"$version"/tini-static -o /bin/tini && \
chmod +x /bin/tini && echo "$sha  /bin/tini" | sha1sum -wc -
}

install_gosu() {
  test $# = 2 || {
    echo "Usage: $0 install tini <version> <sha1>"
    return 1
  }
  local version="$1"; shift
  local sha="$1"; shift
  curl -fsSL https://github.com/tianon/gosu/releases/download/"$version"/gosu-amd64 -o /bin/gosu && \
chmod 755 /bin/gosu && echo "$sha  /bin/gosu" | sha1sum -wc -
}

install_timezone() {
  test "$TZ" || {
    echo "TZ is not set"
    return 1
  }
  os_version | grep Alpine && {
    install_timezone_alpine "$@" || return $?
    return 0
  }
  os_version | grep Debian && {
    install_timezone_debian "$@" || return $?
    return 0
  }
  os_version && return 1
}

install_timezone_alpine() {
  apk add --no-cache tzdata || return $?
  echo "TZ set to '$TZ'"
  echo $TZ > /etc/TZ
  cp -a /usr/share/zoneinfo/"$TZ" /etc/localtime || return $?
  apk del tzdata
}

install_pkg() {
  os_version | grep Alpine && {
    install_pkg_alpine "$@" || return $?
    return 0
  }
  os_version | grep Debian && {
    install_pkg_debian "$@" || return $? 
    return 0
  }
  os_version && return 1
}

install_pkg_alpine() {
  grep -q 'testing' /etc/apk/repositories || \
    echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
  apk add --no-cache "$@"
}

configure() {
  local arg="$1"; shift
  case "$arg" in
    sshd)
      configure_sshd "$@"
      ;;
    *)
      invalid_cmd "$arg" "$@"
  esac
}

configure_sshd() {
  os_version | grep Alpine && {
    configure_sshd_alpine "$@" || return $?
    return 0
  }
  os_version | grep Debian && {
    configure_sshd_debian "$@" || return $? 
    return 0
  }
  os_version && return 1
}

configure_sshd_alpine() {
  sed -e '/Port/d;/UsePrivilegeSeparation/d;/PermitRootLogin/d;/PermitUserEnvironment/d;/UsePAM/d;/UseDNS/d;/PasswordAuthentication/d;/ChallengeResponseAuthentication/d;/Banner/d;/PrintMotd/d;/PrintLastLog/d' \
    /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp || return $?
  printf "\nPort 2200\nUsePrivilegeSeparation no\nPermitRootLogin no\nPasswordAuthentication no\nChallengeResponseAuthentication no\nPermitUserEnvironment yes\nUseDNS no\nPrintMotd no\n\n#---\n" \
    > /etc/ssh/sshd_config || return $?
  cat /etc/ssh/sshd_config.tmp >> /etc/ssh/sshd_config || return $?
  rm /etc/ssh/sshd_config.tmp || return $?
  cp -a /etc/ssh /etc/ssh.cache
}

cleanup() {

  rm -rf /var/tmp/* /tmp/* || return $?

  os_version | grep Alpine && {
    cleanup_alpine "$@" || return $?
    return 0
  }

  os_version | grep Debian && {
    cleanup_debian "$@" || return $?
    return 0
  }

}

cleanup_alpine() {
  rm -rf /var/cache/apk/*
}

main "$@"
