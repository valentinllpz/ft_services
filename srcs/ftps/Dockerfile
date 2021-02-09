FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update && \
	apk add --no-cache vsftpd

#TELEGRAF SETUP
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log
COPY /srcs/telegraf.conf /etc/telegraf/

EXPOSE 21
