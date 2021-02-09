FROM alpine:3.13

# OPENRC SETUP (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add --no-cache openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

# INFLUXDB SETUP
RUN apk update && \
    apk add --no-cache influxdb --no-cache 
COPY /srcs/init_influxdb.sh /tmp/

#TELEGRAF SETUP
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log

COPY /srcs/telegraf.conf /etc/telegraf/


EXPOSE 8086

ENTRYPOINT ["sh", "/tmp/init_influxdb.sh"]