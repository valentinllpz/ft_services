FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update

### TELEGRAF SETUP ###
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log
COPY /srcs/telegraf.conf /etc/telegraf/

### OPENRC SETUP ###  (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add --no-cache openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

### SSL SETUP ###
RUN apk add --no-cache openssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem >/dev/null 2>&1

### FTPS SETUP ###
RUN apk add --no-cache vsftpd && \
	adduser --disabled-password --home etc/vsftpd/home ftps_vlugand- && \
	echo "ftps_vlugand-:ZnRwc0BmdF81M3J2MWMzNQo=" | chpasswd && \
	echo 'This is only a test.' >> etc/vsftpd/home/test
COPY /srcs/vsftpd.conf /etc/vsftpd/

COPY /srcs/init_ftps.sh /tmp/

EXPOSE 21 4000

ENTRYPOINT ["sh", "tmp/init_ftps.sh"]