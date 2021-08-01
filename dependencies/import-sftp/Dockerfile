FROM alpine:3.12.0

RUN apk add --no-cache openssh-server openssh-sftp-server openssh-server-pam rsyslog

ADD docker-entrypoint.sh /
ADD sshd_config /etc/ssh/sshd_config
ADD rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT exec /docker-entrypoint.sh
