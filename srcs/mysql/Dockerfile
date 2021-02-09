FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

#MYSQL INSTALLATION
RUN apk update && \
	apk add --no-cache mysql mysql-client

#OPENRC SETUP (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add --no-cache openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

COPY /srcs/init_mariadb.sh /tmp/
COPY /srcs/conf.sql /tmp/

#TELEGRAF SETUP
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log
COPY /srcs/telegraf.conf /etc/telegraf/

EXPOSE 3306

ENTRYPOINT ["sh", "/tmp/init_mariadb.sh"]