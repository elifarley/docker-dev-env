#!/bin/bash -e
exec java \
  -Djava.security.egd=file:/dev/./urandom \
  -Dspring.profiles.active="$SPRING_PROFILE" \
  -jar "$HOME"/app.jar "$@"
