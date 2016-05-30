test "$DEBUG" && set -x

main() {
  local cmd="$1"; shift
  case "$cmd" in
    install-pkg)
      install_pkg "$@"
      ;;
    install)
      install "$@"
      ;;
    save-image-info)
      save_image_info "$@"
      ;;
    cleanup)
      cleanup "$@"
      ;;
    *)
      invalid_cmd "$cmd" "$@"
  esac
}

invalid_cmd() {
  echo "Usage: $0 install-pkg|install|save-image-info|cleanup"
}

os_version() { (
  test -f /etc/os-release && . /etc/os-release
  local VERSION="$VERSION_ID"
  test -f /etc/debian_version && VERSION="$(cat /etc/debian_version)"
  echo "$PRETTY_NAME [$VERSION]"
) }

save_image_info() {
  echo -ne "BASE_IMAGE: $BASE_IMAGE\n$(os_version)\n($(uname -rsv))\n" >> /$HOME/docker-image.info
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
    save-image-info)
      save_image_info "$@"
      ;;
    *)
      invalid_cmd "$cmd" "$@"
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
  apk --update add --no-cache tzdata || return $?
  echo "TZ set to '$TZ'"
  echo $TZ > /etc/TZ
  cp -a /usr/share/zoneinfo/"$TZ" /etc/localtime || return $?
  apk del tzdata || return $?
  cleanup
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
  apk --update add --no-cache "$@"
}

cleanup() {
  rm -rf /var/tmp/* /tmp/* || return $?
  os_version | grep Alpine && cleanup_alpine "$@"
  os_version | grep Debian && cleanup_debian "$@"
}

cleanup_alpine() {
  rm -rf /var/cache/apk/*
}

main "$@"
