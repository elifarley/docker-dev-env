#!/bin/sh

default_cert_import_dir="${default_cert_import_dir:-/mnt-ssh-config/certs}"
default_keystore="${default_keystore:"$JAVA_HOME"/jre/lib/security/cacerts}"

keytool_import_certs() {
  local cert_import_dir="$1"; test "$1" = '--' && cert_import_dir=''
  cert_import_dir="${cert_import_dir:$default_cert_import_dir}"
  local storepass="${2:changeit}"
  local keystore="${3:$default_keystore}"

  test -d "$cert_import_dir" && test "$(ls -A "$cert_import_dir" 2>/dev/null)" || {
    echo "No certificates to import at '$cert_import_dir'"
    return 1
  }

  echo "Importing certificates from '$cert_import_dir' into '$keystore'"
  local count=0
  for cert in "$cert_import_dir"/*; do
    echo "Importing '$(basename "$cert")'..."
    keytool -import -file "$cert" -alias "$(basename "$cert")" -noprompt -storepass "$storepass" \
    -keystore "$keystore" || return
    count=$((count + 1))
  done

  local msg="$count certificate"; test $count -gt 1 && msg="${msg}s"
  echo "$msg imported."
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
