FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update

### TELEGRAF SETUP ###
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log
COPY /srcs/telegraf.conf /etc/telegraf/

### MYSQL SETUP ###
RUN	apk add --no-cache mysql mysql-client
COPY /srcs/conf.sql /tmp/
COPY /srcs/wordpress.sql /tmp/

COPY /srcs/init_mariadb.sh /tmp/

EXPOSE 3306

ENTRYPOINT ["sh", "/tmp/init_mariadb.sh"]