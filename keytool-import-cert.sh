#!/bin/sh

keytool_import_cert_params() {
  exec keytool -import -file "$1" -alias "$2" -noprompt -storepass "$3" \
  -keystore "$4"
}

keytool_import_cert_interactive() {
  default_cert_import_path=/mnt-ssh-config/cert

  read -p "File path to import ($default_cert_import_path): " file
  file="${file:-"$default_cert_import_path"}"
  test -r "$file" && test -f "$file" || { echo "File not found: '$file'"; exit 1 ;}
  until test "$alias"; do read -p 'Type an alias for the certificate: ' alias; done
  read -p 'Type the store password (changeit): ' storepass; storepass="${storepass:-changeit}"

  keytool_import_cert_params "$file" "$alias" "$storepass" "$JAVA_HOME"/jre/lib/security/cacerts
}

test $# -eq 3 && { keytool_import_cert_params "$@"; return ;}

keytool_import_cert_interactive "$@"
