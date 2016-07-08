#!/bin/bash -e
# See https://wiki.apache.org/tomcat/HowTo/FasterStartUp#Entropy_Source
exec java \
  -Djava.security.egd=file:/dev/./urandom \
  -jar "$HOME"/app.jar "$@"
