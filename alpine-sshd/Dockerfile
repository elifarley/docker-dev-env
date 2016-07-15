FROM elifarley/docker-cep:alpine
MAINTAINER Elifarley <elifarley@gmail.com>

ARG APK_PACKAGES="openssh"

# SSHD
EXPOSE 2200

COPY . "$HOME"/

RUN \
  xinstall add-pkg && \
  xinstall configure sshd && \
  xinstall cleanup && \
  chmod +x "$HOME"/*app*.sh && chown "$_USER":"$_USER" "$HOME"/*app.sh
