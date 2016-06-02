#!/bin/bash -e
exec java \
  -Dspring.profiles.active="$SPRING_PROFILE" \
  -Djava.security.egd=file:/dev/urandom \
  -jar "$HOME"/app.jar "$@"
