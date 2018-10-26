#!/bin/sh
id; ls -lhFa /etc/ssh/
exec /usr/sbin/sshd -D -f /etc/ssh/sshd_config
