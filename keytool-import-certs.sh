#!/bin/sh

default_cert_import_dir="${default_cert_import_dir:-/mnt-ssh-config/certs}"
default_keystore="${default_keystore:"$JAVA_HOME"/jre/lib/security/cacerts}"

keytool_import_certs() {
  local cert_import_dir="${1:$default_cert_import_dir}"
  local storepass="${2:changeit}"
  local keystore="${3:$default_keystore}"

  test -d "$cert_import_dir" && test "$(ls -A "$cert_import_dir" 2>/dev/null)" || {
    echo "No certificates found at '$cert_import_dir'"
    return 1
  }

  for cert in "$cert_import_dir"/*; do
    exec keytool -import -file "$cert" -alias "$(basename "$cert")" -noprompt -storepass "$storepass" \
    -keystore "$keystore" || return
  done
}

keytool_import_certs_interactive() {

  cert_import_dir="$1"; storepass="$2"; keystore="$3"

  test "$cert_import_dir" || \
    read -p "Path to directory with certificates to import ($default_cert_import_dir): " cert_import_dir

  test "$storepass" || \
    read -p 'Type the store password (changeit): ' storepass

  test "$keystore" || \
    read -p "Path to the key store ($default_keystore): " keystore

  keytool_import_certs "$cert_import_dir" "$storepass" "$keystore"
}

test $# -gt 0 && { keytool_import_certs "$@"; return ;}

keytool_import_certs_interactive "$@"
